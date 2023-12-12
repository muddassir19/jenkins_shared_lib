aws_eks_cluster_config = {
    
    "demo-cluster" = {
                
        eks_cluster_name         = "demo-cluster1"
        eks_subnet_ids = ["subnet-09d4ae65e8eaccd49","subnet-0aec8e35a6ad11267","subnet-0f9680fec0cd12cbd"]
        tags = {
            "Name" =  "demo-cluster"
        }  
    }
}

eks_node_group_config = {
    "node1" = {
        
        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-09d4ae65e8eaccd49","subnet-0aec8e35a6ad11267","subnet-0f9680fec0cd12cbd"]
        
        tags = {
            "Name" =  "node1"
        } 
    }
}