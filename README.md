Demo Cross-Account AWS Lambda Invocation with Resource Policies
===============================================================

This repository contains terraform to setup four AWS accounts to demonstrate
cross-account invocation of Lambdas.  It also includes some NodeJS code
for testing the Lambda invocation.

Setup
-----

The providers.tf file contains the configuration for the four accounts.  By
default they will aquire their account information from the AWS CLI configuration
profiles: devops, development, testing, and production. 
