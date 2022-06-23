include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dynamodb", "../sqs"]
}

terraform {
  source = "../../../aws//empty"
}
