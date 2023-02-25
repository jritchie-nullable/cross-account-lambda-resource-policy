terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
}

provider "aws" {
  alias   = "development"
  profile = "development"
}

provider "aws" {
  alias   = "testing"
  profile = "testing"
}

provider "aws" {
  alias   = "production"
  profile = "production"
}

provider "aws" {
  alias   = "orchistration"
  profile = "orchistration"
}

