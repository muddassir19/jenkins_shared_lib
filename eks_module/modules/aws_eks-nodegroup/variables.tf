variable "eks_cluster_name" {
  
}

variable "node_group_name" {
  
}

variable "subnet_ids" {
  default = ["subnet-09d4ae65e8eaccd49","subnet-0aec8e35a6ad11267","subnet-0f9680fec0cd12cbd"]
}

variable "tags" {
  
}

variable "nodes_iam_role" {
  default = "eks-node-group-general"
}