---
layout: entry
title: flake8-import-order-spoqa
author: 홍민희
author-email: hong@spoqa.com
description: 스포카 사내 파이썬 임포트 스타일 린트를 소개합니다.
publish: true
---

안녕하세요. 스포카 프로그래머 홍민희입니다.

스포카 사내에서는 파이썬 코드의 스타일을 맞추기 위해 [flake8][]을 사용해왔습니다. [PEP 8][]
스타일을 준수하게 해주고, 안 쓰는 임포트를 꼭 지우게 하는 등의 좀더 구체적인 규칙도 지키게 해주는 린트
도구입니다. 사실상의 표준이기 때문에 파이썬을 이미 쓰고 있는 분들이라면 많이들 알고 계실 것입니다.

그렇지만 `import`문의 사용에 대해서는 우리가 원하는 것만큼의 규칙을 제공하지 않아서,
예전부터 동료 [강효준][] 님이 [import-order][]를 별도로 만들어서 써왔습니다. 만들었을 당시에는
`import`문의 쓰임에 대한 린트 도구가 없었기 때문에 유용하게 써왔고, 다른 파이썬 오픈 소스
프로젝트에서도 유용할 것 같다고 생각하여 쓰인지 1년쯤 지난 뒤에 오픈 소스로 공개했습니다.

하지만 flake8과는 다르게 외부 커뮤니티에서 널리 쓰이지는 못했고, 사실상의 표준이 되었다면
편집기 연동 등이 이뤄졌겠지만, 그에 미치지는 못했습니다.
[pre-commit hook][]이나 CI에서나 검사가 이뤄지기 때문에, 코딩을 마쳤다고 생각한 이후에
뒷북으로 실수를 바로잡는 일이 많아 불편했습니다.

그 뒤로 시간이 지나자 커뮤니티에서는 [flake8-import-order][]라는 도구가 나와서 사실상의 표준이
됐습니다. 이미 많은 편집기에서 연동이 되는 flake8의 확장으로 구현됐기 때문에 편집기에서 즉시 확인이
가능했고, 더 많은 옵션도 제공했습니다. 그렇지만 [cryptography][] 프로젝트 사람들이 만든 도구다보니, cryptography 스타일 및 [Google 스타일][] 등 몇 가지만 제공했고, 이 도구를 활용하려면 스포카에서
3년 넘게 쓰이던 `import` 스타일을 포기하고 사내의 모든 코드를 전부 수정하는 난리를 피우거나,
flake8-import-order에 스포카 사내 스타일을 옵션으로 추가하거나,
프로젝트를 포크해서 별도로 유지보수하며 써야 했습니다.

사내 모든 코드를 전부 수정하는 것은 쉽지도 않을 뿐더러, 스포카에서 쓰이던 스타일에도 나름의 논거는 있기
때문에 쉽게 포기하기는 힘든 결정이었습니다. 일부 프로젝트부터 옮겨가는 시도도 있었으나,
같은 회사에서 코드마다 스타일의 일관성이 달라지는 혼란이 있었습니다.

저는 flake8-import-order에 스타일을 추가하는 것을 주저했습니다. Google 스타일처럼 문서화가 이미
아주 자세히 되어 있지도 않고 유명하지도 않은, 일개 회사의 사내 스타일을 사실상의 표준 린트 도구의 7번째
공식 지원 스타일로 추가하는 것이 이뤄질 개연성이 낮다고 봤습니다.

그래서 프로젝트를 포크하기로 마음먹은 것이 보름 전쯤입니다. 그런데 코드를 열어보니 좀더 나은 아이디어가
떠올랐습니다. flake8-import-order의 코드를 고치지 않고 런타임에 스타일을 확장 가능한 플러그인
구조를 추가하면, 스포카에서 쓰는 `import` 스타일을 별도 패키지로 구현할 수도 있다는 생각이 든 것입니다.
당시 flake8-import-order의 스타일 구현은 `Style`의 기반 클래스를 상속받는 식으로 이뤄져 있었고,
다만 스타일의 목록이 하드코딩되어 있는 것이 문제였습니다. 막상 코드를 읽어보니 플러그인 구조를 도입하는
것이 어렵지 않을 것이라는 생각이 든 것입니다.

파이썬 생태계에서는 서로 다른 패키지 사이에서 런타임에 확장 가능한 의존성 주입을 위해 [setuptools][]
시스템이 [엔트리 포인트][]라는 개념을 제공합니다. 예를 들어 국제화 라이브러리인 [Babel][]은
파이썬 이외의 프로그래밍 언어에서도 gettext 문자열을 extract할 수 있게 하기 위해, [확장 가능한
`babel.extractors` 엔트리 포인트를 노출합니다.][babel.extractors] 그리고 별도의 템플릿 언어인
[Jinja][]는 해당 템플릿 엔진을 쓸 때 국제화도 대응할 수 있도록, [`babel.extractors` 엔트리
포인트에 Jinja 언어를 해석하는 `jinja2.ext.babel_extract`를
주입합니다.][jinja2.ext.babel_extract]

저는 같은 개념을 활용하여, [flake8-import-order가 `flake8_import_order.styles`라는
엔트리 포인트를 노출][flake8_import_order.styles]하게 하는 [패치][#103]를 제출했고,
다행히도 업스트림에 받아들여졌습니다.

flake8-import-order를 런타임에 확장할 수 있는 구조가 됐으니, flake8-import-order 위에서
스포카의 `import` 사용 가이드를 구현하는 것은 어렵지 않은 작업이었습니다. 어차피 스포카의 파이썬
코딩 스타일은 대부분 PEP 8을 그대로 따르고 있었고, 따라서 flake8-import-order에 이미 존재하는
스타일 구현에서 몇 부분만 덮어씌우는 것으로 충분했기 때문입니다.

위와 같은 장광설 끝에, 그래서 이번에 소개하려고 한 스포카의 파이썬 `import` 린트 도구는
[flake8-import-order-spoqa][]입니다. 만든지 보름이 지난 뒤에 소개하는 것은,
[flake8-import-order에 제출한 패치][#103]가 포함된
[0.12가 PyPI에 릴리스][flake8-import-order-0.12]될 때까지 기다려야 했기 때문입니다.

사용법은 어렵지 않습니다. pip로 `flake8-import-order-spoqa`를 설치한 뒤에, flake8 설정에
다음 옵션을 추가하면 됩니다.

```ini
[flake8]
import-order-style = spoqa
```

[flake8]: https://gitlab.com/pycqa/flake8
[PEP 8]: https://spoqa.github.io/2012/08/03/about-python-coding-convention.html
[강효준]: https://github.com/admire93
[import-order]: https://github.com/spoqa/import-order
[pre-commit hook]: https://git-scm.com/book/uz/v2/Customizing-Git-Git-Hooks#_committing_workflow_hooks
[flake8-import-order]: https://github.com/PyCQA/flake8-import-order
[cryptography]: https://cryptography.io/
[Google 스타일]: https://google.github.io/styleguide/pyguide.html
[setuptools]: https://setuptools.pypa.io/
[엔트리 포인트]: https://setuptools.readthedocs.io/en/latest/pkg_resources.html#entry-points
[Babel]: http://babel.pocoo.org/
[babel.extractors]: http://babel.pocoo.org/en/latest/messages.html#writing-extraction-methods
[Jinja]: http://jinja.pocoo.org/
[jinja2.ext.babel_extract]: http://jinja.pocoo.org/docs/2.9/integration/#babel-integration
[flake8_import_order.styles]: https://github.com/PyCQA/flake8-import-order#extending-styles
[#103]: https://github.com/PyCQA/flake8-import-order/pull/103
[flake8-import-order-spoqa]: https://github.com/spoqa/flake8-import-order-spoqa
[flake8-import-order-0.12]: https://pypi.python.org/pypi/flake8-import-order/0.12
