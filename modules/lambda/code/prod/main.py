import json
import logging
import os
import uuid
import boto3
from datetime import datetime, timezone

logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))

dynamodb = boto3.resource("dynamodb")
environment = os.getenv("ENVIRONMENT", "staging")
table = dynamodb.Table(f"{environment}-requests-db")

def lambda_handler(event, context):
    logger.info(f"Incoming request event: {json.dumps(event)}")

    request_time = int(datetime.now(timezone.utc).timestamp() * 1000)
    request_id = f"{request_time}-{uuid.uuid4()}"

    method = (
        event.get("requestContext", {})
             .get("http", {})
             .get("method")
        or event.get("httpMethod")
    )

    item = {
        "request_id": request_id,
        "method": method,
        "path": event.get("rawPath"),
        "query_params": event.get("queryStringParameters") or {},
        "path_params": event.get("pathParameters") or {},
    }

    body = json.loads(event.get("body") or {}) if method == "POST" else {}

    if body:
        item["body"] = body

    table.put_item(Item=item)

    if  "payload" not in body:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "Bad Request",
                "message": "POST request body with 'payload' key is required."
            })
        }

    return {
        "statusCode": 200,
        "body": json.dumps({
            "status": "healthy",
            "message": "Request processed and saved."
        })
    }