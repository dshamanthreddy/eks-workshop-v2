output "environment_variables" {
  description = "Environment variables to be added to the IDE shell"
  value = {
    CARTS_IAM_ROLE     = module.iam_assumable_role_carts.iam_role_arn
    ACK_IAM_ROLE       = module.iam_assumable_role_ack.iam_role_arn
    DYNAMO_ACK_VERSION = var.dynamo_ack_version
  }
}
