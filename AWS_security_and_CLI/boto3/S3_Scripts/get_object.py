import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
)

s3 = session.client("s3")

getObject = s3.get_object(
    Bucket="my-static-website-bucket-01",
    Key="linus.jpeg"
)

print(getObject['ContentType'])