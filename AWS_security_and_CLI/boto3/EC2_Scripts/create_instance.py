import boto3

ACCESS_KEY = "AKIAUIBNA22BGFKV44LZ"
SECRET_KEY = "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"

session = boto3.Session(
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY
)

ec2 = session.client("ec2")
response = ec2.run_instances(
    ImageId="ami-09d429cdd9cd68510",
    InstanceType="t2.micro",
    KeyName="NewKeyPair",
    MaxCount=1,
    MinCount=1,
    SecurityGroupIds=[
        'sg-0dc8c11dcc674fc33'
    ],
    SubnetId="subnet-028cc28001feb5aab",
    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [
                {
                    "Key": "Name",
                    "Value": "testInstance"
                }
            ]
        }
    ]
)

print(response)