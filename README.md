# web-app-deployment-aws-terraform

# Configuration Details

# ec2 Instance Type
there are several factors that need to be taken into consideration when selecting the instance type such as if the performance will need to be Compute, Network or Storage Optimised 

As the application's needs are unknown its probably best to start , a General Purpose Instance which offers a well-rounded mix of computing power, memory, and networking capabilities suitable for various workloads. Within the General Purpose instance family  M5 could be to used to start off with as it is the middle type of the General Purpose, we have the flexibility to reassess CPU utilization and seamlessly increase or decrease or even change to N, if necessary, very easily.

# rds instance
Tailoring to the application's needs, AWS provides a choice among various database engines like MySQL, SQL Server, Oracle, Postgres, also there is the serverless RDS called Arora. An study would need be conducted of the application requirements to select which choice would be best and then would have to be sized appropriately.

With disaster recovery in focus, our strategy involves Multi AZ RDS deployment as shown in the diagram, For Multi region resleliancy  from each region to another. If an RDS instance in one region encounters a failure, the traffic seamlessly redirects to the replicated instance, ensuring continuous application availability.  

# S3 Configurations

The S3 bucket will be set to private since it is intended for storing static pages and images exclusively for our web application.

# Securiy measures

# Security Group Configurations

The inbound rules for the security group associated with the instance will include:

1. Allow traffic on Port 22 for SSH access to the instance.
2. Allow traffic on Port 80 to enable internet access to the machine.

# Encryption in Transit Principles

Internet Gateway routing only from the public subnets and not private subnets. 
Public subnets should only allow communication for encrypted public protocols   eg  SSL, SSH 
Private Subnets communication should be as secure as possible eg only using MTLS, TLS etc,
VPC subnet NACLS and SG's are used to ensure network traffic is locked down based on required protocols necessary above.

# Encryption at Rest Principles

eg use KMS keys to encrypt RDS storage and AWS Volumes
SSL and MTLS should be certificate authentication should be used Trusted Certificate Authority  such as AWS Certificates Manager


OS Hardened Images should be used for EC2 Instances
AWS Security Hub Review


# Total Monthly Costs

The total monthly cost for the configuration that is being currently used will be $509.63

https://aws.amazon.com/blogs/database/deploy-amazon-rds-on-aws-outposts-with-multi-az-high-availability/