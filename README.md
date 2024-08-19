# OOD Documentation build container

Docker image for [Sphinx](http://www.sphinx-doc.org/en/stable/).

This image contains:

- [Sphinx](http://www.sphinx-doc.org/en/stable/)
- A theme:
  - [sphinx_rtd_theme](https://github.com/rtfd/sphinx_rtd_theme)
- A variety of plugins:
  - [sphinxcontrib-plantuml](https://pypi.python.org/pypi/sphinxcontrib-plantuml)
  - [sphinxcontrib-httpdomain](https://pypi.python.org/pypi/sphinxcontrib-httpdomain)

## Build

```sh
git clone https://github.com/OSC/ood-documentation-build.git
cd ood-documentation-build
docker build --force-rm -t ohiosupercomputer/ood-doc-build .
```

## Install

```sh
docker pull ohiosupercomputer/ood-doc-build
```

## Usage

```sh
docker run --rm -i -t -v "${PWD}:/doc" -u "$(id -u):$(id -g)" ohiosupercomputer/ood-doc-build <cmd>
```
