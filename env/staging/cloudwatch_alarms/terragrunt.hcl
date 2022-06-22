include {
  path = find_in_parent_folders()
}

# These will be used later once the apply is complete
dependencies {
  paths = ["../dynamodb", "../api_gateway"]
}

terraform {
  source = "../../../aws//empty"
}
