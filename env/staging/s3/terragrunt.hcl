
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//s3"
}
