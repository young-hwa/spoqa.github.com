---
layout: entry
title: 파이썬의 개발 “환경”(env) 도구들
author: 홍민희
author-email: hong@spoqa.com
description: 파이썬 개발에 쓰이는 “환경”(env) 도구들에 관한 간략한 역사와 개념을 정리하고 그 활용 지침을 제안합니다.
publish: true
---

안녕하세요. 스포카 프로그래머 홍민희입니다.

파이썬 패키징 생태계에서 개발 환경을 구성하기 위해 널리 쓰이는 virtualenv나 pyvenv, virtualenvwrapper 같은 각종 도구가 왜 필요한지 (또는 자신에게는 큰 도움이 안 되는지) 알려면 그 이전의 파이썬 라이브러리 배포 방식에 대한 이해가 많은 도움이 됩니다. 여기서는 필요한 몇 가지 역사적 사실과 파이썬 패키징 개념 중 현재의 생태계 이해에 필요한 것들을 위주로 정리하고, 최종적으로 각자의 필요에 따라 어떤 도구를 활용하면 될지 지침을 제안합니다.

## [`sys.path`][0]

패키징이고 뭐고 아무것도 없던 90년대 말에는 라이브러리 소스 코드 파일들을 타르볼(tarball)로 압축해서 배포했습니다. 쓰는 사람은 그걸 자신의 애플리케이션 소스 트리 안에 풀어서 사용했습니다.

파이썬에는 지금도 [`sys.path`][0]라는 인터프리터 전역적인 상태가 존재합니다. `PATH` 환경 변수가 실행 바이너리를 찾을 디렉터리 경로들의 목록인 것과 비슷하게, `sys.path`도 `import foo`를 하면 foo.py (또는 foo/\_\_init\_\_.py) 파일을 찾을 디렉터리 경로들의 목록을 담습니다. 그리고 기본 동작으로 그 목록의 맨 처음에는 현재 디렉터리(./)가 들어갑니다. 따라서 라이브러리 타르볼을 애플리케이션 소스 트리에 풀어두면 `import`해서 쓸 수 있습니다.

하지만 자신이 작성한 애플리케이션 코드와 남이 작성한 라이브러리 코드를 같은 소스 트리에서 관리하는 것은 여러모로 불편합니다. 따라서 라이브러리는 애플리케이션 소스 트리와는 별도의 디렉터리(예: ../libs/)에 풀어서 관리하고, 애플리케이션 소스 코드 맨 위에 아래와 같이 써두는 패턴이 많았습니다.

~~~~ python
import sys
sys.path.append('../libs')
~~~~

또는 `sys.path`를 소스 코드를 건드리지 않고 조작하기 위해 [`PYTHONPATH` 환경 변수][1]를 활용하는 경우가 많았습니다.

세기말, 파이썬 1.5를 쓰던 때의 이야기입니다.

[0]: https://docs.python.org/library/sys.html#sys.path
[1]: https://docs.python.org/using/cmdline.html#envvar-PYTHONPATH

## site-packages

새 천 년이 밝았고 파이썬 2.0이 나왔습니다. 표준적인 라이브러리 배포 방식 및 설치 방식이 제안되었고, 표준 라이브러리에 [`distutils`][2]도 들어왔습니다. (지금도 `setuptools`는 `distutils`에 의존하고, pip는 `setuptools`에 의존합니다.) 제안된 방식은 이랬습니다.

애플리케이션 코드가 아닌 라이브러리 소스 코드는 모두 /usr/local/lib/python*X.Y*/site-packages/ 디렉터리 안에 둡니다. *X.Y*는 파이썬 인터프리터 버전이고, 경로는 인터프리터를 빌드할 때 (`./configure`) 정합니다. 데비안 계열은 site-packages 대신 dist-packages라는 이름으로 바꿔서 빌드하는 등, 파이썬 인터프리터의 설치 방식에 따라 달라집니다. 어떻게 정하든 이를 site-packages 디렉터리라고 부릅니다. 파이썬 인터프리터를 빌드할 때 경로가 결정되므로, 파이썬 인터프리터 별로 각자의 site-packages 디렉터리를 갖게 됩니다. (한 시스템에서 여러 파이썬 버전을 설치했을 때 pip 역시 `pip2.7`, `pip3.6` 등과 같이 버전 별로 명령어가 생기는 것도 같은 이유입니다.)

기본적으로 `sys.path` 목록에는 맨 앞에 현재 위치(./), 뒤쪽에는 site-packages 경로가 들어있습니다. `import`를 하면 현재 위치에서 찾고, 없으면 site-packages를 찾아본다는 뜻입니다.

표준 라이브러리의 `distutils.core.setup()` 함수는 라이브러리 파일들을 시스템의 site-packages 디렉터리에 복사해주는 함수입니다. 라이브러리 타르볼 파일 맨 바깥에는 이 함수를 이용해 라이브러리를 시스템 site-packages에 설치해주는 스크립트를 setup.py라는 파일명으로 포함하는 관례가 있었습니다. `pip` 같은 게 없던 때에는 라이브러리 타르볼을 받아서 푼 다음 [`python setup.py install` 명령][3]을 실행하는 것이 일반적인 라이브러리 설치법이었습니다. 지금도 `pip`는 \*.whl 파일이 아닌 \*.tar.gz/\*.zip 파일인 패키지를 설치할 때 내부적으로 `python setup.py install` 스크립트를 실행합니다.

참고로 이때 정립된 파이썬 패키징 표준은 리눅스에서 쓰이는 [dpkg][]나 [RPM][] 같은 일반적인 패키징 방식을 의식하며 만들어졌습니다.[^1] 당시는 도커는 커녕 가상화 자체가 보편적이지 않던 때로, 한 시스템에 여러 애플리케이션을 함께 설치해서 쓰는 [멀티테넌시 환경][4]이 일반적이었기 때문입니다.

[^1]: 파이썬으로 만든 애플리케이션을 `distutils`를 통해 패키징한 뒤, RPM 기반의 리눅스 배포본 용으로 [`python setup.py bdist_rpm` 명령][5]을 통해 \*.rpm 파일을 제공하기도 했습니다. 이를 통해 애플리케이션을 설치할 경우, 각 파일들은 리눅스 [FHS][] 표준과 해당 시스템 설정에 따라 흩어지게 됩니다.

[2]: https://docs.python.org/release/2.0/dist/dist.html
[3]: https://docs.python.org/release/2.0/inst/new-standard.html
[4]: https://ko.wikipedia.org/wiki/%EB%A9%80%ED%8B%B0%ED%85%8C%EB%84%8C%EC%8B%9C
[5]: https://docs.python.org/release/2.0/dist/creating-rpms.html
[dpkg]: https://ko.wikipedia.org/wiki/Dpkg
[RPM]: http://rpm.org/
[FHS]: https://ko.wikipedia.org/wiki/%ED%8C%8C%EC%9D%BC%EC%8B%9C%EC%8A%A4%ED%85%9C_%EA%B3%84%EC%B8%B5%EA%B5%AC%EC%A1%B0_%ED%91%9C%EC%A4%80
*[RPM]: RPM Package Manager
*[FHS]: Filesystem Hierarchy Standard

## [workingenv][]

파이썬으로 작성한 애플리케이션 여럿이 한 시스템에 설치되면 공통으로 의존하는 라이브러리의 버전을 결정하는 게 문제가 됩니다. A 애플리케이션은 `foo >= 1.0.0, < 2.0.0`에 의존하고 B 애플리케이션은 `foo >= 1.5.0`에 의존하면 시스템에 설치할 수 있는 foo의 버전은 `>= 1.5.0, < 2.0.0`으로 한정됩니다. 만약 C 애플리케이션을 설치하려는데 `foo > 2.0.0`에 의존한다면, A나 C 중 하나는 포기해야 합니다.

시스템에 파이썬 애플리케이션을 단 하나만 설치한다 해도, 설치하는데 시스템 관리자 권한이 필요하다는 것도 문제였습니다. 일반적으로 site-packages 디렉터리는 시스템 관리자만 수정할 수 있고 나머지는 읽기만 가능한 /usr 아래 어딘가로 정해졌기 때문입니다. 이를 우회하려고 사용자가 시스템에 설치된 파이썬 인터프리터를 쓰지 않고 직접 파이썬 인터프리터를 빌드해서 사용하는 편법도 쓰였습니다.

이런 문제를 해결하기 위해, 애플리케이션·프로젝트마다 별도의 site-packages 디렉터리를 두는 방식이 제안됐습니다. 나중에 virtualenv을 만들게 되는 [이안 비킹][6]이 그 전신인 [workingenv][]를 만들어 이 아이디어를 실현했습니다. 현재의 virtualenv 사용 방식은 workingenv에서 만들어진 것입니다.

 -  애플리케이션마다 별도의 “**환경**”(env)을 만듭니다.
 -  애플리케이션을 실행하기 전에 우선 그 “환경”을 “**활성화**”(`. bin/activate` 또는 `Scripts\activate.bat`)합니다.

workingenv가 만들어주는 활성화 스크립트는 `PATH`와 `PYTHONPATH` 환경 변수를 재정의하여 시스템에 설치된 파이썬 인터프리터의 실행 바이너리 디렉터리 및 site-packages 디렉터리를 가리키는 대신, “환경” 내의 bin/ 및 site-packages 디렉터리를 바라보도록 해줍니다. 이안 비킹은 이렇게 분리된 실행 파일들(bin/)과 site-packages 등을 묶어서 “환경”이라고 명명했는데, workingenv 이후로 파이썬 패키징 및 배포 분야에서 이 용어가 정착됩니다.

최근에 만들어진 신생 언어의 패키지 관리자는 대부분 파이썬과 달리 애플리케이션·프로젝트마다 별도의 환경을 두고 설치되는 경우가 많습니다. 예를 들어 [npm][]은 [`-g` 옵션][7]을 일부러 켜지 않는 한 현재 디렉터리를 기준으로 ./node\_modules 디렉터리에 라이브러리를 설치하게 되어 있고, 별도의 “활성화” 없이도 노드 인터프리터가 해당 경로에서 라이브러리를 찾습니다. 하지만 파이썬의 패키징 표준은 앞서 언급한 것처럼 멀티테넌시 환경이 일반적이었던 시대에 만들어졌고, 또 많은 라이브러리가 실행 파일도 함께 제공하기 때문에[^2] `PYTHONPATH` 뿐만 아니라 `PATH` 환경 변수도 재정의해야 해서 `activate` 과정이 필요합니다.

workingenv는 파이썬 웹 프로그래머 사이에서 빠르게 퍼지기 시작했습니다. 웹 애플리케이션은 정통적인 CLI 및 GUI 애플리케이션과 달리 FHS 표준 같은 것에 크게 구애될 필요가 없었고, 웹 애플리케이션의 배포도 점차 가상화 기술을 통해 완전히 격리된 시스템에 설치되는 식으로 보안 문제에서 많이 자유로워졌기 때문입니다.

무엇보다 workingenv는 프로그래머가 여러 프로젝트를 동시에 작업하는 경우 골치 아팠던 라이브러리 버전 충돌 문제를 우회했기 때문에, 배포 도구보다는 개발 도구로 정착되는 면이 컸습니다.

[^2]: 예를 들어 파이썬에서 가장 많이 쓰이는 국제화 라이브러리인 [바벨][8]은 `pybabel` 명령어를, 구문 강조 라이브러리인 [파이그먼츠][9]는 `pygmentize` 명령어를, [장고][10]는 `django-admin` 명령어를 제공합니다.

[6]: http://www.ianbicking.org/
[7]: https://docs.npmjs.com/getting-started/installing-npm-packages-globally
[8]: http://babel.pocoo.org/
[9]: http://pygments.org/
[10]: https://www.djangoproject.com/
[workingenv]: https://pypi.python.org/pypi/workingenv.py
[npm]: https://www.npmjs.com/


## [virtualenv][]

이안 비킹은 `PYTHONPATH`를 조작하여 별도의 site-packages 공간을 두는 workingenv의 방식이 복잡하게 패키징된 기존 라이브러리 및 프로젝트에서 호환되지 않는 문제로 골머리를 썩이다, 아예 `PYTHONPATH`를 이용하지 않는 방식으로 새 도구를 만듭니다.

새로운 방식은 아예 파이썬 인터프리터 실행 바이너리를 복사한 뒤, `sys.path` 기본값에 박힌 시스템 site-packages 경로를 환경 내 site-packages 경로로 바꿔버리는 것이었습니다. 이러한 동작 원리의 차이는 이용자 입장에서 크게 중요한 것은 아닙니다.

하여튼 이안 비킹은 [virtualenv][]라는 이름으로 새 도구를 만들었고, workingenv를 빠르게 대체했습니다.

[virtualenv]: https://virtualenv.pypa.io/


## [virtualenvwrapper][]

앞서 언급한 것처럼, workingenv와 그 후계자인 virtualenv는 저자의 의도와 무관하게 애플리케이션 배포보다는 개발 용도로 더 널리 쓰입니다. 파이썬 프로그래머가 새로운 프로젝트를 시작할 때는 항상 “환경”도 생성합니다. 또 개발을 시작할 때마다 “활성화” 과정도 거칩니다. 너무나 반복적이기 때문에 당연히 이를 자동화하는 도구도 만들어졌습니다. [virtualenvwrapper][]는 바로 그런 목적으로 만들어진 bash/zsh/fish 스크립트 모음입니다.

여러 단축 명령을 제공하지만, 핵심 기능은 다음의 두 가지입니다.

 -  A라는 프로젝트 작업을 시작할 때마다 `cd ~/projects/a; . .venv/bin/activate`라고 쳐줘야 했던 것을 `workon a` 명령으로 줄여줍니다.

 -  프로젝트 디렉터리마다 .venv/ 또는 .env/ 등의 이름으로 환경 디렉터리를 생성해두고 버전 관리 시스템에서는 제외되도록 .gitignore 목록에 해당 디렉터리를 넣었어야 했습니다.
    예를 들어 ~/projects/a/.venv/, ~/projects/b/.venv/ 같은 식이었습니다.

    virtualenvwrapper를 쓰면 환경 디렉터리들을 일정한 위치로 모아줍니다.
    위치는 기본값이 없으며 virtualenvwrapper 설치할 때 `WORKON_HOME` 환경 변수를 통해 입맛대로 정할 수 있습니다.
    예를 들어 `WORKON_HOME`을 ~/.virtualenvs/ 디렉터리로 정했다면, 프로젝트별 환경은 ~/.virtualenvs/a/, ~/.virtualenvs/b/ 같은 식으로 저장됩니다.

[virtualenvwrapper]: https://virtualenvwrapper.readthedocs.io/


## [pyvenv][]

[파이썬 3.3부터는 virtualenv가 아예 파이썬에 내장됐습니다.][pyvenv] 환경을 만드는 명령어는 `virtualenv`가 아닌 `pyvenv`로 좀 다르지만, 그 이후의 과정은 같습니다. 파이썬 3만 사용한다면 이제 virtualenv를 따로 설치할 필요가 없어진 것입니다.

참고로 아래에서 설명할 pyenv와는 다른 도구입니다. 철자의 “v”에 주의해주세요.

[pyvenv]: https://docs.python.org/3/library/venv.html


## [pyenv][]

애플리케이션을 개발할 때는 하나의 파이썬 버전을 정하면 되지만, 라이브러리는 여러 파이썬 버전과 호환되어야 합니다. 그러다 보니 라이브러리 개발자는 여러 버전의 파이썬을 시스템에 동시에 설치할 필요가 있습니다. [데드스네이크스 PPA][11]나 [데드스네이크스 홈브루 탭][12] 같은 것을 이용해서 설치할 수도 있지만, 보통은 [pyenv][]를 많이 씁니다.

pyenv는 동시에 여러 버전의 파이썬을 시스템에 설치해주며, 이렇게 설치된 파이썬은 시스템의 패키지 시스템(데비안·우분투의 APT나 맥OS의 홈브루 등)을 통해 설치되는 것이 아니라, pyenv가 다운로드와 빌드 및 설치를 직접 하여 별도로 관리합니다. 설치된 파이썬들은 [PEP 394][]에 따라 일정한 형식으로 이름지어진 명령어(예: `python2.7`, `python3.6`)로 실행할 수 있게 됩니다.

또한, 여러 파이썬 버전 중에 하나의 시스템 기본 파이썬 버전도 선택 가능하며, 특정 프로젝트 디렉터리 안에서만 기본 파이썬의 버전이 달라지게 할 수도 있습니다.

[11]: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
[12]: https://github.com/drolando/homebrew-deadsnakes
[pyenv]: https://github.com/pyenv/pyenv
[PEP 394]: https://www.python.org/dev/peps/pep-0394/


## [pyenv-virtualenv][]

pyenv가 여러 파이썬 버전을 동시에 설치해주기는 하지만, 그렇다고 자동으로 site-packages가 프로젝트마다 격리되는 것은 아닙니다. 예를 들어 pyenv로 파이썬 3.6을 설치한 뒤, 파이썬 3.6으로 두 프로젝트를 한 시스템에서 개발할 경우 두 프로젝트는 시스템 site-packages를 함께 쓰게 됩니다.

따라서 pyenv를 쓰더라도 virtualenv는 따로 써야 하는데, 따로 사용할 수도 있지만 [pyenv-virtualenv][]를 쓰면 `pyenv virtualenv` 명령으로 프로젝트에 쓸 파이썬 버전 지정과 가상 환경 생성을 한 번에 할 수 있게 됩니다.

비슷하게 pyenv와 virtualenvwrapper를 통합해주는 [pyenv-virtualenvwrapper][] 같은 도구도 있습니다.

[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv-virtualenvwrapper]: https://github.com/pyenv/pyenv-virtualenvwrapper


## 마치며

여러 파이썬 개발 환경 관리 도구를 소개했지만, 여기 있는 모든 도구를 꼭 써야 하는 것도 아니고, 가장 최근에 나온 도구로 하루빨리 갈아타야 하는 것도 아닙니다. 글을 쓴 저 자신도 pyenv 같은 도구가 나온 지 몇 년이나 지났고 주변에서 쓰는 사람이 많음에도 쓰지 않고 있습니다. virtualenvwrapper를 대체하는 [Pipenv][] 같은 실험적인 방식[^3]도 생겨나고 있지만, 어느 쪽이든 동시에 여러 파이썬 프로젝트를 작업하는 사람이 아니라면 굳이 쓸 필요가 없는 도구입니다. 각자의 용도에 따라 필요한 수준의 도구를 이용하면 됩니다. 2017년 10월 현재, 아래의 지침으로 정리할 수 있겠습니다.

파이썬 프로그래머가 아니지만, 파이썬 애플리케이션을 설치해서 이용합니다.
:   시스템에서 제공하는 패키지 관리자(APT나 홈브루 등)를 통해 애플리케이션을 설치하세요.

파이썬 프로그래머가 아니지만, 파이썬 애플리케이션을 유난히 많이 이용합니다.
:   [pipsi][]를 이용해 파이썬 애플리케이션을 설치하는 것을 권합니다.

파이썬 프로그래머이고, 하나의 애플리케이션을 개발합니다.
:   파이썬 3.3 이상을 이용할 경우 pyvenv로 개발 환경을 만들어서 개발하세요. 그 이전의 파이썬 버전을 이용할 경우 virtualenv를 활용하세요.

파이썬 프로그래머이고, 여러 애플리케이션을 개발합니다.
:   virtualenvwrapper를 활용하세요.

파이썬 프로그래머이고, 여러 애플리케이션을 다양한 파이썬 버전으로 개발합니다.
:   pyenv-virtualenvwrapper를 활용하세요.

파이썬 프로그래머이고, 라이브러리를 개발합니다.
:   pyenv와 [tox][]를 활용하세요.

[^3]: 저는 2017년 4월에 한 번 써보았으나, 아직은 실무에서 쓰기에는 이르다는 결론을 내렸습니다. 이에 관한 그때의 제 감상은 [별도의 글][13]로 다루었습니다.


[13]: https://www.facebook.com/hongminhee/posts/10212639468281474
[Pipenv]: https://docs.pipenv.org/
[pipsi]: https://github.com/mitsuhiko/pipsi
[tox]: https://tox.readthedocs.io/
*[APT]: Advanced Package Tool