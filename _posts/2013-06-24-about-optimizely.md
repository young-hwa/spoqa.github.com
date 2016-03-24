---
layout: entry
title: A/B Testing 도구인 Optimizely 사용법
author: 이의성
author-email: leeus@spoqa.com

description: A/B Testing 도구인 Optimizely의 장점과 활용법을 소개합니다.
---



웹 서비스를 운영하다 보면 준비하는 과정에서 정말 많은 고민이 오갑니다. 컨텐츠의 배치, 헤드 카피, 인터랙티브.. 하지만 어떤 요소가 조금 더 사용자의 반응을 이끌어내는지 정확히 알 수 없습니다. 이런 부분들을 '직감'이나 '경험'으로 막연하게 자기 자신과 타인에게 주장하고 있지는 않나요?

그렇다면 두 가지 혹은 그 이상의 시안들을 직접 시험대에 올려 각각 더 좋은 것을 선택하는 것은 어떨까요? 

A/B 테스팅에 관련한 유명한 일화가 하나 있습니다. 1497년, [Vasco da gama](http://ko.wikipedia.org/wiki/%EB%B0%94%EC%8A%A4%EC%BF%A0_%EB%8B%A4_%EA%B0%80%EB%A7%88)는 최초로 유럽에서 아프리카 남부를 거쳐 인도까지 항해한 인물입니다. 그가 인도를 발견하고 귀항했을 때 160명의 원정대원 중 100명이 [괴혈병](http://ko.wikipedia.org/wiki/%EA%B4%B4%ED%98%88%EB%B3%91)으로 사망하는 사건이 있었습니다. 그만큼 괴혈병은 항해하는 선원들의 공포 대상이었죠. 그로부터 약 300년 뒤, 영국의 의사인 [James Lind](http://en.wikipedia.org/wiki/James_Lind)는 괴혈병의 치료법을 알기 위해 실험군을 나누어 각각 다른 음식으로 실험을 진행했습니다. 

실험은 다음과 같습니다. 괴혈병에 걸린 12명의 선원을 선정하여 그 중 10명에게는 보통 음식을 주고, 두 사람에게는 매일 라임 과즙을 마시게 하였습니다. 6일 후 라임 과즙을 마신 선원 두 명만이 괴혈병에 완벽히 치료된 모습을 보였습니다. James Lind가 실험하기 전에는 단순히 '감귤류 과일이 괴혈병에 좋다.', '괴혈병으로 죽어가는 찰나에 잡초를 먹고 다시 살아났다.' 라는 이야기만이 난무했었고 직접적인 치료법을 제시한 사람은 James Lind가 최초였습니다.  비타민C가 발견된 것이 1928년임을 고려하면, 이 당시에는 비타민C 이라는 개념이 없었기 때문에 James Lind의 실험은 후에 많은 선원의 목숨을 괴혈병으로부터 지켜주는 사례가 됩니다.

괴혈병이 해적보다 더 무서웠던 대항해시대에 보통 음식(A)과 라임(B)을 이용해 선원들을 모두 구했던 영국 해군의 현명한 대처법에서 우리의 웹 서비스를 더욱 더 활성화 시키는 지혜를 얻어야 합니다. 


![lind](/images/2013-06-24/lind.jpg)


## [Optimizely](http://optimizely.com)?

Optimizely는 웹서비스를 운영하면서 A/B Testing 수행을 원하시는 분들에게 적합한 서비스입니다. Optimizely를 사용하기 전에 A/B 테스팅에 대한 정보가 필요하다면 A/B 테스팅에 관련한 JC Kim님의 글( [A/B Testing에 대한 기초적인 정보들](https://spoqa.github.io/2012/05/15/ab-testing-basic.html) )을 먼저 읽어보시는 것을 추천합니다. 

Optimizely는 단순히 A/B 테스트의 진행과 그 통계 결과만 제공하는 것이 아니라, 테스트를 진행하는 동안의 모든 준비 과정에서 사용자들에게 도움을 주고 있습니다. 오늘은 그 Optimizely의 핵심 기능 및 활용법에 대하여 알아보겠습니다. Optimizely는 유료 서비스이지만 30일 동안의 Free Trial을 제공해주므로 그 기간 동안 충분히 이 서비스의 모든 것을 체험할 수 있습니다.

Optimizely는 세계적인 대형 기업들이 이용하는 서비스로, 이들은 이미 Optimizely를 통해 각각 컨텐츠들에 대한 사이트 접속자들의 반응을 체크하고 있습니다. 대표적인 회사로 [Starbucks](http://www.starbucks.com/), [Salesforce](www.salesforce.com/), [MTV](http://www.mtv.com/), [The Walt Disney Company](http://thewaltdisneycompany.com/), [ABC](http://beta.abc.go.com/) 등이 있습니다. 

그렇다면 왜 많은 기업들이 A/B Testing에 집중하고 있고, Optimizely를 이용하는 걸까요?

![screen](/images/2013-06-24/optimizely.jpg)



### 더 정확한 데이터를 추출하려는 노력.

메일링 리스트를 수집하는 등의 폼 입력/전송을 하는 비율을 구하는 경우, 혹은 메인 페이지에서 다른 세부페이지로 이동하는 이용자 비율을 나타내기 위해 **목표(Goal)**을 나타냅니다. 목표한 골에 A 버전(기존안/Original) 이용자가 더 많이 들어갔는지, B 버전(새로 작성한 안/Variation)이 효과적이었는지를 테스트 할 수 있습니다. 

이처럼 Goal에 도달하는 행위를 **'Conversion'**이라 표현합니다. 방문자 수 대비 Conversions 수치를 비교한 Conversion rate를 비교하면 A/B 시안 중에 더 효과적인 결과를 수치와 그래프, 특히 "기준을 이길 수 있는 확률"(Chance to beat baseline)을 철저하게 계산해 결과를 명확하게 진단할 수 있습니다. 말 그대로 Goal과 Conversion Rate 수치로 사용자가 승자를 판단하는 것이 아니라, 수치공식을 통해 B 버전이 기존안(A버전)을 확실하게 이겼는지 아닌지를 파악해줍니다.

더 자세히 알고싶은 부분은 해당 값을 구하는 통계공식이 있는 [링크](http://support.optimizely.com/customer/portal/articles/469316-what-does-%22chance-to-beat-baseline%22-actually-mean-)를 참고해주세요.



### 정말 쉬운 실험요소 변경.



Optimizely를 이용하면 여러분이 복잡한 CSS나 Javascript 기술이 없어도 쉽게 A/B 테스팅을 진행할 수 있습니다. Optimizely에서는 실험군의 요소를 마우스 클릭 몇 번으로 손쉽게 바꿀 수 있습니다. 가령 B 버전에 A 버전과 다른 문서 배치를 하거나 배경화면, 이미지, 폰트, 버튼 속의 문구 등도 별도의 코딩 절차 없이 Optimizely 실험페이지 내에서 변경할 수 있다는 말이죠. 또한 실시간으로 CSS를 변경하여 적용하거나 Javascript도 적용할 수 있습니다. 마치 '나모 웹 에디터' 나 '드림위버' 같은 인터페이스로 파워포인트 내의 요소를 다루듯 쉽게 바꿀 수 있습니다.



![1](/images/2013-06-24/1.png)

위치와 크기를 Drag & Drop 으로 쉽게 움직이게 할 수 있습니다.

![2](/images/2013-06-24/2.jpg)

웹사이트에 적용된 이미지 또한 로컬에 있는 파일 혹은 웹에 있는 이미지로 대체할 수 있습니다.

![3](/images/2013-06-24/3.jpg)

텍스트도 곧바로 변경할 수 있고 HTML을 직접 대체해서 끼워 넣을 수 있습니다.

참 쉽죠?


### 간단한 설치

위처럼 변경했던 시험요소들을 저장하려면 복잡하고 긴 코드를 다시 원래 파일에 붙여 넣어야 할까요? 그렇지 않습니다. Optimizely는 변경한 컨텐츠 정보를 간단한 자바스크립트 코드로 'Optimize' 해 주기 때문에 단 몇줄만 추가해주면 원하는 결과가 나옵니다.





### 확장성

유명한 아티스트 두 명이 콜라보레이션 하는 상상을 해보죠. 각자의 개성을 살려 새로운 결과물들을 창조해내지요. 물론 그들의 궁합이 잘 맞아야 한다는 전제가 있습니다. 하지만 다행히도 Optimizely와 연동되는 서비스들은 궁합이 잘 맞는 편입니다. Optimizely는 A/B 테스팅에 관한 자료에 집중하고 있기 때문에, 조금 더 디테일한 자료(Analytics, Heatmap)는 욕심내지 않고 기타 많은 서비스와 연동합니다.


Optimizely와 연동되는 서비스는 다음과 같습니다.


###### Analytics
* [Google Analytics](http://www.google.com/analytics/)
* [KISSmetrics](https://www.kissmetrics.com/)
* [Mixpanel](https://mixpanel.com/)
* [Omniture SiteCatalyst](http://www.omniture.com/ko/products/web_analytics/sitecatalyst)


###### Heatmap
* [ClickTale](http://www.clicktale.com/)
* [Crazyegg](http://crazyegg.com/)


위 서비스 중 하나라도 이용 중이시라면, Optimizely와 어떤 부분이 연동이 되는 지 살펴보세요.



## 마치며


페이지 두 개를 접속자들에게 무작위로 나누어 배포해서 반응을 트래킹하는 기술은 흔할지도 모릅니다. 하지만 Optimizely를, 그리고 연동되는 다양한 서비스들을 이용하면 조금 더 세밀하고 확실한 데이터를 얻을 수 있습니다. 정말로 나의 웹 서비스에 필요한 것이 '잡초'인지 '레몬'인지 알고 싶다면 지금 당장 시작해보세요.
