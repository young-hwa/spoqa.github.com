---
layout: entry
title: "Living on The Edge: 가장 앞에서 개발 (다시) 시작하기"
author: jay
author-email: jay@spoqa.com
description: 새로운 프론트엔드 앱 개발 환경 구축에 대한 경험을 공유합니다.
publish: true
---

안녕하세요. 저는 Spoqa 개발팀의 Jay라고 합니다. 저는 이번에 도도포인트 앱의 프론트엔드를 재작성하는 프로젝트를 진행했는데, 새로운 프론트엔드 개발 환경을 구축하고 싶으신 분들께 도움이 될까 하여 경험을 공유해봅니다.


## 도도포인트의 경우

스타트업은 유연한 조직 구조와 빠른 제품 개발 속도로 기존의 기업들을 앞지를 수 있습니다. 스포카는 도도포인트라는 서비스를 운영하는 스타트업으로서, 고객들이 원하는 제품에 대한 기능들을 빠른 속도로 제공해 줄 수 있어야 하며, 또한 서비스는 안정적이어야 합니다.

도도포인트 서비스는 빠른 개발 속도를 만족시키기 위해 HTML5 기반의 SPA(Single Page Application) 구조를 가지고 있습니다. 간단히 말하자면, 웹앱 서비스라고 볼 수 있습니다. 기존 앱은 [Backbone](http://backbonejs.org/) 등의 라이브러리들을 이용해 작성되어 있었습니다.

Backbone은 현장에서 충분히 많이 사용하므로, 검증된 라이브러리라 할 수 있습니다. 소위 말하는 battle-tested lib인 것입니다. 하지만 많은 사람들이 사용하는 것이 문제를 자연히 해결해 주지는 않습니다. 수년간의 개발 진행 후 도도포인트 앱은 더이상 scale up이 버거울 정도로 커졌습니다.


## 기존 앱을 수선할 것인가, 재작성할 것인가

너무 자세하게 이야기하면 주제가 바뀔 수 있는 바, 스포카 개발팀이 겪고 있었던 문제를 간단하게 이야기하고자 합니다.

도도포인트는 빠른 개발 속도가 중요하다 보니 요구사항이 충분히 잘 정의되지 못한 상태에서 스케일업을 할 때가 많았습니다. 그러다보니 자연히 모듈과 함수들의 정의 또한 잘 정의되지 못하고, 재사용성이 떨어지는 코드를 작성하게 되었습니다 (주관적인 견해이나, Backbone은 lightweight JavaScript MVC를 지향하다 보니 그에 따른 장점도 있지만 추상화가 어렵고 장황한 코드를 작성하게 되는 경향이 있다고 생각합니다. 이를 보완하는 여러가지 라이브러리들이 있긴 하지만, 도입하기에는 이미 늦은 상태였습니다). 이는 자연히 유닛 테스트의 부재 등 여러가지 이슈로 이어지게 되었습니다.

이러한 문제로 점점 개발 속도는 느려지게 되었으며 SPA 앱의 특성상 장애또한 빈번하게 발생하게 되었습니다. 이런 앱 구조에 대한 문제의식을 계속 가지고 앱을 개선해 나가던 와중, 프론트엔드를 재작성하자는 이야기가 개발팀 안에서 조금씩 나오기 시작했습니다.

개발자라면 한번쯤은 들어봤을 법한 글이지만, Joel Spolsky는 [Things You Should Never Do](http://www.joelonsoftware.com/articles/fog0000000069.html)에서 *앱을 재작성하는 것은 절대 해서는 안될 일*이라고 주장한 바가 있습니다. 그의 논지는 충분히 설득력이 있습니다. 하지만 앱을 단순히 재작성하는 것이 아닌, 더 좋은 도구들을 이용하기 위한 기반을 만드는 것이라면 어떨까요?


## 더 새로운 것은 더 좋은 것이다. 아마도

<div style="margin:auto; width: 80%; max-width: 500px;">
<blockquote class="twitter-tweet" lang="en">
<p lang="en" dir="ltr">Finally a JavaScript book from O&#39;Reilly that just speaks to me <a href="http://t.co/Eg7F91KwLb">pic.twitter.com/Eg7F91KwLb</a></p>&mdash; λ Calrissian (@mattpodwysocki) <a href="https://twitter.com/mattpodwysocki/status/598359378190819328">May 13, 2015</a>
</blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>
*모두들 좋다 카더라*


새로운 개발 환경을 만들기 위하여 서베이를 해 본 결과, [React](https://facebook.github.io/react/) [^1]를 이용해 앱을 새로 작성하는 것이 좋겠다는 결론에 이르렀습니다. 비록 한국에는 리퍼런스가 많지 않지만 해외에는 굉장히 큰 리퍼런스들을 많이 가지고 있고, React 팀의 rationale에 스포카 개발팀이 공감했기 때문이기도 합니다. 오픈 소스일 뿐만 아니라, Github로 대부분의 진행 상황을 트래킹할 수 있으며 이슈트래커와 IRC, SNS를 통해 적극적인 자세로 도와주는 React 팀의 자세도 plus가 되었습니다.

React로 개발한다는 것은 기존의 웹페이지 기반의 개발을 한다는 것과 또 다른 이야기가 될 수 있습니다. 하나의 도구를 연장에 추가한다는 것 이상의, 어떤 문화를 받아들이는 것입니다. Minified file을 웹사이트에 들어가서 다운받고, AMD 모듈 디펜던시를 일일히 추가하던 시절이 있었습니다 (기존 앱은 그렇게 개발되고 있었습니다). JavaScript의 가능성을 막 알아가던 옛날과는 달리, 이제는 Node.js compatible API로 작성된 성숙한 에셋 파이프라인을 구축할 수 있습니다. 또한 QUnit같은 라이브러리를 이용해 웹페이지를 열어 테스트를 돌려봐야만 했던 시절과는 달리 커맨드라인에서 자세한 아웃풋을 보며 테스트를 진행할 수 있습니다. 또한 가독성이 훨씬 좋은 ES2015[^2] 언어 명세를 이용해 앱을 작성할 수 있습니다.

> '하지만 이 모든 것이 너무 새롭지 않은가?'

그렇게 생각할 수도 있습니다. 하지만 오래된 것이 더 안정적인 것도 아니며, 새로운 것이 더 사용하기 어려운 것도 아닙니다. React를 처음 사용해 시험 프로젝트를 진행해본 결과, UI를 만드는 건 너무나 쉬워져서 trivial task가 되었습니다.


## React와 Flux를 만나다

(사실 React에 관한 내용을 자세히 쓰자면 너무 길어질 것 같아, 이 또한 이 글에서는 짧게 쓰도록 하겠습니다.) 위에서 React 팀의 Rationale에 대해서 이야기했는데, React 팀의 여러가지 문제 의식 중 공감한 부분들은 다음과 같습니다.

- 기존 웹앱들의 Raw DOM manipulation은 다양한 문제를 수반하므로, 추상화해서 선언적인 UI 상태 명세를 따르도록 해야 한다.
- 웹 앱 UI 작성의 문제는 상태를 관리하기가 너무 어렵다는 것으로, 상태 변화는 최소의 범위에서 이루어지도록 관리해야 한다.

기존의 도도포인트 앱은 UI의 상태 관리가 굉장히 어려운 문제 중 하나였습니다. 대부분의 UI 상태의 기술이 imperative했고, DOM 조작을 일일히 해 줌으로서 상태 변화를 일일히 관리해야 했기 때문입니다. 따라서 서버의 데이터와 다른 내용을 보여주거나 할 가능성을 최소화하기 위해서 사람들이 직접 QA를 열심히 하는 수 밖에 없었습니다. React는 이런 문제를 해결하는 굉장히 좋은 솔루션이라고 할 수 있습니다. [^3]

React는 one-way dataflow를 지향하는데, 이는 약간 코드 기술을 장황하게 만들 여지가 있습니다. 이에 대한 해결책으로 리액트 팀은 [Flux architecture](https://facebook.github.io/flux/)를 대안으로 제시하는데, Flux는 scheme일 뿐 솔루션은 아니므로 스포카 개발팀은 [Reflux](https://github.com/spoike/refluxjs)라는 구현체를 이용했습니다. Flux 구현체 중에서는 가장 성숙한 API와 사용례를 가지고 있는 라이브러리입니다 (Reflux는 ES5로 작성되었으므로 ES2015 명세를 적극적으로 도입하는 React 0.13.0^ 부터 시작하시는 분이라면 [Flummox](https://github.com/acdlite/flummox/)를 고려해 봐도 좋을 듯 합니다).


## 모듈 번들러

위에서도 기술했지만, React를 사용하면 자연히 CommonJS/ES 모듈과 [Browserify](https://github.com/substack/node-browserify), [Webpack](https://github.com/webpack/webpack)과 같은 모듈 번들러의 사용이 권장되기 마련입니다. 모듈 번들러라는 개념이 생소한 분들을 위해 설명하자면, AMD와 CommonJS와 같은 모듈 명세들을 구현한 모듈들을 이해하고 (의존성 추적) 조작, 변형하거나 하나 또는 이상의 파일로 뭉치는 작업을 하는 도구입니다. 또한 자바스크립트 모듈이 아니라 이미지나 blob 등도 encode해서 모듈 형태로 번들링해줄 수도 있습니다.

스포카 개발팀에서는 Browserify 대신 Webpack을 선택했는데, 기본적인 수준에서 필요한 기능 (예를 들자면, file watch) 별도의 모듈 확장들을 통해 확장해야 하는 Browserify와 달리 기본 기능들이 하나의 메인테이너 손으로 잘 만들어져 있기 때문입니다. 또한 플러그인과 확장들이 충분히 많이 개발되어 있다고 판단된 점, [React 메인테이너가 적극적으로 추천하는 점](https://github.com/petehunt/webpack-howto) 등도 결정에 참고가 되었습니다.

모듈 번들러의 신뢰도는 어떨까요? 사실 Webpack도 굉장히 빠른 속도로 개발되는 도구로서 때때로 문제를 일으키기도 합니다. 한번은 개발자의 테스트를 위한 코드 때문에 업그레이드 후 CI가 깨진 적이 있었는데, [굉장히 빠른 속도로 대처해줘서](https://github.com/webpack/webpack/issues/955) 좋은 인상을 받은 적이 있습니다.


## 미래를 내 손안에: ES2015

위에서 계속 ES2015 이야기를 했는데, 현재 재작성된 도도포인트의 코드는 ES2015 언어 명세를 부분적으로 사용했습니다. 기존 앱은 ES5를 굉장히 부분적으로만 사용하고 대부분의 경우 ES3 언어 명세에 맞춰 작성되어 있었는데, 사실 도도포인트는 최신의 브라우저 API를 이용할 수 있는 제한적인 플랫폼 (태블릿)에서 돌아가면 되는 SPA이므로 별로 좋은 선택은 아니었다고 볼 수 있습니다. 기존 앱과 같은 가독성 문제를 줄이기 위해서 새로 작성하는 모듈들은 `class` 등의 ES2015 언어 명세를 적극적으로 활용하기로 했습니다.

ES2015는 모든 브라우저에서 사용할 수 있는 것은 아닙니다. 그렇기 때문에 트랜스파일을 통해 ES5 언어 명세에 맞는 코드 아웃풋으로 변환해주는 것이 트랜스파일러인데, Webpack을 이용하면 [loader](http://webpack.github.io/docs/loaders.html)를 이용해 쉽게 기존 시스템에 붙일 수 있습니다. 기존에는 [react-tools](https://www.npmjs.com/package/react-tools)를 활용한 [jsx-loader](https://github.com/petehunt/jsx-loader)[^4]를 사용하다 [Babel](http://babeljs.io/), 정확히는 [babel-loader](https://github.com/babel/babel-loader) 을 이용하고 있습니다. (스포카는 [who's using Babel](http://babeljs.io/users/) 섹션에도 등록되어 있습니다!) Babel은 ES2015 기술을 먼저 이용하자는 취지의 트랜스파일러 플랫폼이긴 하나, React의 템플릿 기술 언어인 `jsx`의 파서도 구현하고 있으므로 React를 사용하는 사람들은 얼마든지 이용할 수 있습니다.

트랜스파일러의 신뢰도에 대해 의문을 가진 분들도 계실 것입니다. 트랜스파일러는 experimental한 기술인 것은 분명하며, 아웃풋또한 언제나 신뢰할 수 있는 것은 아닙니다. 개인적인 견해는, 너무 많은 부분에 의존하면 나중에 뒷통수를 맞을 가능성또한 적지 않다고 생각해서, Generator 같이 복잡한 구현은 피하는 식으로 구현이 비교적 간단한 명세 위주로 작성하고 있습니다. [^5]


## Karma와 Mocha를 이용한 고속 테스팅

이전 도도포인트 앱은 별도의 자바스크립트 유닛테스트가 존재하지 않았습니다. 유닛테스트가 있었다면 좋았겠지만, 비즈니스 로직과 뷰 로직이 충분히 잘 분리되어 있지 않았기 때문에 testability가 많이 떨어지는 관계로 유닛테스트를 할 수 없었고, 이런 상황에 대해 참고할만한 예제도 적었습니다. 하지만 React를 도입하기 시작하면서 테스트 예제들을 인터넷에서 충분히 쉽게 구할 수 있었고, 테스트 작성을 도와주는 라이브러리의 선택 가능 범위가 넓어지면서 고민에 빠지게 되었습니다.

> '어떤 것을 사용할 것인가?'

첫 후보로는 React 팀에서 추천하는 [Jest](https://facebook.github.io/jest/)가 물망에 올랐습니다. 하지만 Jest는 다음과 같은 약점이 있어 선택받지 못했습니다.

- JSDOM을 이용하여 DOM API를 simulate 한다. 하지만 브라우저와 작동이 똑같지는 않다.
- 브라우저에서 테스트를 해보는 것이 아니라 Node.js(or equivalent) 환경에서 테스트하므로 엔진이 다르다.
- Node.js 환경이므로 디버깅을 하려면 Node debugger나 node-inspector같은 별도의 도구를 이용해야 한다.
- [Jasmine](http://jasmine.github.io/)을 사용한다.

추후 알 수 없는 브라우저 quirk에 의한 문제가 발생하는 상황을 맞이하는 것보다는, 브라우저에서 직접 유닛테스트를 돌려보는 것이 낫겠다는 생각이 들어 Karma를 선택했습니다. 또한 BDD 스타일의 assertion API를 가진 Jasmine보다는 pytest처럼 `assert()` 를 선호하는 구성원들의 취향을 생각해, Mocha에 Chai.assert를 붙여서 사용하기로 했습니다. 결과적으로 React 컴포넌트에 대한 테스트 케이스는 다음과 같은 모양이 됩니다. [^6]

```javascript
// test-component.spec.jsx
import React from 'react/addons';
import {assert} from 'chai';

import TestComponent from '../../components/test-component.jsx';

var TestUtils = React.addons.TestUtils;

describe('Test Component', () => {

    it('should be initialized correctly with given props', () => {

        var props = { a: 1, b: 2 };
        var test = TestUtils.renderIntoDocument(<TestComponent {...props} />);

        assert.equal(instance.state.a, props.a);
        assert.equal(instance.state.b, props.b);

    });
});
```

그 외에 [rewire](https://github.com/jhnns/rewire), [sinon.js](http://sinonjs.org/) 같은 테스트 헬퍼 라이브러리들도 유용하게 사용하고 있습니다. Sinon은 기능이 꽤 많은데 주로 많이 사용하는 기능은 `sinon.spy`, `sinon.stub`, `sinon.fakeServer`입니다. fakeServer는 약간 사용이 까다롭습니다만 [^7], 꽤 복잡한 의존성 주입을 하지 않는 한 테스트하기 힘든 비동기 Ajax 요청을 하는 함수 등을 테스트할 때 요긴하게 사용합니다.


## Always Check Your Radar

여기까지 전체적인 새 앱의 overview를 해 보았습니다. 새 도도포인트 앱은 이제 정말 새로운 기술로 가득합니다. 하지만 누군가는 그렇게 새로운 기술들을 사용해도 괜찮을지 질문할 수도 있습니다. 언제 메인테이너가 변덕으로 메인테이닝을 중단할 지 모르는 오픈소스들에 의존하는 것도 아슬아슬한데, 몇년 되지도 않은 라이브러리와 도구들을 잔뜩 도입한다는 것은 위험한 선택처럼 보일 지도 모릅니다.

하지만 Github와 Node.js 생태계의 <del>hype</del>활력을 무시할 수는 없습니다. 누구나 만들기 쉽고, 누구나 자신의 작업을 올리기 쉬운 환경이 존재하는 한 활력은 계속될 것이라고 봅니다. 지금보다 언젠가 더 나은 라이브러리가 나올 수 있고, 그렇다면 그걸 쓸 수도 있을 것입니다. 더이상 뭔가가 나올 필요가 없을 것 같아 보이는 JavaScript MVC의 세계에서도 발전은 계속되고 있습니다. [^8]

어쨌든, 문제가 발생하면 어떻게 할까요?

충분히 경험을 가진 개발자 여러분들은 이미 잘 아실 테지만, 문제를 해결하는 방법은 여러가지가 있습니다. 그리고 어떤 문제들은 굉장히 쉽게 해결되는 반면, 어떤 문제는 많은 시간과 비용을 요구하기도 합니다. 어떤 문제는 입도에서 발생하기도 하며, 어떤 문제는 끝단에서 발생하기도 합니다. 충분히 테스트된 것 같은 제품도 버그를 가지고 있기 마련입니다.

예를 들자면 현재 도도포인트의 유닛테스트를 작성하는 과정에서 위에서 언급했던 [Rewire에 관련된 문제](https://github.com/jhnns/rewire-webpack/issues/12)를 겪었는데, 이것을 [디버깅하는 것](https://github.com/jhnns/rewire-webpack/issues/12#issuecomment-95797024)은 상당히 어려운 일이었습니다. 왜냐하면 Webpack과 Babel과 Rewire 세개의 프로덕트에 걸친 문제를 가지고 있기 때문입니다. 문제는 한 곳에서만 발생하지 않을 수도 있으므로, 전체 인프라가 어떤 식으로 작동하는지 충분히 알고 있어야 (혹은 디버깅을 하면서 파악) 할 필요가 있습니다. 그래야 Duct-tape solution이든 long-term solution이든 내놓을 수 있기 때문입니다. :)


## 마치며

이상으로 간단하게 새롭게 작성한 도도포인트 앱의 구조와 개발환경에 대해 알아봤습니다. 다음 글은 좀 더 코드가 많은 글이 되었으면 좋겠네요. 이 자리를 빌어 여러가지 문제로 일정이 지연됨에도 감내해주시고 고생해주신 포인트 팀과 CTO님께 감사 말씀을 드립니다. ;)


[^1]: 저는 발만 담구긴 했지만 [React 한국어 문서 번역](http://reactkr.github.io/react/docs/getting-started-ko-KR.html)도 존재합니다.

[^2]: 보통 EcmaScript, 소위 사람들이 자바스크립트라고 부르는 구현체의 다음 버젼 언어 명세는 EcmaScript 6, 즉 ES6으로 지칭되어 왔습니다만 ES7 등 다음 버젼의 명세 작업에 TC39가 착수하면서 ES2015라고 부르자는 [커뮤니티의 합의](https://esdiscuss.org/topic/javascript-2015)가 있었습니다. 이 글에서는 일단 "ECMA-262, 6th Edition"과 기타 미래의 언어 명세와 제안을 ES2015로 지칭합니다.

[^3]: 해외에는 좋은 튜토리얼과 블로그 글이 많이 있지만 국내에는 거의 없는 편인데, ditto님의 [jQuery to React](https://dittos.github.io/2014/08/10/jquery-to-react/)의 일독을 권해봅니다.

[^4]: 최근에는 react-tools가 deprecate된 관계로 jstransform을 사용하긴 합니다.

[^5]: [kangax의 EcmaScript 지원 차트](http://kangax.github.io/compat-table/es6/)를 보면 Babel은 굉장히 많은 언어 명세를 지원하는데, 부분적으로는 [core-js](https://github.com/zloirock/core-js) 폴리필을 이용하는 것까지 포함합니다. 유닛테스트의 커버리지와 지원을 보면 신뢰할 수 있는 프로젝트지만, 엄밀히 말하자면 폴리필의 정상 작동 여부는 브라우저 런타임에서만 알 수 있으므로 조심해서 사용하는 것이 좋다고 생각합니다.

[^6]: Arrow Function은 lexical binding을 위한 것이지 짧은 함수 표기를 위한 것이 아니라는 [주장](https://github.com/getify/You-Dont-Know-JS/blob/32efc1e7e8122696ecc66dfa70cbf78e882c9301/es6%20%26%20beyond/ch2.md#arrow-functions)도 있으며 공감합니다만, 예시를 위해 사용해 봤습니다.

[^7]: 비동기 함수 사용의 어려운 부분이라고 하는 게 더 맞을 지도 모르겠습니다만, 어쨌든 fakeServer 인스턴스가 이해할 수 있는 타임프레임에 예측한 테스트 요청이 가지 않았을 경우 에러를 내는 것이 아니라 404를 반환해서 약간 어리둥절하게 하는 behavior가 있습니다.

[^8]: [Ember.js](http://emberjs.com/)에 React에 영향을 받은 Virtual DOM 구현체인 [Glimmer 렌더링 엔진이 들어간 것](http://emberjs.com/blog/2015/05/13/ember-1-12-released.html)이 하나의 예라고 볼 수 있습니다.
