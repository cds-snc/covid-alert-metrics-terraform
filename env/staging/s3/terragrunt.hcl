
include {
  path = find_in_parent_folders()
}

inputs = {
  error_sampling_lifecycle_days = 7
}

terraform {
  source = "../../../aws//s3"
}
