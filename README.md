# URLess - Url Shortener

Make it shorter.

## Usage

The intended way to interact with this application is via docker.

Begin by installing and running [Docker Desktop](https://www.docker.com/products/docker-desktop/) on your machine if not already installed and running.

### Setup
First `cd` into the root URLess directory

```shell
$ cd /urless
```

#### Backend
Running the following command in the root directory will:

* create DB
* migrate schema
* seed database
* prepare tests
* turn on development caching
```shell
$ docker-compose run backend bin/rails db:create db:migrate db:seed db:test:prepare dev:cache
```

#### Setup Frontend
Running the following command in the root directory will install frontend dependencies.

```shell
$ docker-compose run frontend yarn install
```

### Run The Application
Using docker compose bring up the whole application

```shell
$ docker-compose up
```
In addition to the backend and frontend log output, the terminal should show running instances of Postgres and Redis.

Once all containers are up and running you can navigate to the  [frontend application](http://localhost:8080).

The standard rails greeting endpoint was intentionally left up to easily validate that the backend is running. You can confirm that [here](http://localhost:3000).

## Specs

### Backend
```shell
docker-compose run backend rake test
```

### Frontend
```shell
docker-compose run frontend yarn test
```

### Performance
To run performance specs ensure the backend application is running locally. In a separate terminal window run the following exec commands in the backend container to benchmark the server.

**Note:** that these benchmarks are set to run in rehearsal mode to avoid cold start issues. It will run whatever request setup you ask for twice in a row.

#### GET redirect
This will pluck the number of short ids out of the db and benchmark subsequent requests to the redirect endpoint. Database should be seeded for this to be optimal.
```shell
$ docker exec -it -e REQUESTS=10 backend bin/rails performance:redirect
```
#### POST create
This will create sequential example urls via the create endpoint
```shell
$ docker exec -it -e REQUESTS=10 backend bin/rails performance:create
```

## Further Details

