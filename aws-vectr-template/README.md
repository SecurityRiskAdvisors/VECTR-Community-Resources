# VECTR AWS QuickStart Template
This template deploys VECTR to be used as an evaluation only and not to be used in any production capacity.  After the instance is deployed, the URL can be found on the 'Outputs' tab of the CloudFormation stack and the default username
and password are on the [official docs site](https://docs.vectr.io/Installation/#usage)

---
## AWS Requirements
#### Your AWS account must be able to create the following resources
* EC2
  * VPC
  * SecurityGroup
  * Subnet
  * InternetGateway
  * VPCGatewayAttachment
  * RouteTable
  * Route
  * SubnetRouteTableAssociation
  * NetworkAcl
  * NetworkAclEntry
  * SubnetNetworkAclAssociation
  * Instance
* IAM
  * InstanceProfile
  * Role

#### Supported Regions
* us-east-1
* us-west-1
* eu-central-1
* eu-west-2

