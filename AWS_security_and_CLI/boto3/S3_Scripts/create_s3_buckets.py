import boto3

# ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
# SECRET_KEY = "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"

# session = boto3.Session(
#     aws_access_key_id=ACCESS_KEY,
#     aws_secret_access_key=SECRET_KEY,
# )

client = boto3.client('s3')

response = client.create_bucket(
    Bucket='atharva-unique-s3-bucket'
)

print(response)