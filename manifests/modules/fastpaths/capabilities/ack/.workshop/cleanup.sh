#!/bin/bash

# Clean up everything the learner created during Lab 1 (ACK).
# IAM roles and policies are owned by Terraform, so prepare-environment will
# handle them on the next lab switch.

logmessage "Deleting ACK DynamoDB Table custom resources..."

delete-all-if-crd-exists tables.dynamodb.services.k8s.aws

logmessage "Uninstalling the ACK DynamoDB controller..."

uninstall-helm-chart ack-dynamodb-controller ack-system

logmessage "Deleting the ack-system namespace if empty..."

kubectl delete namespace ack-system --ignore-not-found=true
