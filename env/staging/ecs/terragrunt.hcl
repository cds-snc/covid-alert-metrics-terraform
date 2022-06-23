dependencies {
  paths = ["../network", "../s3", "../ecr", "../dynamodb"]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//empty"
}
