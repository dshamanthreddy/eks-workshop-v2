output "environment_variables" {
  description = "Environment variables exported into the IDE shell"
  value = {
    CLOUDWATCH_LOG_GROUP_NAME = aws_cloudwatch_log_group.fluentbit.name
    EKS_CAP_DDB_TABLE         = local.eks_cap_carts_table_name
    EKS_CAP_ACK_CAPABILITY    = aws_eks_capability.ack.capability_name
  }
}
