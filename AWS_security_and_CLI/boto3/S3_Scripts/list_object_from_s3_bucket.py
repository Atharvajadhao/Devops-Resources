import boto3 

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
)

s3 = session.client("s3")

objects = s3.list_objects(
    Bucket='my-static-website-bucket-01',
)

# print(objects['Contents'])
for item in objects['Contents']:
    print(item['Key'])

