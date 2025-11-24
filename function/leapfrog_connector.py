#!/usr/bin/python

"""
Leapfrog Connector Lambda Function
Sends alerts to the Leapfrog Platform.
"""

import json
import os
import boto3
import requests
from botocore.config import Config
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    """AWS Lambda Function Handler for Leapfrog Connector"""

    print(f"Received event: {json.dumps(event)}")

    # Validate event structure
    if "Records" not in event:
        print("ERROR: Invalid event structure - 'Records' key not found.")
        return {"statusCode": 400, "body": "Invalid event structure"}

    if not event["Records"] or "Sns" not in event["Records"][0]:
        print("ERROR: Invalid SNS event structure")
        return {"statusCode": 400, "body": "Invalid SNS event structure"}

    print("Creating AWS SSM client...")
    ssm_client = boto3.client(
        "ssm",
        config=Config(connect_timeout=5, read_timeout=60, retries={"max_attempts": 5}),
    )

    # Extract data from the event
    sns_record = event["Records"][0]["Sns"]
    event_title = str(sns_record.get("Subject", "Leapfrog Alert"))
    event_message = str(sns_record.get("Message", "{}"))
    
    try:
        event_message_json = json.loads(event_message)
    except json.JSONDecodeError:
        event_message_json = {"raw_message": event_message}

    # Fetch Leapfrog configuration from SSM
    api_key_param_name = os.getenv("LEAPFROG_API_KEY_PARAM_NAME")
    org_id_param_name = os.getenv("LEAPFROG_ORG_ID_PARAM_NAME")

    if not api_key_param_name or not org_id_param_name:
        print("ERROR: Leapfrog SSM parameter names not configured in environment variables.")
        return {"statusCode": 500, "body": "Configuration error"}

    try:
        print(f"Fetching API Key from {api_key_param_name}...")
        api_key = ssm_client.get_parameter(Name=api_key_param_name, WithDecryption=True)["Parameter"]["Value"]
        
        print(f"Fetching Org ID from {org_id_param_name}...")
        org_id = ssm_client.get_parameter(Name=org_id_param_name)["Parameter"]["Value"]
    except ClientError as e:
        print(f"ERROR: Failed to fetch parameters from SSM: {e}")
        return {"statusCode": 500, "body": "Failed to fetch configuration"}

    # Prepare payload for Leapfrog Platform
    leapfrog_api_url = "https://api.leapfrog.tech/v1/alerts"

    payload = {
        "org_id": org_id,
        "title": event_title,
        "data": event_message_json,
        "source": "aws-leapfrog-integration"
    }

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    print(f"Sending alert to Leapfrog Platform: {leapfrog_api_url}")
    
    try:
        response = requests.post(leapfrog_api_url, json=payload, headers=headers, timeout=10)
        response.raise_for_status()
        print(f"Alert sent successfully to Leapfrog. Status: {response.status_code}")
        return {"statusCode": 200, "body": "Alert processed successfully"}
    except requests.exceptions.RequestException as e:
        print(f"ERROR: Failed to send alert to Leapfrog: {e}")
        # Return 200 to avoid SNS retries for permanent errors
        return {"statusCode": 200, "body": f"Alert processing failed: {str(e)}"}
