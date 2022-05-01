enviroment = "lab"
min_size = 2
max_size = 2
desired_capacity = 2
enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
metrics_granularity = "1Minute"
key_name = "gabriel-aws"
instance_port = 80
ami = "ami-04b1cc313d8405c9b"
instance_type = "t2.micro"
instance_protocol = "http"

