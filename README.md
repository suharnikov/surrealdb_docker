> The current state of Surrealdb is dismal. Too many issues with simple queries and memory leaks. I don't think I want to use it in the near future.

# SurrealDB Docker Images

This repository contains a solution for running [SurrealDB], a fast and scalable database system, in Docker with connected volume. It is based on the official images from [SurrealDB].

## Features

- Have no an issue with volume permissions.
- Can be attached using bash for interactive commands.
- Debian version contains all necessary linux utils to work with any docker utils (like docker extension for vscode).

## Usage

To use this solution, you need to have [Docker] and [Docker Compose] installed on your machine. Then, follow these methods:

- Run `docker run --rm --pull always -p 8000:8000 kostomeister/surrealdb:latest`
- Or run `docker run --rm --pull always -p 8000:8000 -v surreal-data:/var/surreal_data/ kostomeister/surrealdb:latest`
to attach a persistent volume.

Alos available `debian-latest` version based on latest debian image and latest surrealdb version.

## Example

Here is an example of a `docker-compose.yml` file that uses this solution:

```yaml
version: '3.8'

services:
  app:
    build:
      context: ..
      dockerfile: .devcontainer/Dockerfile
    volumes:
      - ../..:/workspaces:cached
    command: sleep infinity
    network_mode: service:database

  database:
    image: kostomeister/surrealdb:debian-latest
    restart: unless-stopped
    environment:
      SURREAL_USER: test_user
      SURREAL_PASS: test_password
      SURREAL_STRICT: true
      SURREAL_AUTH: true
    volumes:
      - surreal-data:/var/surreal_data/

volumes:
  surreal-data:
```

## License

This project is licensed under the MIT License. See the [LICENSE] file for details.

## Acknowledgements

- Thanks to [SurrealDB] for creating a fast and scalable database system.

[SurrealDB]: https://surrealdb.com/
[Docker]: https://www.docker.com/
[Docker Compose]: https://docs.docker.com/compose/
[LICENSE]: ../blob/master/LICENSE
