import boto3
import os

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']
    s3 = boto3.client('s3')
    
    for record in event['Records']:
        file_name = record['s3']['object']['key']
        print(f"Processing file: {file_name} from bucket: {bucket_name}")
    
    return {
        'statusCode': 200,
        'body': 'File processed successfully!'
    }
}
