import boto3
import json
import os
from datetime import datetime,timezone
from common.constants import *

aws_key = os.getenv("AWS_ACCESS_KEY_ID")
s3 = None
if aws_key and aws_key.strip():
    try:
        s3 = boto3.client(
            "s3",
            aws_access_key_id=aws_key,
            aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
            region_name=os.getenv("AWS_REGION", "us-east-1") # Provides a default region
        )
        print("S3 client initialized successfully.")
    except Exception as e:
        print(f"Error initializing S3: {e}")
        s3 = None

BUCKET_NAME = os.getenv("AWS_S3_BUCKET")

def upload_incident_snapshot(incident: dict):
    date_path = datetime.now(timezone.utc).strftime("%Y/%m/%d")
    key = f"incidents/{date_path}/incident_{incident['id']}.json"

    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(incident, default=str),
        ContentType="application/json",
    )

def create_incident_payload(incident):
    if s3 is None:
        return
    upload_incident_snapshot({
            "id": incident.id,
            "title": incident.title,
            "description": incident.description,
            "severity": SEVERITY_NAME.get(incident.severity, "Unknown"),
            "status": INCIDENT_STATUS_NAME.get(incident.status, "Unknown"),
            "environment": incident.environment.env_name,
            "business_unit": incident.business_unit.business_unit_name,
            "erp_module": incident.erp_module.erp_name,
            "category": incident.categories.category_name,
            "created_at": incident.created_at
        })