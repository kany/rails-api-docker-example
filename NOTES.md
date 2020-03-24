
Compose:
========
Make sure Docker is running before creating a new rails api application
> docker-compose run web rails new . --api --force --no-deps --database=mysql


Build:
======
Mac or Windows users:
> docker-compose build

Linux users:
> sudo chown -R $USER:$USER .
> docker-compose build

Run Database Commands:
================
> docker-compose run web rake db:create && \
docker-compose run web rake db:migrate && \
docker-compose run web rake db:seed && \
docker-compose run web rake db:test:prepare

Run:
====
> docker-compose up

Postman:
https://www.getpostman.com/collections/5c66b86b3a4a6a6c128b