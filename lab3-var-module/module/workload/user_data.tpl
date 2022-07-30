sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
sudo docker run -p 80:80 gbrmelo/${img_repo}:${img_tag}