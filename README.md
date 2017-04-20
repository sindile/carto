# carto

CARTO is an open platform for analyze located data. This projects is aims to 'dockerized' carto for development and testing.

The project was created for solves [this issue](https://github.com/CartoDB/cartodb/issues/11654) at the fork repository: <https://github.com/teanocrata/cartodb>. For this reason all images are builded from official cartodb repos except cartodb.

![](http://i.imgur.com/AKGN5LN.jpg)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

Clone the repository to create a local copy on your computer:

```
$ git clone https://github.com/teanocrata/carto.git
```

From the root of the repo, build docker images:

```
$ docker-compose build
```

Start containers

> Our goal is start all containers with the following sentence, but there are some issues blocking it
> ```
> $ docker-compose up -d
> ```

1.  First time you start cartodb-postgresql service container, it configures the database an runs install cheack > test. You can start only this service and wait until tests passing.
    ```$ docker-compose up -d cartodb-postgresql```
1.  Follow tail until test passing, you can exit tail with Ctrl+C
   `docker-compose logs -f --tail="all"`
1.  Start cartodb-redis
    ```$ docker-compose up -d cartodb-redis```
1.  Start cartodb-sql-api
    ```$ docker-compose up -d cartodb-sql-api```
1.  Start windshaft-cartodb
    ```$ docker-compose up -d windshaft-cartodb```
1.  Start cartodb
    ```$ docker-compose up -d cartodb```


Attach to cartodb container to setting up an user [CartoDB Platform Documentation: Running CartoDB](http://cartodb.readthedocs.io/en/latest/run.html)

```
$ docker exec -ti carto_cartodb_1 bash
```

Create a development user from carto_cartodb_1 container. Let’s suppose that we are going to create a development env and that our user/subdomain is going to be ‘development’.

```
# sh script/create_dev_user
# exit
```

With previous domain, add entries to /etc/host (In your local machine) needed in development

```
$ echo "127.0.0.1 development.localhost.lan" | sudo tee -a /etc/hosts
```

You should now be able to access `http://<mysubdomain>.localhost.lan:3000` in your browser and login with the password specified above.

### Prerequisites

What things you need to install the software and how to install them

[docker](https://docs.docker.com/)

[docker-compose](https://docs.docker.com/compose/)

## Development configuration

'docker-compose.development.yml' is a docker-compose file that creates a complete development environment for cartodb, it mounts a volume with the code and launch an atom editos with all configurations than you need. You have an step by step example [here](../master/docs/carto%20steps.md)

## Acknowledgments

*   Made following [CartoDB Platform Documentation](http://cartodb.readthedocs.io/en/latest/index.html)
*   Ussing CartoBD projects from [CARTO GitHub Repo](https://github.com/cartodb)
*   Consulted repositories:
    *   [sverhoeven/docker-cartodb](https://github.com/sverhoeven/docker-cartodb)
