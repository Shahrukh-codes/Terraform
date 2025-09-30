resource "aws_s3_bucket" "remote_s3" {
  bucket = "saim-junoon-state-bucket"

  tags = {
    Name = "saim-junoon-state-bucket"
  }


  force_destroy = true
}
