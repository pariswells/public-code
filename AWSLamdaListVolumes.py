import boto3

def lambda_handler(event, context):
# TODO implement
userID='%%%%%%%' # redundancy user account ID
ec2 = boto3.client('ec2')
volumes = ec2.describe_volumes()
ec2Resource=boto3.resource('ec2')
for volume in volumes['Volumes']:
for attachment in volume['Attachments']:
instance=ec2Resource.Instance(attachment[u'InstanceId'])
instanceName=instance.tags[0][u'Value']
print "Backing up %s in %s" % (volume['VolumeId'], volume['AvailabilityZone'])
break
snapshots = ec2.describe_snapshots(Filters=[{ 'Name': 'owner-id','Values':[userID] }])
for snapshot in snapshots['Snapshots']:
print "Backing up %s in %s" % (instanceName, snapshot['SnapshotId'], volume['AvailabilityZone'])
