enviroment = "lab"
min_size = 2
max_size = 2
desired_capacity = 2
enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
metrics_granularity = "1Minute"
key_name = "gabriel-ec2"
instance_port = 80
ami = "ami-0b4851d217c36f03a"
instance_type = "t2.micro"
instance_protocol = "http"


