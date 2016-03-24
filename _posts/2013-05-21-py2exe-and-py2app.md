---
layout: entry
title: py2exe와 py2app을 통한 Windows/OS X용 실행파일 만들기
author: 문성원
description: py2exe와 py2app을 통해 Windows와 Mac OS X에서 실행 가능한 파일을 어떻게 만들어내는지 알아봅니다.
---

안녕하세요. [스포카 개발팀]의 문성원입니다. 오늘은 [Python]으로 작성된 프로그램을 [Microsoft Windows] 혹은 [Mac OS X][OS X]에서 독립적으로 실행 가능하게끔 묶어주는 [py2exe]와 [py2app]에 대해 알아보겠습니다.


# A long time ago

어떤 회사 이야기를 먼저 들려드리겠습니다. 어떤 모바일 앱을 통한 서비스를 제공하는 회사가 있었습니다. (2010년도 전후로 많이 생긴 그런 회사죠.) iOS나 안드로이드 기반의 모바일 클라이언트 앱과 TCP나 HTTP 등을 통해 그러한 앱과 통신하여 서비스의 중추를 이루는 서버를 개발하는 크게 2가지 분야의 프로그래머가 필요한 일이죠.

그런데 어느 날 갑자기 

"Windows에서 돌아갈 GUI 기반의 프로그램이 필요합니다."

란 요청이 들어왔습니다. 회사 프로그래머 중 VC/C#/VB/Delphi 등에 익숙한 사람은 당연히(?) 없었기 때문에 자연스럽게 프로그램은 [Python]으로 작성하게 되었습니다. (사실 이 부분은 나중에 다른 글로 소개해드릴 예정입니다.)

(이미 짐작하셨겠지만 이건 저희 회사의 작년 이맘때쯤 이야기입니다.)


# Why can't?

프로그램은 어찌저찌해서 작성했습니다만 이대로는 곤란합니다. 일반적인 PC에 [Python]이 깔려있을 가능성은 몹시 적기 때문이죠. [Python] 해석기(Interpreter)가 없는 이상 기껏 작성한 스크립트는 실행할 수 없습니다. 물론 프로그램 배포 시에 같이 설치하게끔 하는 것도 방법이겠지만 그래서야 배포가 너무 귀찮아집니다.

다행히도 세상에는 저희와 같은 고민을 하는 사람이 무척 많았고 또 그중에 몇몇은 이미 훌륭한 대안을 내놓았습니다. 그 중 하나가 바로 지금 소개해 드릴 [py2exe]입니다.

# py2exe

[py2exe]는 이름에서 알 수 있듯이 [Python]으로 작성된 스크립트를 [Windows 실행 파일(.exe)](http://en.wikipedia.org/wiki/EXE)로 변환해주는 일종의 변환기입니다. [Python]의 패키징 표준이었던 [distutils]의 확장으로 작성되어있으며 [Windows][Microsoft Windows]에 설치된 [Python]만으로 완벽하게 동작하는 것이 특징입니다.

[distutils] 확장답게 패키징에는 `setup.py`를 이용합니다. 직접 따라 해 보실 분들은 [다음 튜토리얼](http://qt-project.org/wiki/Hello-World-in-PySide)를 참고로 간단한 GUI 프로그램을 작성해서 `run.py`로 저장하신 뒤 진행하시면 됩니다. 물론 실습에는 [Windows][Microsoft Windows]가 설치된 시스템과 [Python], [PySide]가 필요합니다.

{% highlight python %}
# -*- coding: utf-8 -*-
from setuptools import setup
import py2exe

# name, description, version등의 정보는 일반적인 setup.py와 같습니다.
setup(name="test_py2xxx",
      description="py2exe test application",
      version="0.0.1",
      windows=[{"script": "run.py"}],
      options={
          "py2exe": {
              # PySide 구동에 필요한 모듈들은 포함시켜줍니다.
              "includes": ["PySide.QtCore",
                           "PySide.QtGui",
                           "PySide.QtWebKit",
                           "PySide.QtNetwork",
                           "PySide.QtXml"],
              # 존재하지 않거나 불필요한 파일은 제거합니다.
              "dll_excludes": ["msvcr71.dll",
                               "MSVCP90.dll"],
          }
      })
{% endhighlight %}

패키징은 다음 커맨드로 실행합니다.

{% highlight bash %}
$ python setup.py py2exe
{% endhighlight %}

결과 파일은 `dist` 디렉터리에 생성됩니다. 그런데 결과 파일이 몹시 복잡합니다. 조금 정리해보죠. 우선 배포에 필요한 DLL 등을 한번에 묶어 하나의 실행 파일로 배포하고 싶다면 다음과 같이 `bundle_files` 플래그를 설정합니다.

{% highlight python %}
# ...
setup(
    # ...
    options={
        "py2exe":{
            bundle_files: 1,
            # ...
        }
    })
{% endhighlight %}

하지만 여전히 `library.zip`은 남아있습니다. 이 파일은 실행에 필요한 [Python] 라이브러리들을 보관하고 있는 파일로 `zipfile` 옵션을 통해 없앨 수 있습니다.

{% highlight python %}
setup(
    # ...
    options={
        "py2exe":{
            # ...
        }
    },
    zipfile=None)
{% endhighlight %}

마지막으로 실행 파일명이나 아이콘(`.ico`)파일을 변경하고 싶을 때는 다음과 같이 설정합니다.

{% highlight python %}
# ...
setup(
    # ...
    windows=[{"scripts": "run.py",
              "icon_resources": [(1, "resources/window_icon.ico")],
              "dest_base": "myfirstapp"}],
    # ..
)
{% endhighlight %}

이외 다양한 사항에 대해서는 [공식 사이트][py2exe]에 소개된 [옵션 목록](http://www.py2exe.org/index.cgi/ListOfOptions), 그리고 [일반적인 팁과 트릭](http://www.py2exe.org/index.cgi/GeneralTipsAndTricks) 페이지에서 찾아보실 수 있습니다. 사실 [py2exe]의 문제점은 잘 정리된 문서를 찾기 힘들다는 점인데, 저희는 최대한 기존에 있던 사용례에 비슷한 문서를 살펴보고 그래도 없는 경우는 실제 구현된 소스를 참고해가며 개발했습니다.

# py2app

그러던 어느 날 갑자기 이런 문의가 들어옵니다. 

"전에 만들어주신 프로그램, 맥용으론 다시 만들어야 하나요?"

어차피 [Python]으로 작성되어있고 [OS X]엔 이미 [Python]이 설치되어있으니 문제가 없을 것 같습니다. 하지만 이건 "가능하다"는 수준이지 최종 사용자에게 내놓기엔 너무 조잡 해보입니다. "우선 터미널 실행하시고요. `python run.py`를 치시면 됩니다." 라고 말할 순 없잖아요?

다행히 여기에도 해결책은 준비되어 있습니다. 그 중 하나가 앞서 소개한 [py2exe]의 영향을 받은 [py2app]입니다. 이름에서 알 수 있듯이 [py2app]의 사용법은 [py2exe]와 굉장히 유사합니다. 우선 다음과 같이 `setup.py`를 작성합니다.

{% highlight python %}
# -*- coding: utf-8 -*-
from setuptools import setup

# name, description, version등의 정보는 일반적인 setup.py와 같습니다.
setup(name="test_py2xxx",
      description="py2app test application",
      version="0.0.1",
      # 설치시 의존성 추가
      setup_requires=["py2app"],
      app=["run.py"],
      options={
          "py2app": {
              # PySide 구동에 필요한 모듈들은 포함시켜줍니다.
              "includes": ["PySide.QtCore",
                           "PySide.QtGui",
                           "PySide.QtWebKit",
                           "PySide.QtNetwork",
                           "PySide.QtXml"]
          }
      })
{% endhighlight %}

그다음 

{% highlight bash %}
$ python setup.py py2app
{% endhighlight %}

을 실행하면 마찬가지로 `dist` 디렉터리에 애플리케이션이 생성됩니다. (물론 이 과정은 [OS X]가 설치된 시스템에서 실행하셔야 합니다.) 생성한 앱은 커맨드라인에서 이렇게 실행합니다. (로그 메시지를 바로 확인할 수 있어 디버그 시에 유용합니다.)

{% highlight bash %}
$ ./dist/test_py2xxx.app/Contents/MacOS/test_py2xxx
{% endhighlight %}

혹은 `open` 명령어를 사용해서 일반적인 애플리케이션처럼 실행도 가능합니다.

{% highlight bash %}
$ open ./dist/test_py2xxx
{% endhighlight %}

다소 초라해 보이는 기본 아이콘을 바꾸려면 `iconfile`을 다음과 같이 설정합니다.

{% highlight python %}
# ...
setup(
    # ...
    options={
      "py2app": {
            # ...
            "iconfile": "window_icon.icns"
      }
    })
{% endhighlight %}

[py2exe]와 [py2app] 둘 다 [distutils]의 확장이기 때문에 다음과 같이 함께 사용할 수도 있습니다.

{% highlight python %}
# -*- coding: utf-8 -*-
from setuptools import setup
import sys

if sys.platform == "win32":
    # python setup.py py2exe
    import py2exe
    platform_options = {
        "windows": [{
            "script": "run.py",
            "icon_resources": [(1, "window_icon.ico")],
            "dest_base": "dodo"
        }],
        "zipfile": None,
        "setup_requires": ["py2exe"],
        "options": {
            "py2exe": {
                "includes": ["PySide.QtCore",
                             "PySide.QtGui",
                             "PySide.QtWebKit",
                             "PySide.QtNetwork",
                             "PySide.QtXml"],
                "dll_excludes": ["w9xpopen.exe",
                                 "msvcr71.dll",
                                 "MSVCP90.dll"],
                "compressed": True
            }
        }
    }
elif sys.platform == "darwin":
    # python setup.py py2app
    platform_options = {
        "setup_requires": ["py2app"],
        "app": ["run.py"],
        "options": {
            "py2app": {
                "argv_emulation": True,
                "includes": ["PySide.QtCore",
                             "PySide.QtGui",
                             "PySide.QtWebKit",
                             "PySide.QtNetwork",
                             "PySide.QtXml"],
                "iconfile": "window_icon.icns"
            }
        }
    }
else:
    # python setup.py install
    platform_options = {
        "scripts": ["run.py"]
    }
    
setup(name="test_py2xxx",
      description="py2xxx test application",
      version="0.0.1",
      **platform_options)
{% endhighlight %}

보다 다양한 옵션은 [다음 페이지](http://pythonhosted.org/py2app/)에서 찾아보실 수 있습니다. (아무래도 [py2exe] 보단 후발주자다 보니 전반적으로 비슷하면서도 약간 더 세련된 형태긴 합니다.)

# Alternatives

[PyInstaller]는 [py2exe]와 [py2app]과는 다르게 처음부터 여러 플랫폼을 지원하는 목적으로 한 도구입니다. [cx_Freeze]은 [Python 3.x](http://docs.python.org/3/)를 사용하신다면 고려해볼 수 있는 대안입니다. (물론 2.x도 지원합니다.)


  [스포카 개발팀]: https://spoqa.github.io/
  [Python]: http://www.python.org/
  [Microsoft Windows]: http://en.wikipedia.org/wiki/Microsoft_Windows
  [OS X]: http://en.wikipedia.org/wiki/OS_X
  [py2exe]: http://www.py2exe.org/
  [py2app]: https://pypi.python.org/pypi/py2app/0.7.3
  [distutils]: http://docs.python.org/2/library/distutils.html
  [NSIS]: http://nsis.sourceforge.net/
  [PyInstaller]: http://www.pyinstaller.org/
  [cx_Freeze]: http://cx-freeze.sourceforge.net/
  [PySide]: http://qt-project.org/wiki/Category:LanguageBindings::PySide
