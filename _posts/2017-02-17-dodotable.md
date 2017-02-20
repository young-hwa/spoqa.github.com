---
layout: entry
title: 도도 테이블 101
author: 강효준
author-email: ed@spoqa.com
description: 스포카의 사내 라이브러리 도도 테이블에 대해 소개합니다.
publish: true
---

[도도 테이블][dodotable]은 Python의 대표적인 ORM인 [SQLAlchemy][]에서
검색해온 결과를 HTML `<table>` 태그로 쉽게 보여주는 파이썬 라이브러리입니다.
도도 테이블을 만들게 된 이유와 사용법을 간단하게 소개하려고 합니다.


## 도도 테이블을 만든 이유

[도도 인사이트][dodo-insight]는 도도 포인트를 이용하는 점주들이 매장에 적립한
손님을 관리할 수 있는 서비스이면서,
스포카 사내에서 [스토어 플래너팀(이하 SP)][spoqa-sp]과
[파트너 컨설턴트팀(이하 PC)][spoqa-pc]이 매장을 쉽게 관리하도록 도와주는
[CRM][] 서비스입니다.

![dodotable](/images/2017-01-22/dodotable.png)

그렇기 때문에 도도 인사이트는 적립/사용 결과를 요약하여 보여주는
분석 기능 이외에도 고객 목록, 매장/브랜드 목록, 적립/사용 기록과 같이 테이블의
형태로 보여주는 것이 적합한 정보들도 많이 제공하고 있습니다. 따라서
도도 인사이트 서버에 저장된 기록들을 가공하여 `<table>`의 형태로 보여주는 일이
빈번하게 일어나고, 이를 위한 라이브러리가 필요한 상태였습니다.


### URL은 보존되어야 한다

`<table>`을 보여주기 위해서 도도 테이블이 만들어지기 전에 사내에서 주로 사용하던
라이브러리는 [datatable][]이었습니다. datatable은 여러 데이터
소스(DOM, JavaScript, Ajax 등)를 지원하는 jQuery 플러그인입니다.
도도 인사이트에서는 Ajax를 이용해 비동기 통신으로 데이터를 얻어오도록 했었는데,
그래서 페이지 이동, 검색, 필터링 등의 기능이 있었지만 웹 브라우저의
URL은 변경되지 않고 하나로 고정되어 보였습니다.[^1]

비동기 통신인 만큼 웹 페이지 전체 로딩을 하지 않고 그만큼 로딩 시간을 줄일 수
있다는 장점도 있지만, 다음의 단점들이 있습니다.

첫 번째, 브라우저의 뒤로 가기 혹은 앞으로 가기 버튼을 사용하지 못합니다.
웹 브라우저는 URL을 이용하여 리소스의 위치를 얻어오므로 보이는 리소스가
변경되었을때 URL이 변하지 않는다면 웹 브라우저의 고유 기능인
뒤로/앞으로 가기를 사용하지 못하게 됩니다.

두 번째, 내부 팀 혹은 매장에서 특정 페이지의 정보를 공유 받을 때 스크린샷 혹은
구두로 리소스의 위치를 전달받을 수밖에 없습니다. 도도 포인트는 매장과 손님의
관계를 이어주는 서비스인 만큼 손님의 포인트 적립/사용 정보, 잔여 포인트,
손님이 받은 쿠폰 등이 중요하고 이를 확인해야하는 상황도 빈번하게 발생합니다.
이럴때 다음과 같은 정보를 URL없이 전달한다면 어떨까요?

- A매장이 손님 목록을
- 최근 방문 일시로 오름차순 정렬 후에
- 남자 손님으로 필터링하고
- 4번째 페이지, 7번째 줄을 선택했을 때

기능 버그나 손님의 정보에 문제가 있어 이슈까지 생성해야 한다면
이슈를 만드려고 하는 SP와 PC가 문제가 있는 자료의 위치를 바로 개발팀에게
전달할 수 없을 것입니다.


### SQLAlchemy 모델 구조와 테이블 구조를 활용하도록

스포카에서는 많은 서비스와 제품들이 Python으로 작성되었고, 또한 SQLAlchemy도
적극적으로 이용하고 있습니다. 그런데 jQuery 플러그인인 datatable을 사용하면
비동기 통신을 요청하는 JavaScript 코드와 API 서버에서 이를 처리하도록
Python 코드를 작성해야합니다.

이런 API에서 복잡한 로직을 작성하는 일은 드물고, 비슷하게
반복되는 패턴이 있습니다.

- HTTP 요청에 쿼리 문자열 혹은 요청 내용으로부터 여러 조건을 전달받습니다.
  - 어떤 페이지를 가지고 올 것인가?
  - 정렬은 어떻게 할 것인가?
  - 어떤 단어를 검색하고 싶은가?
- 이 조건들을 해석하고 데이터를 저장하고 있는 매체
  (캐시 레이어, 데이터베이스 등등)에 필요한 정보를 가지고 오도록 요청합니다.
- 가지고 온 데이터는 리소스를 요청한 클라이언트에서 사용할 수 있도록 직렬화하여
  응답합니다. 스포카에서는 주로 직렬화 포맷으로 JSON을 사용합니다.

API의 핵심적인 로직은 저장 매체로부터 필요한 정보를 가지고 오도록 하는
부분입니다. 하지만 조건들을 어떻게 해석할 것이며(deserialize 또는 parsing)
이를 요청하는 쪽에 전달할 수 있는 형태로 바꾸는데(serialize)
더 많은 시간을 사용하게 됩니다. 그렇기때문에 이러한 점을 데이터 구조(schema)에
맞추어 일반화한다면, API를 작성하는데 드는 시간을 단축시킬 수 있을 것입니다.

이런 조건들을 만족하도록 jQuery 플러그인인 datatable을 사용한다면,
웹 브라우저 안에서 실행되어야 하므로 API 서버는 서버 안에서 정의된
SQLAlchemy 데이터를 직렬화하여 datatable에게 전달해야 하고 datatable은 전달받은
데이터를 이용하여 역직렬화(deserialize)하여 테이블에 보여주게 됩니다.
datatable을 사용하면 직렬화, 역직렬화하는 과정이 추가되기 때문에 SQLAlchemy의
구조를 활용하지 못하고, 직렬화와 역직렬화하는 코드를 작성하는데 시간을 많이
쏟게 됩니다.


## 도도 테이블 사용하기

도도 테이블은 [문서 맨 앞][dodotable-readme]에 쓰여있는 것처럼 SQLAlchemy 쿼리
결과를 HTML로 나타내는 도구입니다.
도도 테이블을 구현하면서 위에 언급했던 문제들을 어떻게 풀어냈는지
설명해보려고 합니다.


### `<table>` 태그와 Python 코드를 비슷하게 맞추기

노래 정보를 가지고있는 `music` 테이블이 아래와 같은 구조를 가지고
있다고 가정하고,

| id                                    | name     |
|---------------------------------------|----------|
| 80ca1ad0-2dd6-4bfd-9b1b-fba97141279a  | 9 crimes |
| f86177c7-226e-483e-bd07-ce06dd8cc5be  | Hello    |

`music` 테이블의 자료를 HTML로 표현하려면

```html
<table>
  <thead>
    <tr>
      <th>음악 ID</th>
      <th>이름</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>80ca1ad0-2dd6-4bfd-9b1b-fba97141279a</td>
      <td>9 crimes</td>
    </tr>
    <!-- 자료의 갯수가많으면 `<tr>`이 늘어남 -->
  </tbody>
</table>
```

이런 구조로 작성하게 됩니다. 이 마크업을 도도 테이블을 사용해서
몇 개 인자만 채워넣어 비슷하게 맞춰보면

```python
from dodotable.schema import Table, Column

# music 테이블을 SQLAlchemy 모델로 구현
from .entities import Music
# SQLAlchemy ORM session
#
# .. notes::
#    http://docs.sqlalchemy.org/en/latest/orm/session_api.html?highlight=session#session-and-sessionmaker
from .orm import session

table = Table(
    Music,
    columns=[
        Column('id', label='음악 ID'),
        Column('name', label='이름'),
    ],
    sqlalchemy_session=session
)
```

정도로 작성할 수 있습니다. 도도 테이블에서는 `dodotable.schema.Table`이
인자로 받은 `Music`과 `dodotable.schema.Column`의 정보로 SQLAlchemy 쿼리를
생성합니다. 위 예제에서 보이는 것처럼 `dodotable.schema`에 있는
`Table`, `Column`, `Row`등의 클래스는 적당한 역할을 가지도록 크게 3가지 클래스를
상속받습니다. 이를 간단히 소개해보자면,

- `dodotable.schema.Schema`는 테이블의 구성 요소를 나타냅니다. 테이블을 HTML
  로 출력할 때 어디서 템플릿 파일을 가지고 올 지,
  도도 테이블 템플릿 내부 함수는 어떤식으로 가지고 올지 등을 정의할 수 있도록
  환경[^2]을 갖습니다.
- `dodotable.schema.Queryable`은 SQLAlchemy 쿼리를 생성할 수 있음을 나타내는
  클래스입니다. 이 클래스의 서브 클래스는 `__query__`를 구현하여
  자신이 나타내는 구성요소가 SQLAlchemy 쿼리에 대응되는 방법을 정합니다.
- `dodotable.schema.Renderable`는 HTML로 출력될 수 있음을 나타내는
  클래스입니다. 이 클래스의 서브 클래스는 `__html__`[^3]를 구현하여
  HTML로 출력될 때 어떻게 출력할 것인지 정합니다.


```python
table = table.select(offset=0, limit=10) # 내부에서 Queryable인 인스턴스들을 조합해서 쿼리를 만듭니다.
html = table.__html__() # Renderable 이므로 __html__을 호출할 수 있습니다.

print(html) # class 이름이 씌워져 있는 HTML이 출력되지만 위에 HTML 결과와 크게 다르지 않습니다.
```

이런 방식을 통해

1. 데이터베이스에서 필요한 데이터를 가지고 온 후
2. 어떻게 출력할 것인지

에 대하여 기존에 작성된 HTML과 비슷한 형태로 코드를 작성할 수 있게 합니다.
그렇다고 해도 여전히 쿼리 문자열과 같은 정보에서 필요한 조건 등을 해석하는
부분이 해결되지 않는데, `dodotable.condition` 모듈이 그런 부분을 채워줍니다.
간단하게 위 예제에서 `이름`으로 정렬하는 기능을 넣어보겠습니다.

```python
from dodotable.condition import Order


table = Table(
    Music,
    columns=[
        Column('id', label='음악 ID'),
        Column('name', label='이름',
               order_by=Order(Music, 'name', 'name.desc')),
    ],
    sqlalchemy_session=session
)
```

이렇게 정렬 이외에도, 검색(`Ilike`), 필터(`SelectFilter`) 등을 제공합니다.


### URL 과 도도 테이블 연결하기

위에 짜여진 예제를 도도 테이블과 [Flask][]를 엮어서 사용하면 웹에서 쉽게
도도 테이블로 만들어진 HTML 파일을 서빙할 수 있습니다.
[`flask.request`][flask-request]와 도도 테이블을 엮어서 HTTP 요청 안에
포함되어 있는 조건들을 어떤 식으로 사용하는지 보려고 합니다.

위 예제에서 보인 `Table.select`의 인자라든가, `Order`의 인자는 사실 HTTP 요청의
조건들을 쿼리에 적용하기 위해 만들어진 인자입니다. 위에 예제를 가상의
Flask 애플리케이션과 함께 작성해보겠습니다.

```python
#!/usr/bin/env python3
from dodotable.schema import Table, Column
from dodotable.condition import Order
from flask import Flask, Response, render_template, request

from .entities import Music
from .orm import session

app = Flask(__name__)


@app.route('/songs', methods=['GET'])
def find_songs() -> Response:
    order_music = Order(Music, 'name', request.args.get('order_by_name'))
    table = Table(
        Music,
        columns=[
            Column('id', label='음악 ID'),
            Column('name', label='이름', order_by=order_music),
        ],
        sqlalchemy_session=session
    )
    return render_template(
        'songs.html',
        table=table.select(
            offset=request.args.get('offset', 0),
            limit=request.args.get('limit', 10)
        )
    )
```

이런 식으로 `flask.request`와 같이 사용하게 되면, URL은
`/songs?offset=0&limit=10&order_by_name=desc` 와 비슷한 모습이 됩니다.
그렇기 때문에 조건이 바뀔 때마다 URL을 바꿔줄 수 있고 URL로 부터 원하는
자료의 위치를 바로 찾을 수 있습니다.


## 마무리

도도 테이블은 사내에서도 많이 사용하고 있지만,
사용하면서 많은 문제에 부딪히고 있고 아직 발전 가능성이 많은 프로젝트라고
생각합니다. 도도 테이블은 [오픈 소스 프로젝트][dodotable-pypi]인만큼 누구나
같이 만들어가는 소프트웨어가 되면 좋겠습니다.


[SQLAlchemy]: https://www.sqlalchemy.org/
[dodotable]: https://github.com/spoqa/dodotable
[dodotable-pypi]: https://pypi.python.org/pypi/dodotable
[dodo-insight]: https://dodoinsight.com/
[spoqa-sp]: http://www.spoqa.com/enabler/
[spoqa-pc]: http://www.spoqa.com/enabler/
[CRM]: https://en.wikipedia.org/wiki/Customer_relationship_management
[datatable]: https://datatables.net/
[dodotable-readme]: https://github.com/spoqa/dodotable/blob/master/README.rst
[Flask]: http://flask.pocoo.org/
[flask-request]: http://flask.pocoo.org/docs/0.12/api/#flask.request
[^1]: [history.pushState][push-state]를 이용해서 조작할 수는 있겠지만 그런 기능을 구현하진않았습니다.
[^2]: http://dodotable.readthedocs.io/en/latest/dodotable/environment.html 에서 좀 더 자세한 설명을 읽으실 수 있습니다.
[^3]: Python에서 HTML을 다루는 라이브러리들은 사실상 표준으로 `__html__` 메소드를 구현합니다. 도도 테이블에서 사용하고 있는 엔진인 Jinja도 `__html__`이 구현되어있다면 `__html__`을 호출하는 식으로 동작합니다.
[push-state]: https://developer.mozilla.org/en-US/docs/Web/API/History_API
