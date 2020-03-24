Make sure Docker is running

docker-compose run web rails new . --api --force --no-deps --database=mysql


Mac or Windows users:
docker-compose build

Linux users:
sudo chown -R $USER:$USER .
docker-compose build