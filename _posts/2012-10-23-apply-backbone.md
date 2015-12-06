---
layout: entry
title: Backbone 적용기
author: akaz
author-email: akaz@spoqa.com
description: 새 판올림을 준비하며 프로젝트에 자바스크립트 MVC 프레임워크인 Backbone을 도입해보았습니다. 그에 따르는 장점을 살펴보고, 간단한 예제를 통해 Backbone에 대하여 알아봅니다.
---

![Backbone-logo](http://backbonejs.org/docs/images/backbone.png)

## Backbone이란?

[Backbone](http://backbonejs.org/)은 자바스크립트 프레임워크로 [MVC 패턴](http://ko.wikipedia.org/wiki/MVC_%ED%8C%A8%ED%84%B4)을 적용하여 웹 애플리케이션 개발할 수 있도록 돕는 유용한 프레임워크입니다. MVC 패턴에 대해서는 밑에 더 자세히 설명하기로 하고 간단히 Backbone을 적용한 후의 장점을 소개하면 깔끔하게 뷰와 로직을 분리할 수 있어 코드를 유지 보수하는데 드는 시간이 줄며 기능 수정 혹은 기능 확장이 쉬워진다는 점등을 들 수 있습니다. 

또한, Backbone에서는 [Underscore](http://documentcloud.github.com/underscore/) 라이브러리를 사용하는데, 이 라이브러리에서 제공하는 템플레이트 기능을 통해 뷰의 재사용과 설계를 쉽게 할 수 있다는 점도 장점입니다.

만약 서버 측에서 [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer)한 URL을 제공한다면, Backbone을 사용하여 얻을 수 있는 이점이 더 확실해집니다. [모델에 RESTful한 URL을 제공](http://backbonejs.org/#Model-url)하면, [간단하게 서버와 동기화하면서](http://backbonejs.org/#Sync) 그에 따르는 뷰의 변화 따위를 손쉽게 구현할 수 있습니다. 

RESTful한 인터페이스 설계에 대해서 궁금하시다면 이전에 올라온 [글](https://spoqa.github.io/2012/02/27/rest-introduction.html)을 참조해보세요. Backbone 기반으로 설계된 [여러 웹 애플리케이션](http://backbonejs.org/#examples) 중에는 여러분이 잘 알고 있을만한 서비스들도 있을 것입니다.

## MVC 패턴?

이미 MVC라는 용어에 익숙하신 분들도 많겠지만, 생소하신 분들을 위하여 간단히 정리해보면 MVC 패턴은 [디자인 패턴](http://ko.wikipedia.org/wiki/%EB%94%94%EC%9E%90%EC%9D%B8_%ED%8C%A8%ED%84%B4) 중의 하나로 모델(실제 쓰일 데이터)과 모델을 보여줄 뷰(인터페이스) 그리고 사용자로부터의 입력을 받아 모델과 뷰를 중재하는 컨트롤러로 나누어서 구현을 해나가는 방식을 말합니다. [GoF 책](http://www.yes24.com/24/goods/2594543?scode=032&OzSrank=12)에도 이 패턴이 소개되어 있지요. 

모델은 뷰나 컨트롤러와 무관하게 작성되는데 그런 모델을 뷰가 [관찰](http://ko.wikipedia.org/wiki/%EC%98%B5%EC%A0%80%EB%B2%84_%ED%8C%A8%ED%84%B4)하고 있다가 모델의 변화에 따라 적절히 뷰의 모습을 바꾸게 되므로 서로 투명하게 작동하게 됩니다. 즉 모델만 잘 설계해서 만들어주고 그에 따르는 뷰의 모습만 정의하면 그다음부터는 지저분하게 모델의 상태에 따르는 코드를 직접 처리할 필요가 없다는 장점이 있습니다.

Backbone이 MVC 패턴을 적용하기 위한 프레임워크라고 하였지만, 실제로 Backbone에서는 MVC 패턴의 변형인 MVR 패턴을 사용합니다. 컨트롤러 대신 [Router](http://backbonejs.org/#Router)가 쓰이는 형식인데, 이 [링크](http://backbonetutorials.com/what-is-a-router/)에서 Backbone의 Router에 대한 자세한 설명을 제공하고 있습니다. 하지만 Router가 컨트롤러의 역할을 대행하는 것은 아니고, 대부분의 Backbone 예제를 살펴보면 실제로 컨트롤러가 담당하는 업무들을 뷰에 이관하여 처리하는 것을 볼 수 있습니다. MV* 패턴 중에는 [MVP 패턴](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)이나 [MVA  패턴](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93adapter) 같은 MVC 패턴의 변형들이 존재합니다만 그 바탕을 이루는 Model-View의 관계는 변하지 않는 것을 볼 수 있습니다.

## Simple code snippet

간단한 예제를 통해 실제 코드 상에서 어떤 식으로 Backbone을 적용하는지 알아보겠습니다.

#### 모델

먼저 모델을 정의해야 합니다. 가령 밑의 코드에서는 사각형 모델을 정의하고 있는데요, 기본값을 지정해 줄 수 있고, 사각형 모델과 관련된 함수들을 정의해놓은 것을 볼 수 있습니다.

{% highlight javascript %}
var Shape = Backbone.Model.extend({
    defaults: { x:50, y:50, width:150, height:150, color:'black' },
    setTopLeft: function(x,y) {
        this.set({ x:x, y:y });
    },
    setDim: function(w,h) {
        this.set({ width:w, height:h });
    },
});
{% endhighlight %}

이렇게 Backbone.Model.extend 함수를 통해 모델의 청사진을 구성하게 됩니다. 이 모델을 이용하여 뷰를 구성할 수 있습니다.

#### 콜렉션

{% highlight javascript %}
Backbone.Collection.extend({ model: Shape });
{% endhighlight %}

많은 상황에서 복수의 모델을 다루게 될 일이 생깁니다. 가령, 게시판에 올라온 글들은 게시물의 집합이라고 볼 수 있겠죠. [콜렉션](http://backbonejs.org/#Collection)을 통해서 이러한 복수의 모델의 집합을 만들어낼 수 있습니다. 위의 코드에서는 앞서 소개한 Shape 모델의 콜렉션을 정의한 것을 볼 수 있습니다. 모델과 마찬가지로 콜렉션도 뷰에 바인딩할 수 있고, 콜렉션에 관련한 이벤트(change, add, remove)를 뷰과 관찰하게 할 수 있습니다. 또한, [Underscore 라이브러리에서는 콜렉션과 밀접하게 관련된 여러 함수를](http://backbonejs.org/#Collection-Underscore-Methods) 제공합니다.

#### 뷰

{% highlight javascript %}
var DocumentRow = Backbone.View.extend({
    tagName: "li",
    className: "document-row",
    initialize: function() {
        this.model.bind('change:name', this.render);
    },
    events: {
        "click .icon":          "open",
        "click .button.edit":   "openEditDialog",
        "click .button.delete": "destroy"
    },
    render: function() {
        // render or update something
    }
});
{% endhighlight %}

기본적으로 뷰에 뷰와 관련된 모델이나 콜렉션을 바인딩하게 되는데요, 이 바인딩을 통해 뷰는 모델이나 콜렉션의 상태를 관찰하고 변화를 감지하여 바인딩 시 전달한 핸들러를 통해 적절한 행동을 수행할 수 있게 됩니다. 위의 예제를 보면 모델의 name 속성 변경 시 render 함수를 호출하도록 바인딩한 것을 알 수 있습니다. 또한, 뷰에 관련한 이벤트와 그에 관련된 핸들러를 events에 정의해놓을 수 있습니다. 보통 render 함수 내에서 뷰를 구성하거나 혹은 바인딩 된 모델, 콜렉션의 변화에 따르는 뷰의 변화를 적용하게 됩니다.

뷰에 관련된 더 자세한 사항은 [뷰 문서](http://backbonejs.org/#View)를 참조하시기 바랍니다.

#### 템플레이트

{% highlight javascript %}
var compiled = _.template("hello: <%= name %>");
compiled({name : 'moe'});
=> "hello: moe"
{% endhighlight %}

Underscore에서 제공하는 [템플레이트 기능](http://documentcloud.github.com/underscore/#template)을 이용하여 문자열을 곧바로 html 요소로 만들어낼 수 있습니다. 또한, 템플레이트 내에 자바스크립트 함수 등을 삽입하는 기능도 제공합니다. 기본적으로 Underscore에서 템플레이트 기능을 제공하지만, 그 외에도 여러 라이브러리가 있습니다. 

가령 [mustache](http://mustache.github.com/)를 이용해서도 똑같은 기능을 할 수 있습니다. 필요에 따라 유연하게 템플레이트 라이브러리를 바꿀 수 있다는 점이 매력이라고 볼 수 있습니다. Backbone 공식 사이트에서도 이러한 템플레이트 라이브러리를 이용하는 것을 권장하고 있습니다.

## Ember.js

Backbone이 나름의 역사가 있는 프레임워크이기 때문에 많이 쓰이고 있지만, 그 외에도 비슷한 기능을 제공하는 프레임워크가 많습니다. 그 중의 하나인 [Ember.js](http://emberjs.com/)가 있습니다. Ember.js의 장점이라면 기본적으로 [Handlebars](http://handlebarsjs.com/)라는 템플레이트 라이브러리를 지원함과 동시에 Backbone보다 심화된 여러 기능을 제공하는 점이 있습니다. 

그러면서도 사용의 꼴이 Backbone과 비슷하므로 만약 Backbone을 사용해 본 적이 있다면 적응하기도 쉽습니다. 참고로 아래에 여러 MVC프레임워크를 소개하고 장/단점을 분석한 사이트의 링크를 달아두었는데 여타의 프레임워크보다 더 좋은 점수를 받기도 하였습니다. 

Backbone 말고 다른 MVC프레임워크를 원한다면, 특히 자체 템플레이트 라이브러리를 지원하는 프레임워크를 원한다면, Ember.js 사용을 고려해 보는 것이 어떨까요?

## 더 읽어볼 만 한 것

[An Intro to Backbone.js](http://liquidmedia.org/blog/2011/01/backbone-js-part-1/)

[Backbone.js by example](http://www.javageneration.com/?p=839)

[Backbone Tutorials](http://backbonetutorials.com/)

위의 사이트들은 제가 Backbone을 공부하면서 참고한 사이트들입니다. 영문 사이트이지만 코드만 훑어 봐도 그 의도와 얼개는 파악할 수 있을 것으로 생각합니다. Backbone 공식 사이트에서 제공하는 [튜토리얼 사이트](https://github.com/documentcloud/backbone/wiki/Tutorials%2C-blog-posts-and-example-sites)도 방문해볼 가치가 있습니다. Backbone을 이용하여 개발한 간단한 서비스의 소스코드를 공개해 놓았습니다.

[The Top 10 Javascript MVC Frameworks Reviewed](http://codebrief.com/2012/01/the-top-10-javascript-mvc-frameworks-reviewed/)

[Journey Through The JavaScript MVC Jungle](http://coding.smashingmagazine.com/2012/07/27/journey-through-the-javascript-mvc-jungle/)

위 두 사이트에서는 앞서서 소개한 Backbone과 Ember.js 외의 여러 MV*패턴 프레임워크를 소개하고 장단점에 대하여 분석해놓았습니다.

## 마치며

이상으로 Backbone 도입과 그에 따르는 장점을 살펴보았습니다. 일반적인 홈페이지와 제작과는 약간 양상이 다른 웹플리케이션(웹 + 애플리케이션)개발자 분들은 프로젝트에 MVC 패턴 프레임워크를 적용해 보면 어떨까 하는 생각이 듭니다. 프로젝트의 생산성에 크게 이바지할 수 있으리라 생각됩니다.
