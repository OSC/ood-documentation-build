# Docker Sphinx

Docker image for [Sphinx](http://www.sphinx-doc.org/en/stable/).

This image contains:

- [Sphinx](http://www.sphinx-doc.org/en/stable/)
- A theme:
  - [sphinx_rtd_theme](https://github.com/rtfd/sphinx_rtd_theme)
- A variety of plugins:
  - [sphinxcontrib-plantuml](https://pypi.python.org/pypi/sphinxcontrib-plantuml)
  - [sphinxcontrib-httpdomain](https://pypi.python.org/pypi/sphinxcontrib-httpdomain)
  - [sphinxcontrib-github_ribbon](https://pypi.python.org/pypi/sphinxcontrib-github_ribbon)

## Build

```sh
git clone https://github.com/OSC/docker-sphinx.git
cd docker-sphinx
docker build --force-rm -t ohiosupercomputer/docker-sphinx .
```

## Install

```sh
docker pull ohiosupercomputer/docker-sphinx
```

## Usage

```sh
docker run --rm -i -t -v "${PWD}:/doc" -u "$(id -u):$(id -g)" ohiosupercomputer/docker-sphinx <cmd>
```

### Docker Compose

It is recommended to use [Docker Compose](https://docs.docker.com/compose/). An
example `docker-compose.yml` is seen as:

```yaml
version: "2"
services:
  sphinx:
    image: "ohiosupercomputer/docker-sphinx"
    volumes:
      - "${PWD}:/doc"
    user: "1000:1000"
```

Then run:

```sh
docker-compose run --rm sphinx <cmd>
```

Examples:

```sh
docker-compose run --rm sphinx sphinx-quickstart
docker-compose run --rm sphinx make html
```
