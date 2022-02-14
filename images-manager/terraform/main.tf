resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private" 
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"bucket-read-only",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::bucket/*"]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_name
  handler          = "index.handler"
  runtime          = "nodejs14.17"
  //filename         = "function.zip"
  source_path      = "../image-manager"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.bucket.arn}"
}
