# Apache Zeppelin

**Documentation:** [User Guide](https://zeppelin.apache.org/docs/latest/index.html)

**Mailing Lists:** [User and Dev mailing list](https://zeppelin.apache.org/community.html)

**Continuous Integration:** [![Build Status](https://travis-ci.org/apache/zeppelin.svg?branch=master)](https://travis-ci.org/apache/zeppelin)

**Contributing:** [Contribution Guide](https://zeppelin.apache.org/contribution/contributions.html)

**Issue Tracker:** [Jira](https://issues.apache.org/jira/browse/ZEPPELIN)

**License:** [Apache 2.0](https://github.com/apache/zeppelin/blob/master/LICENSE)

**Zeppelin**, a web-based notebook that enables interactive data analytics. You can make beautiful data-driven, interactive and collaborative documents with SQL, Scala and more.

Core feature:
  
* Web based notebook style editor.
* Built-in Apache Spark support

To know more about Zeppelin, visit our web site [https://zeppelin.apache.org](https://zeppelin.apache.org)

## Getting Started

### Docker setup

Docker image is built against Zeppelin 0.8.2 and it supports Apache Spark 2.4.

```bash
docker pull maziyar/zeppelin:0.8.2
```

```bash
docker run -it --rm -p 8080:8080 -p 8081:8081 maziyar/zeppelin
```

### Install binary package

Please go to [install](https://zeppelin.apache.org/docs/latest/quickstart/install.html) to install Apache Zeppelin from binary package.

### Build from source

Please check [Build from source](https://zeppelin.apache.org/docs/latest/setup/basics/how_to_build.html) to build Zeppelin from source.
