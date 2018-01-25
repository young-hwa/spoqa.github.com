---
layout: entry
title: 변화하는 웹 플랫폼 따라가기
author: 최종찬
author-email: chan@spoqa.com
description: 웹 플랫폼의 변화를 따라가는데 도움이 되는 링크들을 소개합니다.
publish: true
---

플랫폼이 어떻게 변화해가는지를 살펴보면,
직접 경험해보지 않더라도 사람들의 문제의식이 어디에 있는지,
어떤 문제들이 언제부터 풀리게 되는지를 파악할 수 있습니다.

이 글에서는 이런 변화들을 살펴볼 수 있는 몇가지 유용한 링크들을 소개하려고 합니다.


## 어떤 논의들이 어디서 오가고 있을까

### WICG discourse

<https://discourse.wicg.io/>

WICG는 웹 인큐베이터 커뮤니티 그룹이라고 해서,
웹 표준에 기여해본 사람이 아니라도
토론을 통해 아이디어를 발전시켜서 사람들이 실제로 겪는 문제를
W3C 표준까지 끌어올리는 것을 목표로 하는 커뮤니티입니다.

이 곳에서는 주로 CSS, DOM API에 대한 아이디어가 올라옵니다.

### ES-Discuss

<https://esdiscuss.org/>

ES-Discuss는 WICG와 비슷하게 ECMAScript 스펙에 대해서 논의하는 메일링 리스트입니다.
위 링크는 메일링 리스트에서 오간 이야기를 쉽게 조회할 수 있도록 아카이빙 해놓은 사이트입니다.


## 논의된 아이디어는 어디서 표준으로 다듬어지고 있을까

- HTML: <https://github.com/w3c/html> 또는 <https://github.com/whatwg/html>
- CSS: <https://github.com/w3c/csswg-drafts>
- JS: <https://github.com/tc39/ecma262>

HTML은 W3C의 WebPlat WG와 WHATWG에서, CSS는 W3C의 CSSWG에서, JS는 ECMA의 TC39에서 표준을 이끌고 있습니다.

위 저장소들에 공개된 초안은 표준이 되기까지 여러 단계를 거치게 되는데, <del>여기서 다루지는 않겠습니다.</del>
(2018-01-25 수정) 이에 대한 내용은 다음의 블로그 포스트에서 자세히 설명하고 있습니다.

- [W3C 표준화 제정 단계](http://wit.nts-corp.com/2013/10/16/280)
- [ECMAScript와 TC39](http://ahnheejong.name/articles/ecmascript-tc39/)


## 다듬어진 표준은 어떤 브라우저에서 얼마나 구현되고 있을까

다음의 링크에서 각 주제에 대해 브라우저들이 현재 어디까지 구현을 했는지 파악할 수 있습니다.

- Chrome: <https://www.chromestatus.com/features>
- Firefox: <https://platform-status.mozilla.org/>
- Edge: <https://developer.microsoft.com/en-us/microsoft-edge/platform/status/>
- Safari: <https://webkit.org/status/>

크롬 플랫폼 사이트의 경우 각 주제들이 어떤 버전에 반영되었는지 같이 확인할 수 있어서 편리합니다.

나머지 브라우저들의 버전별 구현 상태는 <https://caniuse.com/>에서 주제를 검색하여 참고할 수 있습니다.


## 구현된 기능들은 언제부터 사용할 수 있었고, 언제부터 사용할 수 있게 될까

크롬과 파이어폭스는 릴리즈 캘린더를 공개적으로 관리하고 있습니다. 위에서 확인한 기능들을 담고있는 안정 버전이 언제쯤 릴리즈 될 지 다음의 링크를 보고 대략적으로 예상할 수 있습니다.

- Chrome: <https://www.chromium.org/developers/calendar>
- Firefox: <https://wiki.mozilla.org/RapidRelease/Calendar>

### 크롬과 관련된 플랫폼 따라가기

특정 크롬 버전이 어떤 V8 버전을 사용하고 있는지는 <https://omahaproxy.appspot.com/>에서 확인할 수 있습니다.

#### Node.js

Node.js의 릴리즈 스케쥴은 <https://github.com/nodejs/Release>에서 확인할 수 있습니다.

어떤 Node.js 버전이 어떤 V8 버전을 사용하고 있는지는 <https://nodejs.org/en/download/releases/>에서 확인할 수 있습니다.

#### Electron

<https://electronjs.org/>에서 일렉트론 최신버전이 어떤 노드, 크로미움, V8 버전을 사용하고 있는지 확인할 수 있습니다.

일렉트론의 크로미움 팔로업은 깃헙 일렉트론 저장소의 Projects에서 확인할 수 있습니다: <https://github.com/electron/electron/projects>


## 따라가는데 도움이 되는 블로그

브라우저 벤더들이 직접 운영하는 블로그를 구독하면 웹 플랫폼의 소식을 가장 빠르게 접할 수 있습니다.

- Chrome
    - Chromium Blog: <https://blog.chromium.org/>
    - V8 Blog: <https://v8project.blogspot.kr/>
- Firefox
    - Mozilla Hacks: <https://hacks.mozilla.org/>
- Safari
    - WebKit Blog: <https://webkit.org/blog/>
- Edge
    - Microsoft Edge Dev Blog: <https://blogs.windows.com/msedgedev/>


> (2018-01-25 수정): @SaschaNaz님 제보로 Webkit status 사이트와 Edge 블로그 추가
