---
layout: entry
title: 960 Grid System을 사용한 웹 페이지 제작
author: 이의성
author-email: leeus@spoqa.com
description: 웹 페이지 제작 시 기준이 되는 960 Grid System을 소개합니다.
---

안녕하세요. 스포카 크리에이터 팀에서 웹 개발 관련 업무를 담당하고 있는 이의성입니다.
오늘 다루어 볼 주제는 웹 페이지 제작 시 사용되는 Framework 중 깔끔하게 페이지의 구조를 잡아주는 Grid System에 대해서 알아보고, 대표적인 Grid System인 “960gs”를 소개하는 시간을 가져보겠습니다.

#### About “Grid System”
---

여러분은 웹 페이지를 제작할 때 콘텐츠의 구조와 배열을 어떻게 설정하십니까? 혹시 내부 콘텐츠들을 감싸고 있는 div 태그 각각에 높이와 넓이 등을 CSS로 지정해주는 수고를 하지는 않으신가요? 계산 착오로 1픽셀 때문에 전체적인 구조가 무너진 경험은 없으신가요? 

 웹 페이지를 제작하는 기초 단계에서 Grid System을 먼저 구축하면 제작을 쉽고 빠르게 진행할 수 있습니다. Grid System에서 ‘Grid’는 가로와 세로, 격자(格子)무늬를 뜻합니다. Grid는 인쇄가 발명되기 전 단순한 격자로 글자를 배열하는 것에서 기원합니다. 2차 세계 대전 이후 인쇄물에 출력되는 타이포그래피의 Page layout을 잡는 'Modern Grid'가 탄생하면서, 1970년대 중반부터 그래픽 디자인 커리큘럼에 도입된 후 본격적으로 사용되었습니다. 현재는 이 기술이 웹 개발 분야에도 적용되어 한마디로 ‘각 잡힌' 디자인을 표현할 수 있습니다. 이처럼 인쇄물에서 시작한 Grid System이 웹으로 넘어오게 된 것은, 종이보다 디지털 환경을 많이 접하게 되는 요즘 세상에서는 당연한 일이겠지요. 

Grid System을 이용하면 웹 개발에서는 더는 계산기가 필요 없습니다. 단지 머릿속에서 ‘12 빼기 8’, 혹은 ‘16 나누기 4’를 할 수 있다면, 여러분은 Grid System을 적용할 준비가 되었습니다.

![실제 적용](/images/about-grid-system/1.png)

이처럼 딱 떨어지는 디자인을 할 수 있습니다!



#### 웹 디자인에서의 Grid System 
---

Grid System은 목적에 따라 다양하게 선택할 수 있습니다. 국내에는 자료가 부족하지만, 외국 사이트에는 훌륭한 Grid System Framework가 많이 있습니다. 여러분이 작성하는 웹 페이지의 규격에 맞는 Framework를 골라 적용해도 되고, 본인이 원하는 넓이로 CSS를 작성하여 Framework를 구축할 수 있습니다.

우선 "웹 디자인"에서의 Grid System의 기본 구성 요소에 대해 설명하겠습니다. 

#### 기본요소: Column / Gutter / Container
---

실제로 콘텐츠를 포함하는 부분은 Column이라고 합니다. 이 Column의 넓이는 고정된 값으로 제공되며, 1개 이상의 Column이 조합하여 콘텐츠의 크기를 결정합니다. 그리고 하나의 Column 안에는 반드시 양옆에 여백, 즉 'Gutter'를 동반합니다. Gutter는 Column과 Column 사이의 간격이 되는 부분입니다. Gutter는 Column부분에 CSS의 'Margin' 값이 10px씩 적용된다는 개념과 같습니다.


여기서 혼동하지 말아야 할 부분은 2개 이상의 Column은 맞닿는 내부의 Gutter를 포함한 넓이를 가집니다. 단, 양쪽에 Gutter 값을 가지는 Column의 성질은 병합된 Column 수가 늘어도 그대로 유지됩니다. 

![gutter](/images/about-grid-system/gutter.png)


Container는 Column의 수를 지정해줍니다. 몇 개의 Column을 사용하는 Grid System인지 정의하는 부분입니다. Container의 내부에는 콘텐츠를 담아내는 한 개 이상의 Column이 존재합니다.


![container](/images/about-grid-system/12n16.png)


이처럼 Column의 수에 따라 콘텐츠를 표현할 수 있는 넓이는 달라집니다. 12 Column Grid보다는 16 Column Grid가 넓이를 조금 더 세밀하게 표현할 수 있습니다. 하나의 Column 당 크기가 12 Column Grid는 60px이지만, 16 Column Grid는 40px이기 때문이죠. 


또한, 960gs 에서는 24 Column Grid까지 가능합니다. Column을 30px 단위로 작성하고 싶으신 분은 [링크](http://net.tutsplus.com/tutorials/html-css-techniques/mastering-the-960-grid-system/)를 참조해주세요.
 

하지만 단순히 Column의 수가 많다고 해서 좋은 Grid System이라고 볼 수 있을까요? 디자인 과정에서 굳이 16 Column Grid가 필요 없다고 느껴진다면, 12 Column Grid를 사용하는 것이 가장 바람직합니다. 오히려 Column 수가 많아지면 Grid System이 익숙지 않은 상황에서는 혼란을 일으킬 수 있습니다. 제가 설명하는 Grid System은 "960gs"를 기준으로 설명하고 있지만, 시스템에 따라서 지원하는 Column의 유형도 다릅니다. 최근에는 디바이스 환경에 따라 해상도가 다양하므로, 다양한 크기를 지원하는 ['반응형 Grid System'](<http://www.designinfluences.com/fluid960gs/>) 도 만날 수 있습니다.



#### 실제 적용하기
---

그럼 Grid System을 이용해 실제 진행 과정을 살펴보겠습니다.
가장 많이 사용되는 960gs를 사용하여 Grid System을 구축하는 방법을 알아보겠습니다. [960gs 홈페이지](http://960.gs)에서 파일을 다운로드 받으시면 아래의 과정을 따라 하실 수 있습니다. 

##### Page design

Grid System은 효과적으로 페이지의 레이아웃을 스케치를 할 수 있습니다. 디자인 작업 전 종이에 하는 스케치 과정에서 [Grid가 그려진 PDF](<http://www.scribd.com/doc/2663171/960-Grid-System-sketch/>)를 출력해 스케치할 수 있습니다.  


![grid_sketch](http://d3pr5r64n04s3o.cloudfront.net/092_960_GridSystem/sketch_1.jpg)


스케치가 그려지면 디지털 제작 과정을 시작합니다. 960gs를 사용하면 Grid System에 딱 맞는 디자인 작업을 할 수 있습니다. 다운로드 파일의 ‘templates’ 폴더를 확인하면, 다양한 디자인 툴에서 960gs를 지원한다는 것을 확인할 수 있습니다.

![templats](/images/about-grid-system/templates.png)


파일을 열어보면 보조선이 적용되어 있음을 확인할 수 있습니다. 앞서 말씀드린 Gutter 부분을 생각하시면서 알맞게 콘텐츠를 배열하여 작업하시면 됩니다. 



##### Coding

이제 디자인을 바탕으로 구현에 들어갑니다. [960gs 기본규격 CSS](http://grids.heroku.com/grid.css?column_width=60&column_amount=12&gutter_width=20)를 다운로드를 받은 뒤 진행합니다.

HTML에 다운로드 받은 '960.css' 파일을 불러옵니다. 'head' 부분에 다음과 같이 입력합니다.

<script src="https://gist.github.com/4115886.js"></script>

그리고 'body' 부분에 다음과 같이 Column을 생성합니다.

<script src="https://gist.github.com/4109461.js"></script>



위와 같은 코드를 작성하면 적용되는 범위는 다음과 같습니다.


![grid_4](/images/about-grid-system/grid_4.png)



'container'는 처음 12 column grid인지, 16 column grid인지를 먼저 선언합니다. 전체 페이지를 포함하는 container 역할을 하는 div의 class를 "container_12" 혹은 "container_16"로 입력해주면 됩니다. Grid System을 제공하는 CSS(960.css)를 살펴보면 다음과 같습니다.


<script src="https://gist.github.com/4109565.js"></script>

##### prefix & suffix
-----

'960gs'의 특징이라고 볼 수 있는 점은 한 행에 12 혹은 16 Column이 채워져야 한다는 점입니다. 만약 다른 행에 Column을 넣고 싶다면 비어있는 Column을 padding값이 있는 Column으로 채워주면 되는데, 그와 관련된 속성이 바로 'prefix' 와 'suffix' 입니다.

##### prefix

![grid_4](/images/about-grid-system/prefix.png)

그림에서 확인할 수 있듯 'prefix'는 'grid'만큼 빈 영역을 차지하게 됩니다. 

<script src="https://gist.github.com/4115355.js"></script>

960.css 파일을 살펴보면 위와 같이 'padding-left' 속성이 적용되어 있음을 알 수 있습니다. 하나의 'prefix'당 80px을 차지하는데, 이 값은 60px에 양쪽 gutter 값 20px이 합쳐진 값임을 알 수 있습니다. 'container_12'를 기준으로 'prefix_1'의 padding 값이 'grid_1'의 넓이만큼 적용되어 있음을 알 수 있습니다. 다시 정리하자면, Column을 기준으로 왼쪽에 여백을 주고 싶을 때 prefix를 사용합니다.

##### suffix

그렇다면 'prefix'와 반대로 Column기준 오른쪽에 여백을 주고 싶을 때는 어떻게 해야 할까요? 바로 'suffix'를 사용하면 됩니다.

![grid_4](/images/about-grid-system/suffix.png)

그림에서는 왼쪽에 어떠한 Column이 없을 때 Column을 오른쪽에 정렬시키는 방법입니다. container 12 기준으로 'prefix'값을 11로 잡으면 1개의 'grid'를 오른쪽에 붙일 수 있습니다. (이렇게 12개의 공간을 채운다면, 다음 grid는 자동으로 아래 행에 생성됩니다.)
아래 행을 보시면 오른쪽에 1개의 공간이 있습니다. 바로 'suffix' 속성이 1 만큼 적용되었기 때문이죠.

'prefix'처럼 'suffix'도 언더바와 숫자를 입력해서 그만큼의 padding 값을 적용시킬 수 있습니다. 960.css에서는 'suffix'속성에 'padding-right'속성이 적용되어 있음을 알 수 있습니다.

<script src="https://gist.github.com/4115421.js"></script>




##### Push & Pull
-----

960gs에서는 'push'와 'pull'을 사용하여 Column을 독립적으로 재 배치 할 수 있습니다.

![grid_4](/images/about-grid-system/pushnpull.png)

'push'는 주어진 값만큼 Column을 왼쪽에서 오른쪽으로 밀어 넣는 역할을 합니다. 앞서 보신 'prefix'와 다른 점은 순수 Column영역과 '중첩'이 된다는 점입니다. 'pull'의 경우 'push'와 반대로 오른쪽에서 왼쪽으로 밀어 넣는 역할을 합니다. 이런 속성이 실제로는 어떻게 적용을 하는지 확인해 보겠습니다.


![grid_4](/images/about-grid-system/pushnpullbefore.png)


위와 같은 상황에서 Column들을 재 배치 해보겠습니다. 'Text 1' 을 맨 왼쪽으로, 'Logo'를 가운데로 오게끔 만들겠습니다.

<script src="https://gist.github.com/4115510.js"></script>

위의 코드를 확인해보면 알 수 있듯, 'Text 1'과 'Logo'의 위치를 'push'와 'pull'로 조정하면 됩니다. 'Logo'는 1번째 grid 지점에서 시작하므로 'push' 값을 3을 줍니다. (Container 12의 grid에서 6크기 Column을 가운데 오게 하려면 왼쪽과 오른쪽에 3 Column만큼 여백이 있으면 되겠죠? 3+6+3=12) 

반면 'Text 1'의 경우 7번째 grid 지점에서 시작하므로 'pull'값을 6만큼 준다면, 원래 'Logo'가 시작했던 자리인 1번째 grid 지점으로 이동하게 됩니다. (7-6=1)

![grid_4](/images/about-grid-system/pushnpullafter.png)



##### alpha & omega
-----

'alpha' 와 'omega'속성을 사용하면 좀 더 디테일한 레이아웃을 작성할 수 있습니다.

 ![grid_4](/images/about-grid-system/alphaomega1.png)

예를 들어 이런 레이아웃을 디자인했다고 가정해 보겠습니다. Column들의 길이와 넓이가 제각각이라서 지금까지 알아본 개념으로는 이런 레이아웃을 만들기 어렵습니다. 이제부터 소개하는 'alpha'와 'omega' 속성을 이용해서 이러한 복잡한 레이아웃의 구조를 간단하게 만드는 방법을 알아보겠습니다.


![grid_4](/images/about-grid-system/alphaomega2.png) 

먼저 세부 Column들을 감싸는 Container역할(Container는 아닙니다!)을 하는 grid를 그림처럼 생각해볼 수 있겠습니다. 그런 다음 grid 내부에 grid를 넣는 방식으로 처리하면 되겠습니다. 그런데 여기서 문제가 있습니다. grid내부에 grid를 그냥 적용하면 어떤 현상이 발생할까요?

![grid_4](/images/about-grid-system/alphaomega3.png) 

제 생각에는 이 부분이 처음 grid를 작성할 때 흔히 할 수 있는 오류이기도 하면서 가장 중요한 부분입니다. 먼저 초록색 영역은 앞서 보았던 Gutter 영역입니다. 실제로 보이는 콘텐츠가 아닌 비어있는 margin 값만 존재합니다. 그림 우측에 보이는 것처럼, 감싸는 역할을 하는 Column인 'grid_6'의 오른쪽으로 20px이 삐져나온 모습입니다.

이렇게 Column의 넓이가 감싸는 grid의 넓이를 초과하는 경우, 실제 화면에서는 초과하는 Column을 아래로 내려버립니다. 이럴 때 레이아웃이 깨지는 현상이 생기는데, 이 문제를 해결하기 위해서는 내부에 있는 'grid_3'의 Gutter 값을 없애야 합니다.

왼쪽의 'grid_3'은 왼쪽 Gutter 값이 필요 없습니다. 이미 'grid_6'의 Gutter 값이 존재하기 때문이죠. 그림에서 보이는 파란색 가이드라인 에서도 Column영역에 Gutter가 들어와 있는 상황입니다.

이런 현상을 해결하기 위해서 'alpha'와 'omega'를 사용합니다. 먼저 960.css의 'alpha', 'omega' 속성을 살펴보죠. 


<script src="https://gist.github.com/4115674.js"></script>


어떻게 적용할지 감이 오시나요? 'alpha'는 왼쪽 Gutter를 없애고, 'omega'는 오른쪽 Gutter를 없애는 속성입니다. 따라서 왼쪽 'grid_3'에는 'alpha'를, 오른쪽 'grid_3'에는 'omega'를 적용하면 됩니다.

![grid_4](/images/about-grid-system/alphaomega4.png) 


또, 한 번에 'alpha'와 'omega'를 동시에 적용하면 양 쪽 Gutter가 없는 순수 Column영역만 남게 됩니다.

<script src="https://gist.github.com/4115810.js"></script>


이제 맨 처음에 봤던 복잡한 레이아웃을 어떻게 잡아나갈지 계획할 수 있습니다.

![grid_4](/images/about-grid-system/alphaomega5.png) 




##### 마치며
-----

그동안 Grid System 없이 페이지의 레이아웃을 잡으시느라 고생이 많으셨습니다. 하지만 960gs 이외의 수많은 Grid System Framework는 여러분께 정돈된 웹 페이지를 쉽고 빠르게 제작하는 방법입니다. 어쩌면 하나의 방법이라기 보다는 '좋은 습관'이라 말하고 싶습니다. 작동하는 원리를 제대로 이해하고, 습관이 된다면 웹 개발에 갓 입문한 사람이라도 훨씬 더 나은 결과를 만들어낼 수 있습니다. 여러분도 해보세요!

