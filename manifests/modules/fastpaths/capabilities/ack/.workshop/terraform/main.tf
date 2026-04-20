data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IRSA role for the carts microservice ServiceAccount.
# Trusts the `carts` ServiceAccount in the `carts` namespace and allows full
# access to the lab-scoped DynamoDB table only.
module "iam_assumable_role_carts" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.60.0"
  create_role                   = true
  role_name                     = "${var.addon_context.eks_cluster_id}-carts-ack"
  provider_url                  = var.addon_context.eks_oidc_issuer_url
  role_policy_arns              = [aws_iam_policy.carts_dynamo.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:carts:carts"]

  tags = var.tags
}

resource "aws_iam_policy" "carts_dynamo" {
  name        = "${var.addon_context.eks_cluster_id}-carts-dynamo"
  path        = "/"
  description = "DynamoDB access policy for the carts microservice"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllAPIActionsOnCart",
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": [
        "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.addon_context.eks_cluster_id}-carts-ack",
        "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.addon_context.eks_cluster_id}-carts-ack/index/*"
      ]
    }
  ]
}
EOF
  tags   = var.tags
}

# IRSA role for the ACK DynamoDB controller ServiceAccount.
# Trusts the `ack-dynamodb-controller` ServiceAccount in the `ack-system`
# namespace and allows managing the lab-scoped DynamoDB table.
resource "aws_iam_policy" "ack_dynamo" {
  name        = "${var.addon_context.eks_cluster_id}-ack-dynamo"
  path        = "/"
  description = "DynamoDB policy for the ACK DynamoDB controller"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllAPIActionsOnCart",
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": [
        "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.addon_context.eks_cluster_id}-carts-ack",
        "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.addon_context.eks_cluster_id}-carts-ack/index/*"
      ]
    }
  ]
}
EOF
  tags   = var.tags
}

module "iam_assumable_role_ack" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.60.0"
  create_role                   = true
  role_name                     = "${var.addon_context.eks_cluster_id}-ack-controller"
  provider_url                  = var.addon_context.eks_oidc_issuer_url
  role_policy_arns              = [aws_iam_policy.ack_dynamo.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:ack-system:ack-dynamodb-controller"]

  tags = var.tags
}
