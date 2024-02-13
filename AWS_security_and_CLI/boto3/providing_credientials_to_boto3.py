import boto3

# ACCESS_KEY = input("Enter access key: ")
# SECRET_KEY = input("Enter secret key: ")
ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
)

s3 = session.client("s3")
buckets = s3.list_buckets()

# buckets['Buckets']
for bucket in buckets['Buckets']:
    print(bucket['Name'])