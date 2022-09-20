enviroment = "lab"
min_size = 2
max_size = 4
desired_capacity = 4
enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
metrics_granularity = "1Minute"
key_name = "gabriel-ec2"
instance_port = 80
instance_type = "t3.medium"
instance_protocol = "http"
network_mode = "bridge"
memory = "2048"
cpu = "1024"
requires_compatibilities = "EC2"
desired_count = 4
launch_type = "EC2"



