---
layout: entry
title: 개발 환경에서 유용한 Docker 명령어 소개
author: 강효준, 양천웅
author-email: yang@spoqa.com
description: 개발 환경에서 사용할 수 있는 Docker 명령어를 소개합니다.
publish: true
---

안녕하세요. 스포카 프로그래머 강효준, 양천웅입니다.

스포카 사내에서는 [서비스 지향 설계][SOA]를 적극적으로 적용하고 있습니다.
서비스 지향 설계에서는 제품을 개발하기 위해서 서비스를 기능 단위로 나누고 서비스끼리 통신하도록 구현합니다.
서비스가 많아지게 되자 배포 단위를 쉽게 나누면서 서비스의 수평적 확장도 쉽게 하기 위해 [Docker][]를 사용하고 있습니다.

실행하는 서비스가 많아졌기 때문에 개발 환경도 이전과는 많이 달라졌습니다.
개발 환경에서 실행하는 서비스가 다른 서비스의 데이터를 갱신시키지 않는 경우에는 실제 운영 중인 서비스를 대상으로 통신을 하더라도 큰 문제가 없습니다.
하지만 실제 운영 중인 다른 서비스의 데이터를 삽입/갱신시키는 경우에는 실제 서비스의 데이터를 훼손시켜 서비스 운영에 문제를 일으킬 수도 있습니다.
따라서 운영 중인 서비스에 직접 통신하는 대신 개발 환경에서 테스트용 서비스를 별도로 실행해야 합니다.

개발 환경에서도 여러 서비스를 배포 환경에 맞춰 실행하려 하니 자연스럽게 Docker를 사용하여 Docker 컨테이너(이하 컨테이너)로 서비스를 실행하게 되었습니다.
개발 환경에서 컨테이너를 실행하면서 저희가 마주친 문제들과 해결 방법을 공유하려 합니다.


## 1. Docker 이미지, 컨테이너에서 환경변수 설정

Docker화된 서비스의 실행 시에 환경변수가 있어야 하는 경우가 존재합니다.
이럴 때는 컨테이너 실행 시 `-e` 옵션을 통해 환경변수를 인자로 주는 게 가능합니다.

```bash
$ docker run -e HELLO=WORLD --rm image:tag bash -c 'echo $HELLO'
WORLD
```

Docker 이미지 생성 시 환경변수가 필요하다면 `--build-arg` 옵션을 통해서
인자를 주는 게 가능합니다. 더 자세한 정보는 [Docker 공식 문서][docker-arg]를
참고해주세요.

```bash
$ cat Dockerfile
ARG FLASK
ENV FLASK ${FLASK:Flask==0.11}

RUN pip install $FLASK
$ docker build --build-arg FLASK="Flask==0.12" . # built with flask 0.12
$ docker build . # built with flask 0.11
```


## 2. 컨테이너간의 통신 방법

데이터베이스가 필요한 서비스를 컨테이너로 실행하려면 컨테이너 내부에서
접근 가능한 데이터베이스 서버가 필요합니다. 일반적으로
개발 환경에서는 아래 2가지 방법을 사용하여 데이터베이스에 연결합니다.

1. 원격지 서버에 있는 데이터베이스에 연결
2. 개발 환경 내부에 있는 데이터베이스에 연결

원격지 서버에 있는 데이터베이스의 경우 원격지에 서버를 유지하는
비용이 발생하므로 후자를 선택합니다.
이런 상황에서 [Docker Hub][docker-hub]에서 제공하는 데이터베이스
서버 이미지를 사용한다면, 쉽게 데이터베이스 서버를 구축할 수 있습니다.

스포카에서는 주로 [PostgreSQL][]을 사용하기 때문에
PostgreSQL 서버를 컨테이너로 실행하여 다른 서비스와 연결하는 것을 가정합니다.
PostgreSQL을 컨테이너로 실행시키는 방법은
[Docker Hub PostgreSQL 저장소](https://hub.docker.com/_/postgres/)를
참고해주세요.[^1]

PostgreSQL을 컨테이너로 실행하고 있더라도, PostgreSQL 컨테이너가 다른
컨테이너와 연결되어 있지 않기 때문에 데이터베이스에 접속할 수 없습니다.
[docker network][] 명령어를 사용하여, 컨테이너끼리 연결되도록 설정해야합니다.

```bash
$ docker network create spoqa-service
```

컨테이너 실행 시 `--network` 옵션을 통해 컨테이너간의 통신에 해당 네트워크를 사용할 수 있도록 만듭니다.

```bash
$ docker run --network spoqa-service image-name:tag
```

또는 이미 실행 중인 컨테이너를 생성한 네트워크에 연결하기 위해서는 [docker network connect][] 명령어를 사용하면 됩니다.

```bash
$ docker network connect spoqa-service running-service-name
```

Docker 네트워크에 연결된 호스트 주소는 컨테이너를 실행할 때 설정했던 컨테이너의 이름과 같습니다.

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                     NAMES
f49f0020ab38        postgres:9.5        "docker-entrypoint..."   6 days ago          Up 5 days           5432/tcp                  pg
```

컨테이너 실행 시 지정했던 이름은 pg이므로 spoqa-service 네트워크 내부에서
컨테이너의 주소도 컨테이너의 이름과 똑같이 지정됩니다.
그래서 컨테이너가 spoqa-service 네트워크에 연결 되어있다면,
데이터베이스에 접속할때, `postgres://username:password@pg:5432/dbname`로
연결할 수 있습니다. 아래는 Docker PostgreSQL 이미지에 포함되어있는
명령 줄 인터페이스를 사용하여 Docker 컨테이너로 실행되고 있는
PostgreSQL 서버에 접속하는 예제입니다.

```bash
$ docker run --network spoqa-service --rm -it postgres:9.5 psql "postgres://username:password@pg:5432/dbname"
postgres> # it worked !
```


## 3. Docker화하지 못한 서비스와 통신하기

하지만 아직 스포카에선 Docker화 하지 못한 서비스들도 있습니다. 컨테이너 내부에서 Docker를 실행하고 있는 호스트 네트워크와 통신을 하기 위해서는 별도의 설정이 필요했습니다. macOS에서는 [Docker 네트워크 가이드](https://docs.docker.com/docker-for-mac/networking/#use-cases-and-workarounds)에 소개된 것처럼 사용하지 않는 IP를 lo0 인터페이스에 붙여서 통신합니다. 다른 OS의 경우 [Docker 공식 문서](https://docs.docker.com/manuals/)를 참고해주세요.

```bash
$ sudo ifconfig lo0 alias 10.200.10.1
```

[buildpack-deps](https://hub.docker.com/_/buildpack-deps/)를 사용하면 IP 대응이
제대로 되었는지 별도의 설정 없이 확인이 가능합니다.

```bash
# 5000번 포트에 서비스가 실행되고 있을 때를 가정합니다.
$ docker run --rm -it buildpack-deps:curl curl http://10.200.10.1:5000
```

[OAuth][] 컨슈머(consumer)를 생성할때는, 프로바이더(provider)가 인증 후
컨슈머 서비스에 어느 곳으로 이동할 지 URL을 적어줘야 합니다.
이 경우에 호스트에 별칭을 지어 주는 것이 유용할 때가 많은데, 컨테이너 실행 시
`--add-host` 옵션을 주면 `/etc/hosts` 파일에 별칭이 추가됩니다.

```bash
$ docker run --rm --add-host local.spoqa.com:10.200.10.1 buildpack-deps:curl curl http://local.spoqa.com:5000
$ docker run --rm --add-host local.spoqa.com:10.200.10.1 buildpack-deps:curl cat /etc/hosts
  127.0.0.1	localhost
  ::1	localhost ip6-localhost ip6-loopback
  fe00::0	ip6-localnet
  ff00::0	ip6-mcastprefix
  ff02::1	ip6-allnodes
  ff02::2	ip6-allrouters
  10.200.10.1	local.spoqa.com
```


## 4. 컨테이너 실행 시 호스트의 디렉터리를 참조

코드 수정 없이 Docker 이미지만 받아서 서비스를 실행하는 경우, 이미지에 포함된 설정 파일이 개발 환경과 맞지 않을 수 있으므로 개발 환경에 맞는 설정 파일을 컨테이너에서 사용하도록 설정해줘야 합니다. `-v` 옵션을 주면 호스트 내부에 있는 디렉터리를 컨테이너에서 마운트할 수 있습니다.

```bash
$ docker run --rm -v ~/myprojects:/example-service image-name:tag ls -al /example-service
  -rw-r--r--   1 root root    5302 Apr 25  2017 config.toml

```

개발 환경에서도 Docker를 적극적으로 사용하면 여러 서비스를 실행해야 하는 개발 환경도 쉽게 구축할 수 있습니다.
이 글이 Docker를 사용 시 도움이 됐으면 합니다.

[docker-hub]: https://hub.docker.com
[SOA]: https://ko.wikipedia.org/wiki/%EC%84%9C%EB%B9%84%EC%8A%A4_%EC%A7%80%ED%96%A5_%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98
[Docker]: https://www.docker.com/
[PostgreSQL]: https://www.postgresql.org/
[macOS]: https://ko.wikipedia.org/wiki/MacOS
[docker network]: https://docs.docker.com/engine/reference/commandline/network/
[docker network connect]: https://docs.docker.com/engine/reference/commandline/network_connect/
[docker-arg]: https://docs.docker.com/engine/reference/builder/#arg
[OAuth]: https://ko.wikipedia.org/wiki/OAuth

[^1]: Docker Hub에서는 PostgreSQL뿐만 아니라 [MySQL](https://hub.docker.com/_/mysql/), [MariaDB](https://hub.docker.com/_/mariadb/), [RethinkDB](https://hub.docker.com/_/rethinkdb/) 같은 여러 데이터베이스 서버의 이미지를 제공하고 있습니다.
