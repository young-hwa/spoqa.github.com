---
layout: entry
title: Python 기반의 웹서비스 개발 환경 구축 방법
author: 박종규, 정성재, 고아라
description: Windows, Mac OS, Linux 운영체제에서  Python, PostgreSQL을 이용한 웹서비스 개발 환경을 구축하는 과정을 알아보겠습니다.
---

안녕하세요. 스포카 크리에이터팀의 프로그래밍 인턴을 맡고 있는 __박종규, 정성재, 고아라__입니다. 저희 세 명은 각각 다른 OS 환경에서 웹서비스를 개발하였는데 이번 포스팅에서는 OS별로 개발 환경을 구축하는 과정을 설명하겠습니다.

## Python
[Python](http://www.python.org/)(파이썬)은 비영리의 Python 소프트웨어 재단이 관리하는 개방형, 공동체 기반 개발 모델을 가지고 있습니다. Python은 C파이썬 구현이 사실상의 표준이며 동적 타이핑 범용 프로그래밍 언어로, 펄 및 루비와 자주 비교됩니다. Python은 순수한 프로그래밍 언어의 기능 외에도 다른 언어로 쓰인 모듈들을 연결하는 Glue language로써 자주 이용됩니다. 실제 Python은 많은 상용 응용 프로그램에서 스크립트 언어로 채용되고 있습니다. 또한, 유니코드 문자열을 지원하여 다양한 언어의 문자 처리에도 능합니다. 현대의 Python은 여전히 인터프리터 언어처럼 동작하나 사용자가 모르는 사이에 스스로 Python 소스 코드를 컴파일하여 바이트 코드를 만들어 냄으로써 다음에 수행할 때에는 빠른 속도를 보여줍니다.

### Windows에서 Python 2.x 설치 방법
Linux와 Mac OS에서 Python은 기본적으로 설치되어 있기 때문에 터미널 창에서 Python 명령만으로 쉽게 실행할 수 있지만 Windows에서는 Python을 따로 설치해주어야 합니다. 

[Python 공식 사이트](http://www.python.org)
    
 해당 사이트에 들어가서 Quick Links (2.7.3) – Windows Installer 선택하여 python-2.7.3.msi 다운로드 후 실행하여 설치합니다. 특별히 원하는 버전이 있을 때에는 DOWNLOAD – Releases에서 버전별로 설치파일을 다운로드 할 수 있습니다. Python의 기본 설치 경로는 C:\Python27 이며 설치 완료 후, 환경변수를 등록해야 합니다. 환경변수를 등록하는 방법은 다음과 같습니다.
 
* 내컴퓨터(마우스 오른쪽 버튼 클릭) – 속성(시스템 등록 정보) – 고급 – 환경 변수 클릭
* 시스템 변수 – Path 선택 후 편집 클릭
* 변수 값에 맨 뒤에 C:\Python27;C:\Python27\Scripts; 입력 후, 확인 버튼을 눌러 시스템에 적용
* 변수 값은 각각 ; (세미콜론) 으로 구분

### Python의 패키지 설치 방법
시작 메뉴 – 실행 – CMD 로 커맨드 창을 실행 시킨 후에 Python이 설치된 디렉터리로 이동합니다.

```
cd C:\Python27\Scripts
```

그 다음 easy_install pip 명령으로 [pip](http://en.wikipedia.org/wiki/Pip_(Python\))를 설치해줍니다.
pip는 PyPI(Python Package Index)에 등록된 패키지들을 설치하고 관리할 수 있는 패키지 관리 시스템입니다.

```
$ easy_install pip
```

다음은 pip 명령의 사용법입니다.

 * pip install packageName 명령 : 최신버전으로 설치
 * pip install packageName==0.x.x 명령 : 0.x.x버전으로 설치
 * 패키지 설치 경로 : C:\Python27\Lib\site-packages
 * pip uninstall packageName 명령 : package 제거
 * pip freeze 명령 : 현재 환경에 설치된 package 이름과 버전 목록
<br>
  
## PostgreSQL

![PostgreSQL](/images/2013-02-20/postgresql.png)

 [PostgreSQL](http://www.postgresql.org/)는 California 대학 Berkeley computer science 학부에서 개발한 POSTGRES, Version 4.2 를 기반으로 한 오브젝트 RDB 관리 시스템(ORDBMS)입니다. 또한, PostgreSQL은 BSD 허가권으로 배포되며 오픈소스 개발자 및 관련 회사들이 개발에 참여하고 있습니다. 따라서 누구라도 사용, 수정, 배포할 수 있으며 목적과 관계없이 무료로 이용할 수 있습니다.

### 각 운영체제 별 PostgreSQL 설치 방법

#### Windows

Windows에서 PostgreSQL을 설치하기 위해 해당 사이트로 접속합니다.

[PostgreSQL 공식 사이트](http://www.postgresql.org/)

해당 사이트의 Download탭을 선택하여 Downloads 페이지로 이동합니다. 그 다음 Binary packages 에서 Windows를 선택하여 Windows installers 페이지로 이동합니다. One click installer 에서 Download 선택 후 [이 페이지](http://www.enterprisedb.com/products-services-training/pgdownload#windows) 로 이동하여 해당하는 OS 버전으로 선택하여 다운로드 후 설치합니다.

#### Linux (ubuntu 12.04 LTS)

Linux(리눅스)에서 PostgreSQL은 여러 가지 방법으로 설치 할 수 있습니다. 패키지로 설치하는 방법은 터미널 창에서 아래와 같은 명령어를 입력하시면 됩니다.

```
$ sudo apt-get install postgresql-X.X(버전명)
```

다른방법으로 설치하는 방법은 아래 주소로 들어가시면 자세히 나와 있습니다.

[PostgreSQL 공식 사이트](http://www.postgresql.org/download/linux/ubuntu/)

추가로 PostgreSQL을 편하게 이용하고 싶은 사용자는 pgadmin3이라는 PostgreSQL의 GUI 프로그램을 설치하시면 됩니다. 설치 방법은 터미널 창에서 아래와 같은 명령어를 입력하시면 됩니다.

```
$ sudo apt-get install pgadmin3
```

#### Max OS ( MAC OS X Mountain Lion 10.8.2)
Mac OS에서 PostgreSQL은 [Homebrew](http://mxcl.github.com/homebrew/)를 이용하여 설치하도록 하겠습니다. Homebrew는 Mac OS의 패키지 관리자 프로그램입니다. PostgreSQL은 Homebrew 이외에도 [PostgreSQL 다운로드 사이트](http://www.postgresql.org/download/macosx/), Homebrew와 비슷한 기능을 하는 MacPorts 등을 이용해서도 다운받을 수 있습니다. 하지만 PostgreSQL 이외의 다른 프로그램을 설치하기에도 패키지 관리자가 유용하기 때문에 저는 Homebrew를 이용하도록 하겠습니다. 일단, Homebrew 패키지를 컴파일 하기 위해서 xCode가 설치되어 있어야 합니다. 앱스토어에서 xCode를 검색하여 받도록 합니다.

![xcode](/images/2013-02-20/xcode.png)

xCode 설치를 완료했으면 메뉴에서 
__xCode탭 - Preferences - Downloads - Command Line Tools__를 다운받습니다. 그럼 이제 Homebrew 패키지를 컴파일할 수 있게 되었습니다.

![command](/images/2013-02-20/commandLineTools.png)

이제 터미널을 실행시키고 다음 명령을 입력하면 Homebrew가 설치됩니다.

```
$ ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
```

Homebrew가 이미 설치되어있다면 업데이트할 사항이 없는지 확인해보고 업데이트를 시켜주세요.

__$ brew update__

이제 Homebrew 설치를 완료했으니 간단하게 PostgreSQL을 설치할 수 있습니다.

```
$ brew install postgresql
```

설치된 버전을 __$ psql --ver__ 명령으로 확인해 보니 PostgreSQL 9.1.4 버전이 설치되어 있었습니다. 

### psycopg2
[psycopg2](http://initd.org/psycopg/)는 Python library의 한 종류로써 하는 역할은 Python에서 PostgreSQL를 활용하게 해주는 library입니다. 설치 방법은 터미널 창에서 아래와 같은 명령어를 입력하시면 됩니다.

```
$ pip install psycopg2
```

__* 참고__  ubuntu/debian 사용하시는 분 중에서 설치가 안 되시는 분들은 psycopg2를 설치하시기전에 python-dev라는 패키지 파일을 설치하시면 psycopg2를 설치 하실 수 있습니다. 설치 방법은 터미널 창에서 아래와 같은 명령어를 입력하시면 됩니다.

```
$ sudo apt-get install python-dev
```

## Flask

[Flask](http://flask.pocoo.org/)는 Python용 Micro Framework이며, Jinja2 template engine과 Werkzerg WSGI toolkit에 의존합니다. Flask에는 기본적으로 많은 환경설정 값들이 존재합니다. 규칙에 따라 템플릿 파일과 CSS, JavaScript, Images 등의 파일들은 templates과 static 이라는 하위 디렉터리에 각각 보관해야 합니다. 기본적으로 Flask는 다른 라이브러리에는 존재하는 Database abstraction layer, Form validation 등의 기능을 포함하지 않지만, 기능을 추가할 수 있는 확장성을 제공합니다. 이미 수많은 라이브러리들이 Database integration, Form validation, Upload handling, Various open authentication technologies등을 제공합니다. SQLAlchemy나 다른 DB Tool을 이용하여 고급 패턴을 구현할 수 있으며, Flask를 이용해보면 다양한 기능을 확장할 수 있다는 것을 알 수 있을 것입니다.

## Flask 설치 방법
 Flask를 설치하려면 터미널 창에서 다음 명령어를 입력하면 됩니다. (windows의 경우 cmd창)
 
```
 $ sudo pip install flask 
```

# SQLAlchemy

[SQLAlchemy](http://www.sqlalchemy.org/)는 Oracle, DB2, MySQL, PostgreSQL, SQLite와 같은 관계형 데이터베이스에 강력하고 유연한 인터페이스를 제공하는 Python SQL Toolkit이자 Object Relation Mapper(ORM)입니다. 여기서 ORM은 객체를 관계형 DB 테이블에 매핑해주는 역할을 하는데 SQLAlchemy는 객체를 매핑하기 위해 특정 클래스를 상속받지 않아도 되기 때문에 높은 수준의 라이브러리라고 할 수 있습니다. 

앞선 단계까지의 설치가 완료되었다면 SQLAlchemy의 설치법 역시 [pip](http://en.wikipedia.org/wiki/Pip_(Python\)) 명령을 쓰면 되므로 간단합니다. 윈도우는 커맨드창을 실행시키고, 리눅스와 MAC OS의 경우 터미널을 실행시켜 다음 명령을 입력합니다. 저는 SQLAlchemy 0.7.2 버전을 설치했습니다.

__$ pip install SQLAlcheymy==0.7.2__

Permission denied라는 문구가 뜨면 권한이 없는 것이므로 관리자 계정으로 설치를 해주어야 합니다. 관리자 계정은 $ sudo su로 로그인하거나 명령 앞에 sudo를 붙이면 됩니다.

```
$ sudo pip install SQLAlchemy==0.7.2
```

여기에서 ==0.7.2는 설치할 SQLAlchemy의 버전을 뜻하며 버전을 명시하지 않으면 최신 버전으로 깔립니다.
### Flask-SQLAlchemy
[Flask-SQLAlchemy](http://pythonhosted.org/Flask-SQLAlchemy/)는 SQLAlchemy를 더욱 뒷받침할 수 있는 Flask의 확장으로 SQLAlchemy 0.6 이상의 버전을 필요로합니다.
Flask-SQLAlchemy 역시 pip 명령으로 설치할 수 있으며 저는 Flask-SQLAlchemy 0.15 버전을 설치했습니다.

```
$ sudo pip install Flask-SQLAlchemy==0.15
```

## 마치며

지금까지 Windows, Linux, Mac OS에서 Python, PostgreSQL을 이용한 웹서비스 개발 환경 구축 방법에 대해 알아보았습니다. 이 글을 통해서 처음 접한 사람들도 특정 OS에 구애받지 않고 쉽게 웹서비스 개발 환경을 구축하는 데에 도움이 되었으면 좋겠습니다.

## 출처

[Python 위키백과](http://ko.wikipedia.org/wiki/%ED%8C%8C%EC%9D%B4%EC%8D%AC)<br>
[pip 위키백과](http://en.wikipedia.org/wiki/Pip_(Python\)) <br>
[Flask 홈페이지](http://flask.pocoo.org/)<br>
[PostgreSQL plus](http://www.postgresplus.co.kr/man/intro-whatis.html)<br>
[PostgreSQL 위키백과](http://ko.wikipedia.org/wiki/PostgreSQL) <br>
Essential SQLAlchemy, O REILLY, 2008 <br>
[Flask-SQLAlchemy 홈페이지](http://pythonhosted.org/Flask-SQLAlchemy/)
