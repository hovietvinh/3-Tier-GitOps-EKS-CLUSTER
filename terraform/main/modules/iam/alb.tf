resource "aws_iam_policy" "alb_controller_policy" {
  name   = "${var.project_name}-${var.env}-alb-controller-policy"
  policy = file("${path.module}/policies/alb_controller_iam_policy.json")
}