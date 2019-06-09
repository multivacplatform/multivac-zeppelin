# multivac-zeppelin [![GitHub license](https://img.shields.io/badge/license-apache2.0-blue.svg)](https://github.com/multivacplatform/multivac-ansible/blob/master/LICENSE) [![Multivac Discuss](https://img.shields.io/badge/multivac-discuss-ff69b4.svg)](https://discourse.iscpif.fr/c/multivac) [![Multivac Channel](https://img.shields.io/badge/multivac-chat-ff69b4.svg)](https://chat.iscpif.fr/channel/multivac)

**Zeppelin**, a web-based notebook that enables interactive data analytics. You can make beautiful data-driven, interactive and collaborative documents with SQL, Scala and more.

Core feature:
  
* Web based notebook style editor.
* Built-in Apache Spark support

To know more about Zeppelin, visit our web site [https://zeppelin.apache.org](https://zeppelin.apache.org)

## Getting Started

### Docker setup

Docker image is built against Zeppelin 0.8.2 and it supports Apache Spark 2.4.

```bash
docker pull multivacplatform/multivac-zeppelin
```

```bash
docker run -it --rm -p 8080:8080 -p 8081:8081 maziyar/zeppelin
```

Just head to your browser and you're good to go!

http://localhost:8080

### Install binary package

Please go to [install](https://zeppelin.apache.org/docs/latest/quickstart/install.html) to install Apache Zeppelin from binary package.

### Build from source

Please check [Build from source](https://zeppelin.apache.org/docs/latest/setup/basics/how_to_build.html) to build Zeppelin from source.

## Code of Conduct

This, and all github.com/multivacplatform projects, are under the [Multivac Platform Open Source Code of Conduct](https://github.com/multivacplatform/code-of-conduct/blob/master/code-of-conduct.md). Additionally, see the [Typelevel Code of Conduct](http://typelevel.org/conduct) for specific examples of harassing behavior that are not tolerated.

## Copyright and License

Code and documentation copyright (c) 2019 [ISCPIF - CNRS](http://iscpif.fr). Code released under the [Apache 2.0 license](https://github.com/multivacplatform/multivac-zeppelin/blob/master/LICENSE).
