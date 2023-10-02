variable "name" {
  type = string
}

variable "ports" {
  type = list(number)
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}

variable "size" {
  type = number
}
