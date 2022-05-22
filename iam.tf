resource "aws_iam_role" "amazon_ec2_role_for_get_info" {
  name               = "AmazonEC2RoleForGetInfo"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "amazon_ec2_get_info_policy" {
  name   = "AmazonEC2GetInfo"
  role   = aws_iam_role.amazon_ec2_role_for_get_info.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:DescribeNetworkInterfaces",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "amazon_ec2_role_for_get_info_iam" {
  name = "amazon_ec2_role_for_get_info_iam"
  role = aws_iam_role.amazon_ec2_role_for_get_info.name
}

