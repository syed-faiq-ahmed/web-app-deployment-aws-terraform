ports                     = [80, 8080]
image_id                  = ""
instance_type             = "t2.micro"
min_size                  = 1
max_size                  = 2
desired_capacity          = 1
health_check_grace_period = 300
domain_name               = "ur.com"
record_name               = "app2.url.com"