---
layout: entry
title: macOS 개발 환경에서 유용한 Docker 명령어 소개
author: 강효준, 양천웅
author-email: yang@spoqa.com
description: macOS 개발 환경에서 사용할 수 있는 Docker 명령어를 소개합니다.
publish: true
---

안녕하세요. 스포카 프로그래머 강효준, 양천웅입니다.

스포카 사내에서는 [SOA][]를 적극적으로 활용하게 되면서 [Docker][]의 사용 도가 높아졌습니다.
`SOA`에서는 제품 1개를 개발하기 위해서 여러 서비스 간의 통신이 불가피한데, 이는 개발 환경에서도 마찬가지입니다.
서비스에서 다른 서비스로 데이터를 갱신시키지 않는 경우에는 실제 서비스를 대상으로 하여 개발 환경에서도 통신할 수 있지만, 다른 서비스의 데이터를 갱신시키는 경우에는 이 방법이 유효하지 않았습니다.
개발 환경에서 `Docker` 컨테이너(이하 컨테이너) 를 이용해 서비스를 실행하면서 마주친 문제들을 공유하려 합니다.
스포카 내부에서는 개발 환경을 [macOS][]를 기반으로 하고 있으므로 다른 개발 환경에서는 작동하지 않을 수도 있습니다. 

## 컨테이너 실행시 환경변수 설정
Docker화된 서비스의 실행 시에 환경변수가 있어야 하는 경우가 존재합니다.
이럴 때는 컨테이너 실행 시 `-e` 옵션을 통해 환경변수를 인자로 주는 게 가능합니다.

```
$ docker run -e HELLO=WORLD --rm image:tag bash -c 'echo $HELLO'
WORLD
```

## 컨테이너와 호스트간의 통신 방법
Docker 이미지 생성 시 환경변수가 필요하다면 `--build-arg` 옵션을 통해서 인자를 주는 게 가능합니다. 더 자세한 정보는 [Docker 공식 문서][docker-arg] 를 참고해주세요.

데이터를 갱신시킬 서비스를 실행시키고 서비스가 잘 실행되었는지 확인하기 위해서 개발 환경에서 사용하는 데이터베이스를 확인했는데, 데이터베이스에는 갱신된 데이터가 없었습니다.

```
$ docker logs running-service
```

명령어를 통해 로그를 확인해보니 컨테이너 실행이 제대로 안 되고 있었고, 컨테이너 실행 시 `-d` 옵션을 줬기 때문에 서비스가 실행되지 않은 것을 바로 확인하지 못했습니다. 그래서 `-d` 옵션을 주지 않고 실행하니 데이터베이스를 찾지 못하는 문제가 있었습니다.
해당 서비스는 [PostgreSQL][]을 사용하기때문에 PostgreSQL을 Docker로 실행시켜서 연결하려고 했습니다.
PostgreSQL을 컨테이너로 실행시키는 방법은 [Docker Hub PostgreSQL 저장소](https://hub.docker.com/_/postgres/) 를 참고해주세요.

컨테이너 내부에서는 호스트가 실행한 개발용 데이터베이스를 인식하지 못하는 것이 원인이었습니다. 그래서 컨테이너 내부에서 데이터베이스 컨테이너를 인식시키기 위해 [network][]명령어를 사용했습니다.
먼저, 컨테이너끼리 연결할 네트워크를 생성합니다.

```
$ docker network create spoqa-service 
```

컨테이너 실행 시 `--network` 옵션을 통해 컨테이너끼리 통신에 해당 네트워크를 사용할 수 있도록 만듭니다.

```
$ docker run --network spoqa-service image-name:tag
```

또는 이미 실행 중인 컨테이너를 생성한 네트워크에 연결하기 위해서는 `docker network connect` 명령어를 사용하면 됩니다.

```
$ docker network connect spoqa-service running-service-name
```

Docker 네트워크에 연결된 호스트 주소는 컨테이너를 실행할 때 설정했던 이미지의 이름과 같습니다.


```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                     NAMES
f49f0020ab38        postgres:9.5        "docker-entrypoint..."   6 days ago          Up 5 days           5432/tcp                  pg
```

제가 설정했던 이미지 이름은 <strong>pg</strong>이므로 `postgres://username:password@pg:5432/dbname`으로 연결하면 됩니다. 하지만 아직 스포카에선 Docker화 하지 못한 서비스들도 있습니다. 컨테이너 내부에서 Docker를 실행하고 있는 호스트 네트워크와 통신을 하기 위해서는 별도의 설정이 필요했습니다.
[Docker 네트워크 가이드](https://docs.docker.com/docker-for-mac/networking/#use-cases-and-workarounds) 를 참고하여 사용하지 않는 IP를 lo0 인터페이스에 붙여서 통신합니다.

```
$ sudo ifconfig lo0 alias 10.200.10.1
```

IP 대응이 제대로 되었는지 확인하려면 [buildpack-deps](https://hub.docker.com/_/buildpack-deps/) 를 사용하면 별도의 설정없이 확인이 가능합니다.

```
$ # 5000번 포트에 서비스가 실행되고 있을 때를 가정합니다.
$ docker run --rm -it buildpack-deps:curl curl http://10.200.10.1:5000
```

[OAuth][]인증을 위해서 consumer key와 consumer secret을 발급할때 redirection URL을 적어줘야 합니다.
이 경우에 호스트에 별칭을 지어주는 것이 유용할 때가 많은데, 컨테이너 실행 시 `--add-host` 옵션을 주면 `/etc/hosts`에 별칭이 추가됩니다.

```
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

## 컨테이너 실행시 호스트의 디렉터리를 참조
코드수정 없이 Docker 이미지만 받아서 서비스를 실행하는 경우, 이미지에 포함된 설정 파일이 개발 환경과 맞지 않을 수 있으므로 개발 환경에 맞는 설정 파일을 컨테이너에서 사용하도록 설정해줘야합니다. `-v` 옵션을 주면 host 내부에 있는 디렉터리를 컨테이너에서 장착할 수 있습니다.

```
$ docker run --rm -v ~/myprojects:/example-service image-name:tag ls -al /example-service
  -rw-r--r--   1 root root    5302 Apr 25  2017 config.toml

```

개발 환경에서도 Docker를 적극적으로 사용하면 여러 서비스를 실행해야 하는 개발 환경도 쉽게 구축할 수 있습니다.
이 글이 Docker를 사용 시 도움이 됐으면 합니다.

[SOA]: https://ko.wikipedia.org/wiki/%EC%84%9C%EB%B9%84%EC%8A%A4_%EC%A7%80%ED%96%A5_%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98
[Docker]: https://www.docker.com/
[PostgreSQL]: https://www.postgresql.org/
[macOS]: https://ko.wikipedia.org/wiki/MacOS
[network]: https://docs.docker.com/engine/reference/commandline/network/
[docker-arg]: https://docs.docker.com/engine/reference/builder/#arg
[OAuth]: https://ko.wikipedia.org/wiki/OAuth
