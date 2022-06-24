include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dynamodb", "../sqs", "../api_gateway"]
}

terraform {
  source = "../../../aws//empty"
}
