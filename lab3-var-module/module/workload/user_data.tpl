
sudo su
systemctl enable docker.service
systemctl enable containerd.service
docker run -p 80:80 gbrmelo/${img_repo}:${img_tag}