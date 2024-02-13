import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY
)

s3 = session.client("s3")

response = s3.upload_file(
    "F:/Bridge_Labz/CFP-003/AWS_security_and_CLI/boto3/S3_Scripts/testFile.txt",
    "my-static-website-bucket-01",
    "testFile.txt"
)

print(response)