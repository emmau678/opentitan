#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse
import logging
import sqlite3
import sys

from google.auth.exceptions import DefaultCredentialsError
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter

from util import OT_SQL_TABLE_NAME


def _row_to_dict(row):
    return {
        "device_id": row[0],
        "test_unlock_token": row[1],
        "test_exit_token": row[2],
        "enc_rma_unlock": row[3],
        "device_ecc_pub_key_x": row[4],
        "device_ecc_pub_key_y": row[5],
        "host_ecc_priv_keyfile": row[6],
        "uds_cert_pub_key_x": row[7],
        "uds_cert_pub_key_y": row[8],
        "lc_state": row[9],
        "sku": row[10],
        "commit_hash": row[11],
        "timestamp": row[12]
    }


def _duplicate_prompt(device_id):
    print(f"Device ID {device_id} already exists in the remote database.")
    print("Please provide one of the following options:")
    print("- 'skip': skip this entry and keep it in local DB (default)")
    print("- 'remove': skip this entry and remove it from local DB")
    print("- 'overwrite': replace existing entry in remote DB")
    choice = input("> ")

    if choice in {"skip", "remove", "overwrite"}:
        return choice

    return "skip"


def _delete_entry(local_db, device_id):
    logging.debug(f"Deleting local record for {device_id}...")
    local_db.cursor().execute(f"DELETE from {OT_SQL_TABLE_NAME} where device_id = '{device_id}'")
    local_db.commit()


def update_remote_db(project, local_db):
    logging.info("Uploading local records to remote database")
    cursor = local_db.cursor()

    res = cursor.execute(f"SELECT * FROM {OT_SQL_TABLE_NAME}")
    rows = res.fetchall()

    cursor.close()

    remote_db = firestore.Client(project=project)
    devices_ref = remote_db.collection("devices")

    count = 0

    for row in rows:
        data = _row_to_dict(row)
        device_id = data["device_id"]
        logging.debug(f"Uploading record for {device_id}...")

        query = devices_ref.where(filter=FieldFilter("device_id", "==", device_id))
        devices = query.get()

        if len(devices) > 0:
            choice = _duplicate_prompt(device_id)
            logging.warning(
                f"Device ID {device_id} already exists in remote database. "
                f"User chose to {choice}."
            )

            if choice == "skip":
                continue
            elif choice == "remove":
                _delete_entry(local_db, device_id)
                continue
            elif choice == "overwrite":
                # fall-through to default logic
                pass
            else:
                assert False

        count += 1
        doc_ref = devices_ref.document(device_id)
        doc_ref.set(data)

        _delete_entry(local_db, device_id)

    logging.info(f"Successfully uploaded {count} record(s) to remote database")


def main():
    logging.basicConfig(level=logging.INFO)

    parser = argparse.ArgumentParser(
        prog="Remote Database Update",
        description="This tool updates the ES provisioning remote database with "
                    "locally cached device registrations.",
    )
    parser.add_argument("db_path",
                        help="Path to .db file generated by orchestrator.py")
    parser.add_argument("--project", required=True,
                        help="Name of Google Cloud project with Firestore database to update")
    args = parser.parse_args()

    local_db = sqlite3.connect(args.db_path)

    try:
        update_remote_db(args.project, local_db)
    except DefaultCredentialsError:
        print(
            "Not authenticated to gcloud. Please run "
            "`gcloud auth application-default login` to generate credentials"
        )
        sys.exit(1)

    res = local_db.cursor().execute(f"SELECT * FROM {OT_SQL_TABLE_NAME}")
    rows = res.fetchall()
    if len(rows) == 0:
        print(f"All local records uploaded! You may safely delete {args.db_path}")
    else:
        print(f"{len(rows)} record(s) remaining in {args.db_path}")
        print("Re-run update_remote_db.py to upload remaining records")


if __name__ == "__main__":
    main()
