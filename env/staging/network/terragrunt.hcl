inputs = { 
  name = "metricsstaging"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//network"
}
