#!/bin/bash
sudo yum install php -y
sudo mv index.php /var/www/html/index.php
sudo chkconfig --level 35 httpd on
