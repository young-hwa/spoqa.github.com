---
layout: entry
title: "Sublime Text 빠르게 적응하기"
author: jessica
author-email: jessica@spoqa.com
description: Sublime Text 초보 사용자를 위한 팁을 공유합니다.
publish: true
---

오늘은 제가 Sublime Text를 사용하면서 자주 썼고 유용하다고 생각되었던 것들을 몇 가지 공유해보려고 합니다. 이 글을 통해 Sublime Text를 처음 접하시는 분들은 [지난 포스트](https://spoqa.github.io/2015/11/11/install-sublime-text.html)를 먼저 읽으시길 추천해 드립니다.


## 문법 구분으로 코드 가독성 높이기 

Sublime Text에는 다른 코드작성용 텍스트 에디터와 마찬가지로 언어 구조에 맞게 색상이 자동으로 입혀지는 문법 강조(syntax highlighting) 기능을 제공하고 있습니다. 

<figure>
<img src="/images/2015-11-23/plain-text.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) 문법 구분 기능 미적용
</figcaption>
</figure>

<figure>
<img src="/images/2015-11-23/html-extension.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) 문법 구분 기능 적용
</figcaption>
</figure>

이 기능은 개발 언어의 구조에 따라 다른 색상이 적용되고 그 색상의 대비가 크기 때문에 코드의 구조와 문법적 오류를 빠르게 파악할 수 있습니다. 실제로 [코드상의 오류를 찾는 데 걸리는 시간을 줄여준다는 연구][1]도 있습니다. 문법 강조로 인해 텍스트의 의미나 기능이 달라지는 것은 아니며 이것은 오로지 사람이 읽을 때의 편의성을 위한 장치입니다. 이때 사용되는 색상은 텍스트 에디터, 테마 설정, 사용자 설정에 따라 바뀔 수 있습니다.

### 1. Extension 설정 확인하기

우선 Sublime Text 하단 우측(분홍색으로 표시된 부분)에 현재 쓰고 있는 파일 형식과 같은  Extension이 설정되어 있는지 확인하세요.
<img src="/images/2015-11-23/extension-location.png" /> 

만약 기본값인 Plain text로 되어 있거나 다른 Extension으로 되어 있다면 그 부분을 클릭하여 알맞은 언어를 선택하여 알맞게 문법이 강조되도록 하면 됩니다.
<img src="/images/2015-11-23/extension.png" />     

### 2. Package 설치하기

만약 기본 Extension에서 제공해주지 않는 언어라면 어떻게 해야할까요? 추가로 HTML과 CSS를 도와주는 보조 언어/라이브러리를 설치하여 작성하다 보면 HTML이나 CSS는 언어 구조에 따라 자동으로 색상이 입혀져 있는 반면에 보조 언어로 쓰인 부분은 문법이 강조되지 않습니다. 예로, 아래 그림에는 HTML과 보조 언어인 [Jinja][2](아래 이미지에서 쿨그레이색으로 1, 2, 4, 5, 6, 8번째 줄에 등장하는 언어)가 함께 사용되고 있습니다.

<figure>
<img src="/images/2015-11-23/just-html.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
(위) HTML 언어 사이에 HTML이 아닌 언어(jinja)가 섞여 있다.
</figcaption>
</figure>

이것은 지정된 기존의 언어와 달라서 생기는 현상입니다. 이 경우에는 문법 강조를 도와주는 일종의 플러그인이라고 할 수 있는 Package를 설치하면 됩니다. 

<figure>
<img src="/images/2015-11-23/jinja-syntax.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
(위) HTML뿐만 아니라 다른 언어(jinja)에도 문법 강조 기능이 적용되었다.
</figcaption>
</figure>

만약 Sass에 대한 문법 강조가 필요하다면, `sublime text syntax highlighting for Sass` 등의 키워드로 검색하여 설치 방법을 쉽게 찾으실 수 있습니다. 지난 글에서 Material design 테마를 Package Control을 통해 설치하는 방법을 소개했습니다. 따라해 보셨다면 필요한 패키지 설치방법을 알기 어렵지 않을 것입니다.

#### Sass 패키지 설치해보기

방금 예로 들었던 Sass로 패키지를 설치해봅시다.
Sass는 CSS를 더 효율적으로 작성할 수 있도록 도와주는 언어입니다. Sass에 대한 설명은 다른 포스트에서 자세히 설명해드릴 수 있을 것 같아 여기서는 생략하도록 하겠습니다.

먼저, `sublime text syntax highlighting for Sass` 등으로 검색을 합니다.

<img src="/images/2015-11-23/searching-sass.png"
     style="margin-right:auto; margin-left:auto;" />

검색결과 최상단에 URL이 `http://packagecontrol.io/...`로 시작하는 문서가 검색되었습니다. 패키지 컨트롤 공식 페이지인 만큼 믿을만한 정보가 있겠죠? 해당 링크를 클릭하여 설치하는 방법을 찾습니다.

<img src="/images/2015-11-23/packagecontrol-io.png"
     style="margin-right:auto; margin-left:auto;" />

> Install via Package Control. (패키지 컨트롤을 통해 설치하세요)

문서를 쭉 훑어보았으나 설치 방법에 대한 단서는 이것뿐입니다. 지난 포스트에서 패키지 컨트롤을 설치했으니 이 과정은 건너뛰고 바로 패키지 설치를 해보겠습니다.

`Sublime Text` > `Preferences` > `Package Control`을 클릭합니다.

<img src="/images/2015-11-23/select-pakagecontrol.png"
     style="margin-right:auto; margin-left:auto;" />


그러면 명령어를 입력할 수 있는 팔레트가 뜹니다. 여기에 `Package Control: install Package`라고 입력 후 엔터를 누릅니다.

<img src="/images/2015-11-23/packagecontrol-00.png"
     style="margin-right:auto; margin-left:auto;" />


잠시 후 다시 명령어 팔레트가 또 뜨는데 이번에는 `syntax highlighting for Sass`를 입력하고 엔터를 누릅니다. 검색어 입력과 동시에 하단에 이름에 검색어가 들어간 패키지가 모두 검색되어 나옵니다. 그러므로 패키지 컨트롤 공식 페이지에서 정확한 패키지 이름을 알아내어 그걸 그대로 붙여넣는다면 설치하기 더 쉽겠지요.

<img src="/images/2015-11-23/packagecontrol-02.png"
     style="margin-right:auto; margin-left:auto;" />

잠시 후 패키지가 설치되면 아래와 같은 글이 나옵니다. 닫아주시면 됩니다.

<img src="/images/2015-11-23/packagecontrol-03.png"
     style="margin-right:auto; margin-left:auto;" />

설치되었다면 하단 우측 extension 선택하는 곳에서 `Syntax Highlighting for Sass`를 발견하실 수 있습니다. 

<img src="/images/2015-11-23/sass-installed.png"
     style="margin-right:auto; margin-left:auto;" />

## 보는 방식으로 코드 가독성 높이기 

Sublime Text의 `view`메뉴의 몇가지 기능만으로도 코드 읽기에 편리한 작업 환경으로 바꿀 수 있습니다.

<img src="/images/2015-11-23/see-view-menu.png"
     style="margin-right:auto; margin-left:auto;" />

### 1. 열(column) 너비 고정하여 가로 스크롤 줄이기 

`view` > `word wrap` 체크하고 `view` > `word wrap column`

<img src="/images/2015-11-23/column-wrap.png"
     style="margin-right:auto; margin-left:auto;" />

간혹 살펴보아야 할 코드가 가로로 꽤 길어서 가로 스크롤이 길어지는 경우가 있습니다. 이를 한눈에 잘 볼 수 있도록 가상의 열을 만들어주는 기능으로, 코드에는 변화가 없습니다.


<figure>
<img src="/images/2015-11-23/auto.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) word wrap column > auto 적용 시
</figcaption>
</figure>

<figure>
<img src="/images/2015-11-23/70.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) word wrap column > 70 적용 시
</figcaption>
</figure>

auto는 반응형으로 창 크기에 맞게 열 너비가 변화하지만, 텍스트 커서를 키보드로만 움직일 때는 스크롤이 움직이지 않도록 wrap column을 좁게 하여 쓰는 게 편할 수 있습니다. 
  

### 2. 한번에 여러 개 문서 보기 

`view` > `layout`

<img src="/images/2015-11-23/layout-menu.png"
     style="margin-right:auto; margin-left:auto;" />

한번에 여러 가지 문서 보면서 수정할 때 굉장히 유용한 기능입니다. 해상도에 따른 작업환경이나 멀티태스킹을 해야 할 때 유용한데, 저는 `Columns:2`를 애용합니다. 작업하는 업무 성격이나 사용하는 언어에 따라 편한 레이아웃을 골라 사용하시면 됩니다. 

<figure>
<img src="/images/2015-11-23/columns2.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) Columns:2 적용 시
</figcaption>
</figure>

<figure>
<img src="/images/2015-11-23/row3.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) Rows:3 적용 시
</figcaption>
</figure>


## 고치고 싶은 부분 쉽게 찾기

웹뷰로 되어 있는 부분의 스타일을 수정하려고 할 때는 보통 아래의 절차로 진행합니다.

1. 웹 브라우저에서 요소 검사(Inspect Element)하여 고치고 싶은 부분을 찾는다.
2. Sublime Text에서 고쳐야 하는 부분을 찾아 코드를 수정한다.

1과 2의 사이에서 내가 고치고 싶은 코드를 어떻게 하면 빠르게 찾을 수 있을지 처음에는 알기 어려울 수 있습니다. 이를테면 어느 파일 몇 번째 줄에 있는지, 찾아야 하는 코드가 두 군데 이상에 적용되어 있을 때 등의 경우에 고민이 생기게 될 것입니다. Sublime Text의 상단에 있는 `Find` 메뉴 등에서 제공하는 여러 가지 검색 기능으로 해결할 수 있습니다. 
<img src="/images/2015-11-23/see-find-menu.png"
     style="margin-right:auto; margin-left:auto;" />

<img src="/images/2015-11-23/sublimetext-find-menu.png"
     style="margin-right:auto; margin-left:auto;" />   

그중 제가 굉장히 자주 썼던 검색 기능 몇 가지를 소개합니다. 


### 1. 찾기(Find) 

`⌘` + `F`

현재 보고 있는 파일 내에서 특정한 단어를 찾을 때 사용합니다.

<img src="/images/2015-11-23/find-example.png"
     style="margin-right:auto; margin-left:auto;" />   


### 2. 파일 내에서 찾기 (Find in Files) 

`⌘` + `shift` + `F`

Where에 쓰인 디렉토리 안에 있는 모든 파일에서 검색어가 있는 부분들을 검색합니다. 특정 부분이 어느 파일의 몇 번째 줄에 작성되어 있는지 모를 때 유용한 기능입니다. 검색어가 써진 곳은 모두 검색 결과에 나오기 때문에 여러 군데 쓰이는 단어보다는 찾고자하는 부분에만 쓰이는 클래스 이름 등을 작성하면 찾기가 더 쉽습니다.

<img src="/images/2015-11-23/findinfiles-0.png"
     style="margin-right:auto; margin-left:auto;" />   

찾고 싶은 검색어를 입력합니다. 저는 spoqa 폴더 내에서 `margin-left: auto;`가 써진 곳을 모두 찾고 싶다고 가정하고 써보았습니다.

<img src="/images/2015-11-23/findinfiles-1.png"
     style="margin-right:auto; margin-left:auto;" />   

그러면 Find Results 탭이 생기면서 검색 결과를 보여줍니다. 어떤 디렉토리의 어떤 파일에 몇 번째 줄에 검색어가 쓰여 있는지 쉽게 알 수 있습니다. 또한, 파일 이름 부분을 더블 클릭하면 바로 그 파일로 이동합니다.


### 3.무엇이든 이동하기 (Goto anything) 

`⌘` + `P`

<img src="/images/2015-11-23/goto-anything.png"
     style="margin-right:auto; margin-left:auto;" />   

`Goto` > `Goto anything`으로도 접근할 수 있는 이 기능은 특정한 파일이나 행(line)으로 이동할 때 사용합니다. 디렉토리를 뒤질 필요 없이 보고 싶은 파일 이름을 검색하여 빠르게 열 수 있습니다. 

폴더 채로 열려있는 상태라면 `⌘` + `T`도 같은 역할을 하는데 이 기능은 현재 열려있는 탭 리스트 중에서만 선택하여 이동할 수 있습니다.


### 4. 특정한 행으로 이동하기  

`Goto anything`을 켜고 `:14`

<img src="/images/2015-11-23/goto-line.png"
     style="margin-right:auto; margin-left:auto;" />   

긴 스크롤에 방해받지 않고 특정 행을 바로 보고 싶다면 이 기능도 유용합니다. 만약 14번째 줄로 이동하고 싶다면 위에서 설명해 드린 Goto anything 기능을 켜고 `:14`을 입력하면 됩니다. 


## 마치며

이 외에도 Sublime Text에는 많은 기능을 제공하고 있지만, 이것들만 알아도 사용하는 데 큰 무리가 없습니다. 더 다양한 기능을 알고 싶다면 메뉴를 구석구석 눌러보면서 직접 경험하거나 검색만 하더라도 무궁무진한 팁을 발견할 수 있습니다. 혹은 [Sublime text tips](http://sublimetexttips.com/) 같은 뉴스레터를 구독하는 것도 방법이겠지요.

짧은 글이지만 Sublime Text를 통해 코드에 입문하는 사람에게 도움이 되면 좋겠습니다. 다음에도 유용한 글로 찾아뵙겠습니다. 읽어주셔서 감사합니다!



[1]: https://en.wikipedia.org/wiki/Syntax_highlighting#Practical_benefits
[2]: http://jinja.pocoo.org/
