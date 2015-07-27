---
layout: entry
title: 도도에서는 반응형 웹을 어떻게 만들었을까?
author: Jacob(이성운)
author-email: jacob@spoqa.com
description: viewport, media query, jQuery를 이용하여 responsive web을 만들어 보겠습니다.
publish: true
---

안녕하세요 **스포카 개발팀 인턴**으로 합류한 **Jacob(이성운)**입니다. 이번에 도도(스포카) 랜딩페이지가 새로운 디자인으로 업데이트되면서 랜딩페이지 제작을 직접 맡게 되었습니다. 이번 랜딩페이지 제작에서 꽤 비중을 차지했던 요소가 **다양한 사이즈의 스크린을 지원**하는 부분이었습니다.

웹 페이지에 접속하는 장비나 브라우저에 구애받지 않고 최적화된 모습을 보여주기 위해서는 어떻게 해야 할까요? 그 방법들은 정말 다양하게 존재합니다만 그 중 가장 대표적이고 편리한 **뷰포트(viewport)**, **미디어 쿼리(media query)**, **유저 에이전트를 감지하는 jQuery**에 대해 소개해 드리겠습니다.

### 다양한 스크린에서 최적화된 뷰(view)를 만들어주는 기술들

#### 뷰포트(viewport)
간단하게 이야기하면 웹 페이지에서 눈에 보이는 영역을 말합니다. 데스크탑과 모바일의 뷰포트는 약간의 차이가 있는데, 모바일 브라우저는 윈도우의 리사이즈가 불가능하고 데스크탑 브라우저에서 이용하지 않는 터치를 이용하는 등의 특성 때문에 데스크탑 브라우저와는 구성 및 형태가 약간 다릅니다. 또한, 모바일의 스크린 크기가 데스크탑의 스크린 크기보다 월등히 작으므로 모바일 전용으로 제작되지 않은 웹페이지는 모바일에서 볼때 화면이 전체적으로 축소되는 것을 자주 목격할 수 있습니다. 때문에 뷰포트를 이용하여 모바일의 특성과 모바일의 화면 크기 등을 고려해야만 모바일 사용자에게 최적화된 웹 페이지를 선사할 수 있습니다.

기본적으로 뷰포트의 설정방법은 다음과 같습니다.

``<meta name = "viewport" content = "value1, value2, …" />``

뷰포트의 속성 및 더 자세한 내용은 [이곳](http://developer.apple.com/library/safari/#documentation/AppleApplications/Reference/SafariHTMLRef/Articles/MetaTags.html "viewport properties")을 참고하시면 되겠습니다.


#### 미디어 쿼리(media query) 
미디어 쿼리란 CSS2.1의 미디어 타입(media type)을 기반으로 한 CSS3 기능이고, 이를 이용하면 구체적인 조건을 지정하여 각기 다른 디바이스에 다른 스타일 시트를 적용할 수 있을 뿐만 아니라 각 사용자들에게 필요한 스타일의 웹 페이지를 제공할 수 있습니다. 예를 들면 screen의 폰트 크기와 print의 폰트 크기는 대게 달라야만 하는데 그 이유는 종이로 출력되는 폰트 크기보다 스크린의 폰트 크기가 더 커야만 사용자가 스크린의 컨텐츠를 보기 편하기 때문입니다. 이러한 문제는 미디어 쿼리를 이용하면 아주 간단하게 해결할 수 있습니다.

미디어 쿼리를 설정하는 방법은 여러 가지가 있으며 대표적으로 다음과 같은 방법을 이용합니다.

``<link rel="stylesheet" media="value" herf="path" />``

미디어 쿼리의 속성 및 더 자세한 내용은 [이곳](http://www.w3.org/TR/css3-mediaqueries/ "media query")을 참고하시면 되겠습니다.


### 뷰포트와 미디어 쿼리, jQuery.browser를 이용한 예제

우선, Code 1-1처럼 전체적인 html 페이지를 구성합니다. 편의를 위해 내용은 복사, 붙여 넣기를 이용합니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-1.html"></script> 
 
(좌)그림 1-1 / (우)그림 1-2 ![그림 1-1](/images/responsive-web/image_1-1~2.png) 

Code 1-1의 html은 h1태그,  p태그, img태그로 한 페이지가 구성되어 있고, 흰 코뿔소에 관한 내용을 예제로 담았습니다. 현재의 상태에서는 작성한 내용 그대로를 담고 있는 페이지를 볼 수 있습니다. 모바일에서 보게 될 경우 그림 1-1과 같이 웹킷 뷰포트의 기본 속성값이 적용되어 전체적으로 축소된 페이지를 볼 수 있습니다. 그림 1-2는 뷰포트의 기본 속성값이 적용된 도도의 랜딩페이지 모습입니다.

* 뷰포트의 기본 속성값 - width : 980px, height : 자동 결정, initial-scale : 자동 결정, minimum-scale : 0.25, maximum-scale : 1.6, user-scalable : yes 


<script src="https://gist.github.com/3347225.js?file=Code 1-2.html"></script> 
 
그림 1-3. ![그림 1-3](/images/responsive-web/image_1-3.png)
 
이제 모바일에서 더 최적화된 페이지를 보기 위해 뷰포트를 추가해보겠습니다. Code 1-2처럼 head영역 내에 meta태그를 추가합니다. width는 디바이스의 가로 사이즈를 감지하여 그 사이즈를 따르도록 하고, initial-scale 값은 1.0, user-scalable은 불가능하도록 설정하였습니다. 그림 1-3은 필요한 뷰포트 속성을 적용한 아이폰에서의 도도 랜딩페이지 모습입니다. 하지만 Code 1-2에서 작성한 웹 페이지는 코뿔소의 이미지의 사이즈가 스크린의 사이즈를 초과하여 가로로 스크롤이 생기게 됩니다. 이는 **이미지가 고정된 사이즈를** 가지고 있기 때문입니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-3.html"></script> 
 
그림 1-4. ![그림 1-4](/images/responsive-web/image_1-4.png)

이미지 사이즈를 상대적으로 설정해주기 위해 Code 1-3처럼 img태그 내에 Width=100% 속성을 추가합니다. 이렇게 하게 되면 이미지가 기본사이즈가 아닌 디바이스의 가로 사이즈를 따르게 되면서 웹 페이지가 모든 디바이스 스크린에 딱 맞게 보입니다. (그림 1-4) 때문에 모바일 뷰를 염두에 두고 페이지를 제작하신다면 각 요소의 고정된 사이즈에 유의하셔야 합니다. 물론 이미지의 사이즈는 그대로 유지하고 축소된 화면을 보여 줄 수도 있습니다. 

다음으로 미디어쿼리를 이용하여 스크린의 크기에 따라 CSS가 변화하는 페이지를 만들어보도록 하겠습니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-4.html"></script> 
 
그림 1-5. ![그림 1-5](/images/responsive-web/image_1-5.png)
 
그림 1-6. ![그림 1-6](/images/responsive-web/image_1-6.png)
 
Code 1-4에서는 스크린의 최소, 최대 사이즈에 따라 CSS가 변화하도록 설정하였습니다. 그림 1-5를 보면 스크린의 가로 사이즈가 640px 이하로 떨어질 때 body의 배경색이 변화하고, 1080px을 넘어설 때 body의 배경색이 다시 변화하는 것을 볼 수 있습니다. 구체적인 조건에 따라 변화하는 미디어 쿼리의 기본 특성을 이용하면 스크린의 크기에 따라 사라지고 나타나는 요소를 만들어 낼 수도 있습니다. 그림 1-6은 이를 활용한 도도의 랜딩페이지 입니다. 스크린의 가로 사이즈가 640px 이하로 떨어지면 페이지의 요소와 구성이 바뀝니다. 단순하고 쉽게 사용할 수 있는 미디어 쿼리, 하지만 미디어 쿼리는 모바일과 데스크탑을 정확하게 구분할 수 없고, CSS만 변화시킬 수 있다는 한계점(CSS의 기능이기 때문에 어떻게 보면 숙명입니다)을 가지고 있습니다. 그래서 우리는 기능적인 부분을 변화시키기 위해서는 javascript 또는 jQuery를 이용해야 합니다. 이번에는 jQuery.Browser를 먼저 보겠습니다.

다음으로 jQuery.Browser를 이용하여 사용자가 사용하는 브라우저 종류 및 버전에 따라 그에 대응할 수 있는 웹 페이지를 만들어보도록 하겠습니다. Code 1-5와 같이 jQuery CDN 호스트를 사용하여 jQuery를 이용합니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-5.html"></script> 
 
 
jQuery.browser는 기본적으로 webkit, safari, opera, msie, mozilla를 지원합니다. 그렇다는 말은 해당하는 브라우저와 몇몇 버전들을 감지할 수 있다는 얘기입니다. 아쉽게도 이름 그대로 사용자의 플랫폼(Operation System)은 구분해내지 못합니다. 때문에 jQuery.extend를 이용하여 iOS, Windows Phone, 안드로이드를 구분할 수 있도록 jQuery.browser의 기능을 확장해보도록 하겠습니다. 

<script src="https://gist.github.com/3347225.js?file=Code 1-6.html"></script> 
 
 
Code 1-6은 브라우저의 전반적인 정보를 제공하는 navigator 객체를 이용하여 사용자의 접속 환경을 알아냅니다. 이렇게 jQuery.browser의 기능을 확장하고 나면 비로소 iOS, Windows Phone, 안드로이드를 구분해낼 수 있습니다. 다음으로 Code 1-7처럼 각 브라우저를 구분할 수 있는 내용을 추가하겠습니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-7.html"></script> 
 
그림 1-7. ![그림 1-7](/images/responsive-web/image_1-7.png)
 
이제 iOS, 안드로이드 그리고 Windows Phone 디바이스로 이 페이지를 열어줄 때 그림 1-7과 같이 Code 1-7에서 추가한 내용이 함께 로드됩니다. 마지막으로 jQuery.browser는 기본적으로 브라우저의 버전을 감지합니다. Code 1-8과 같이 간단한 방법으로 브라우저의 버전을 확인할 수 있습니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-8.html"></script> 
 
 
아시다시피 인터넷 익스플로러(IE)는 항상 웹 개발자들의 발목을 잡습니다. IE의 버전별로 결과가 미묘하게 다르므로 각 버전별 대응을 따로 해줘야 합니다. 이때 유용하게 사용할 수 있는 것이 바로 jQuery.browser.version입니다. 이를 이용하여 IE의 각 버전을 구분해보겠습니다. Code 1-9처럼 코드를 작성합니다.

<script src="https://gist.github.com/3347225.js?file=Code 1-9.html"></script> 
 
그림 1-8. ![그림 1-8](/images/responsive-web/image_1-8.png)
 
IE의 버전은 x.0 형태로 설정할 수 있습니다. Code 1-9와 같이 작성하면 IE의 모든 버전을 감지하고 버전별로 필요한 내용을 추가할 수 있습니다. 현재는 그림 1-8과 같이 버전별로 alert이 발생하도록 설정하였습니다.


### 참고하시면 좋은 곳

[Apple library - Viewport (애플 라이브러리 - 뷰포트)](http://developer.apple.com/library/ios/#DOCUMENTATION/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html "Apple Viewport") 

[Apple library - MetaTags (애플 라이브러리 - 메타태그)](https://developer.apple.com/library/safari/#documentation/AppleApplications/Reference/SafariHTMLRef/Articles/MetaTags.html "Apple MetaTags") 

[Android reference - WebView (안드로이드 레퍼런스 - 웹뷰)](http://developer.android.com/reference/android/webkit/WebView.html "Android WebView") 

[Windows Phone - Viewport (윈도우즈 폰 - 뷰포트)](http://windowsteamblog.com/windows_phone/b/wpdev/archive/2011/03/14/managing-the-windows-phone-browser-viewport.aspx "windows phone viewport") 

[W3 - Media Query (W3 - 미디어 쿼리)](http://www.w3.org/TR/css3-mediaqueries/ "W3 media query") 

[jQuery API - browser](http://api.jquery.com/jQuery.browser/ "jQuery API")

 