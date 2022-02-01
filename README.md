# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


docker-compose.yml
```
version: '3'
services:
  db:
    image: mysql:8.0
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - ./src/db/mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: password
  api:
    build: 
      context: ./api/
      dockerfile: Dockerfile
    command: /bin/sh -c "rm -f /myapp/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - ./api/src:/myapp
      - ./api/src/vendor/bundle:/myapp/vendor/bundle
    ports:
      - "3000:3000"
    environment:
      TZ: Asia/Tokyo
      RAILS_ENV: development
    depends_on:
      - db
  front:
    build:
      context: ./front/
      dockerfile: Dockerfile
    volumes:
      - ./front:/usr/src/app
    command: sh -c "cd rails_react_app && yarn start"
    ports:
    - "8000:3000"

```
