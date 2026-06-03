import json
import logging
import uuid
import boto3
from datetime import datetime, timezone

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("prod-requests-db")

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

    if method == "POST":
        item["body"] = json.loads(event.get("body") or {})

    table.put_item(Item=item)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "status": "healthy",
            "message": "Request processed and saved."
        })
    }