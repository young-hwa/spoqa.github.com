---
layout: entry
title: 아에이오우 튜토리얼
author: 최종찬
author-email: chan@spoqa.com
description: 다국어 스크립트 라이브러리인 아에이오우(aeiou)를 만들게 된 간단한 배경과 사용법에 대해서 알아봅니다.
publish: true
---

이 글에서는 스포카 프론트엔드 프로젝트에서 사용하는 다국어 스크립트 라이브러리인
[아에이오우(aeiou)](https://github.com/spoqa/aeiou)를 만들게 된 간단한 배경과 이 스크립트의 사용법에 대해서 알아봅니다.

## 배경
도도 포인트는 2017년 현재 한국과 일본에서 서비스되고 있으므로
점주와 엔드유저에게 노출되는 프론트엔드 코드는 일본어에 대한 고려가 돼있어야 합니다.

예전부터 도도 포인트 프론트엔드 코드는 파이썬의 [babel](http://babel.pocoo.org/en/latest/index.html)
라이브러리가 제공하는 자바스크립트 extract 기능을 활용하여 다국어를 지원하고 있었습니다.

2016년 중순에 프론트엔드 저장소가 백엔드 저장소와 분리되면서 파이썬(babel) 의존성을 제거하기 위해
gettext 호출을 긁는 스크립트를 자바스크립트로 작성하게 되었는데요.

최근 다국어 지원이 필요한 프론트엔드 프로젝트가 늘어나면서 코드 중복을 줄이고자 라이브러리로 분리하게 되어
README에 링크도 추가할 겸 튜토리얼을 작성하게 됐습니다.

## gettext
아에이오우는 [gettext 번역 시스템](https://en.wikipedia.org/wiki/Gettext)에 기반하여 만들어져있습니다.

gettext 번역 시스템은 간단히 말해서 아래의 예시와 같이 생긴 코드를 실행할 때:

```js
console.log(gettext('안녕하세요'));
```

한국어 [로케일](https://ko.wikipedia.org/wiki/%EB%A1%9C%EC%BC%80%EC%9D%BC)에서는
'안녕하세요'가 출력되고, 일본어 로케일에서는 'こんにちは'가 출력되도록 만들어주는 시스템입니다.

### 메시지 카탈로그
`gettext`는 본래의 문장(안녕하세요)과 번역된 문장(こんにちは) 짝의 목록을 담고있는 메시지 카탈로그를 필요로 합니다.
아스키 포맷으로 `.po`, 바이너리 포맷은 `.mo` 확장자를 갖는 파일이며,
메시지 카탈로그 파일은 로케일 단위(`ko_KR.po`, `ja.po`, ...)로 존재합니다.

이러한 파일들은 전부 손으로 직접 작성할 수도 있겠지만, 보통은

1. 소스코드에서 `gettext` 호출을 추출하는 도구(예: 아에이오우)를 사용해서
2. `.pot` 확장자를 가지는 PO 템플릿 파일을 생성하고,
3. 생성된 템플릿 파일을 로케일별로 복사해서 번역 문장을 채우는 방식으로 작업합니다.

템플릿 파일은 확장자가 `.pot`이지만, `.po` 파일과 다른 점은 번역문이 전부 비어있다는 것뿐이고, 포맷은 `.po` 파일과 완전히 동일합니다.

### 런타임
`gettext` 함수를 포함해서 카탈로그 파일을 파싱하는 등의 작업은 애플리케이션 런타임에 이루어집니다.

아직은 아에이오우에 런타임을 만들어놓지 않아서 `gettext` 런타임을 제공하는 라이브러리가 따로 필요합니다.
이 튜토리얼에서는 [jed](https://github.com/messageformat/Jed)를 사용하겠습니다.

## [transifex](https://www.transifex.com/)
transifex는 gettext 기반의 웹 기반 번역 UI를 제공하는 서비스입니다. (유료입니다. 15일의 무료체험 기간을 제공합니다)
아에이오우는 transifex로 PO 템플릿 파일을 올리고, transifex에서 PO 파일을 내려받는 기능을 제공합니다.

## 내 프로젝트에 아에이오우 끼얹기

### 1. aeiou, jed 설치
`aeiou`, `jed`, `jed-gettext-parser`를 설치합니다.

```sh
$ npm install aeiou jed jed-gettext-parser
```

### 2. `gettext`를 호출하는 코드 작성 및 번역어 추출

`src/example.js` 파일을 만들고 아래와 같이 코드를 작성합니다:

```js
import { Jed } from 'jed';
import { mo } from 'jed-gettext-parser';

(async () => {
    const jaCatalog = mo.parse(
        await fetch('./translations/ja.mo').then(res => res.arrayBuffer())
    );
    const jed = new Jed({ locale_data: jaCatalog });
    const gettext = message => jed.gettext(message);

    // aeiou는 다음과 같은 `gettext` 함수 호출을 인식합니다.
    const sayHello = name => console.log(gettext('안녕하세요 %s'), name);

    // 들여쓰기 단계가 깊어도 상관없습니다.
    function sayHi(name) {
        // `jed.gettext('번역어')` 꼴의 호출은 aeiou가 인식하지 못합니다.
        console.log(/* jed. */gettext('안녕 %s야'), name);
    }

    sayHello(gettext('선생님')); // こんにちは先生
    sayHi(gettext('친구')); // こんにちは友よ
})();
```

웹팩으로 빌드합니다:

```sh
$ webpack src/example.js dist/example.js
```

다음의 명령문을 실행하여 `messages.pot` 파일을 만들어둡니다:

```sh
$ npx aeiou extract --srcDir="./src" --outDir="./dist/translations"

extarcting messages from example.js
writing PO template file to dist/translations/messages.pot
```

### 3. transifex 프로젝트, 리소스 구성하고 번역하기
회원가입 절차는 생략하겠습니다. organization 생성까지 진행하시면 됩니다.

1. 다음과 같은 설정으로 새 프로젝트를 생성하고
    <img src="/images/2017-09-26/1.png" style="padding: 0; border: 1px solid #e1e4e6">

2. 리소스를 만들어준 뒤
    <img src="/images/2017-09-26/2.png" style="padding: 0; border: 1px solid #e1e4e6">

3. `Translate` 버튼을 눌러 번역화면으로 들어가서 비어있는 번역어를 채워주면 됩니다.
    <img src="/images/2017-09-26/3.png" style="padding: 0; border: 1px solid #e1e4e6">

한 번 transifex 프로젝트와 리소스를 만들어놓았으면
다음부터는 새로운 문구가 추가되었을 때 아래의 명령문으로 `messages.pot` 파일을 업로드할 수 있습니다:

```sh
# 메시지가 추가되었으면 push 하기 전에 새로 extract 해주어야 합니다.
# `npx aeiou extract --srcDir="./src" --outDir="./dist/translations"`

$ npx aeiou push --id="아이디" --password="비밀번호" \
    --project="testproject-44" --resource="example" --potDir="./dist/translations"

-> PUT https://www.transifex.com/api/2/project/testproject-44/resource/example/content
<- PUT https://www.transifex.com/api/2/project/testproject-44/resource/example/content

```

### 4. PO 파일 다운로드 및 잘 돌아가는지 확인
아래의 명령문으로 transifex에서 번역 카탈로그 파일들을 다운받을 수 있습니다:

```sh
$ npx aeiou download --id="아이디" --password="비밀번호" \
    --project="testproject-44" --resource="example" --outDir="./dist/translations"

-> GET https://www.transifex.com/api/2/project/testproject-44/resource/example
<- GET https://www.transifex.com/api/2/project/testproject-44/resource/example
-> GET https://www.transifex.com/api/2/project/testproject-44/resource/example/content
<- GET https://www.transifex.com/api/2/project/testproject-44/resource/example/content
-> GET https://www.transifex.com/api/2/project/testproject-44/languages
<- GET https://www.transifex.com/api/2/project/testproject-44/languages
-> GET https://www.transifex.com/api/2/project/testproject-44/resource/example/translation/ja
<- GET https://www.transifex.com/api/2/project/testproject-44/resource/example/translation/ja
writing PO(ko_KR) file to dist/translations/ko_KR.po
writing PO(ja) file to dist/translations/ja.po

```

원하는 언어의 카탈로그 파일이 다운받아 지지 않는다면
transifex 프로젝트 웹사이트로 가서 해당 언어의 team에다가
아무 역할의 사람(예: 본인)을 1명 추가하고 다시 시도하면 됩니다.

잘 되는지 테스트 해봅시다:

```sh
$ cd dist
$ echo '<script src="example.js"></script>' > ./index.html
$ http-server -p 1234 # 없으면 `npm install -g http-server` 로 설치합니다.
# 웹브라우저로 `http://localhost:1234/` 탭을 연 뒤 자바스크립트 콘솔 창을 띄웁니다.
```

<figure>
    <img
        alt="콘솔에 잘 찍힙니다"
        src="/images/2017-09-26/done.png"
        style="margin: 0 auto; padding: 0; border: 1px solid #e1e4e6">
    <figcaption>잘 된다!</figcaption>
</figure>

### 5. 번역되지 않은 메시지 확인하기

`aeiou ensure` 명령으로 번역되지 않은 메시지를 검색할 수 있습니다.
미번역된 메시지가 있으면 exit status로 `0`이 아닌 값을 반환하므로 ci 등에 붙여서 활용할 수 있습니다:

```sh
# 메시지가 추가되었으면 ensure 하기 전에 새로 extract 해주어야 합니다.
# `npx aeiou extract --srcDir="./src" --outDir="./dist/translations"`

$ npx aeiou ensure --locale="ja" --potDir="./dist/translations"
There are 2 untranslated messages:

msgid: 인사하는 어린이
msgid: 착한 어린이
```

## 끝
여기까지 아에이오우의 모든 기능에 대한 사용법을 알아보았습니다.

아직 아에이오우는 개선할 여지가 많이 남아있는 프로젝트입니다.

`gettext` 함수를 추출하는 기능이 타입스크립트와 자바스크립트에 대해서만 구현되어있기 때문에 커피스크립트 등의 언어는 지원되지 않고 있고,
애플리케이션에서 사용할 `gettext` 런타임이 안 만들어져있어서 `jed` 등의 외부 라이브러리를 병용해야 합니다.
transifex라는 유료 서비스에 의존적인 부분도 다른 번역 서비스와 연계할 수 있는 기능을 붙이는 식으로 개선할 수 있을 겁니다.

아에이오우는 MIT 라이센스 하에 배포되는 오픈소스 프로젝트입니다. 이슈 제보, PR 환영합니다: <https://github.com/spoqa/aeiou>
