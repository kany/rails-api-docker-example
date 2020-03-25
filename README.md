## Vend-O-Matic

Docker + Rails API + MySQL example

#### Docker Instructions

1. Make sure Docker is running
2. Build the docker container with `docker-compose build`
3. Run the rake tasks:
```
docker-compose run web rake db:create &&
docker-compose run web rake db:migrate &&
docker-compose run web rake db:seed &&
docker-compose run web rake db:test:prepare
``` 
4. Start the application with `docker-compose up`
5. The app should be running on `http://localhost:3000`

#### Test it out with Postman
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/5c66b86b3a4a6a6c128b)


