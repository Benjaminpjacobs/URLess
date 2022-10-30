# URLess - Url Shortener

Make it shorter.

## Usage

The intended way to interact with this application is via docker.

Begin by installing and running [Docker Desktop](https://www.docker.com/products/docker-desktop/) on your machine if not already installed and running.

You will also need to have [docker-compose CLI](https://github.com/docker/compose-cli#getting-started) tools installed on your machine.

### Setup

Clone this repo to your local machin and `cd` into the urless root directory.

```shell
$ cd urless/
```

#### Backend
```shell
$ docker-compose run backend bin/rails db:create db:migrate db:seed db:test:prepare dev:cache
```
This command will build the backend container as well as create, migrate and seed the docker PG instance. Additionally it will setup a test database and enable rails caching.

#### Frontend
```shell
$ docker-compose run frontend yarn install
```
This command will install frontend dependencies in the frontend docker container.

### Run The Application
User docker compose bring all required containers/services.

```shell
$ docker-compose up
```

In addition to the backend and frontend log output, the terminal should show running instances of Postgres and Redis.

Once all containers are up and running you can navigate to the [frontend application](http://localhost:8080).

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
To run performance specs ensure the backend application container is running.

In a separate terminal window run the following exec commands in the backend container to benchmark the server.

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

## Considerations and Improvements

### Short Url Generation
This project uses a simple implementation of `SecureRandom.urlsafe_base64` to generate unique short ids for every incoming URL. With a base of 9 this implementation allows for more than 7e+19 unique identifiers. This gives a degree of confidence against collision with a URL count into the billions. The trade offs here are that

1) The resulting string is 9 characters long - which may not exactly be considered 'short'
2) The short ids are not in any way derived from the input URLs. Though this could be considered a security "win" it means that there is no way to rebuild the database from a partial failure.

Without any restraints in the area of character length the choice was made to bias toward simiplicity and avoiding id collisions. Even though the possibility of a collision is astronomically small, the eventuality is still handled in the id generation code.

An alternative option that was explored was using a hashing function(MD5) and truncating to a smaller character length. Collisions could be resolved by adding in characters until resolved. Ultimately, without a restriction on URL length this solution was unneccessarily complicated regarding collision resolution.

### Performance
A caching layer was added to the redirect logic to make subsequent reads more performant. Additionally the redirect logic uses a `301` statuts code to allow the browser to cache the redirect permanantly, avoiding future requests from the same browser. Some trade-offs that were considered here:

There is a cost to the cache write for unique redirects. Another option was to write through to the cache when the short urls were generated but the main concern was duplicating the database entirely for a series of cache entries that may never be read. As a beginning step the choice was made to cache on read - but this could be readdressed to improve performance if required.

Additionally, the choice to use `301`(Permanent Redirect) allows us to avoid duplicate requests through the redirctor from a single browser but does not allow us to collect accurate metrics on the usage of the service. If analytics on usage were vital we could switch to `307`(Temporary Redirect) so subsequent browser requests could still be measured.

### Frontend/UI

The currently implementation of the form is not exactly mobile first or a11y friendly. Ideally another pass could be taken to ensure better practices in these areas.
