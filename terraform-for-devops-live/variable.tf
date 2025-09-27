variable "ec2_instance_type" {
  default = "t2.micro"
  type = string
}

variable "ec2_root_storage_size" {
  default = 15
  type = number
}

variable "ec2_ami_id" {
  default = "ami-02d26659fd82cf299"
  type = string
}

