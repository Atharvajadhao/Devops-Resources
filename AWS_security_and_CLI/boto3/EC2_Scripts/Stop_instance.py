import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
)

ec2 = session.client('ec2')
response = ec2.stop_instances(
    InstanceIds = [
        "i-0bc54ba08fc26e564"
    ]
)

print(response)