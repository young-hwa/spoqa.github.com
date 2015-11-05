---
layout: entry
title: "Sublime Text 빠르게 적응하기"
author: jessica
author-email: jessica@spoqa.com
description: Sublime Text 초보 사용자를 위한 팁을 공유합니다.
publish: true
---

현재 스포카 디자이너들은 코드를 작성 및 수정할 때 Sublime Text를 사용하고 있습니다. 제가 사용하면서 자주 쓰게 되고 유용하다고 생각되었던 것들을 몇 가지 공유해보려고 합니다. 특히 Sublime Text를 통해 코드에 입문하는 사람에게 도움이 되리라 생각합니다.

## Sublime Text?

이 포스트를 통해 Sublime Text를 처음 접하시는 분들은 지난 포스트를 참고하시면 더욱 좋습니다.

[다시 읽기 - SublimeText 설치하기](http://spoqa.github.io)

Sublime Text는 HTML, CSS, Javascript 등 모든 프로그래밍 언어를 작성할 때 사용할 수 있는 텍스트 에디터입니다. 간단하게는 (마크다운과 함께) 메모장처럼 사용할 수도 있습니다.


## Syntax 구분으로 코드 가독성 높이기 

Sublime Text에는 다른 코드작성용 텍스트 에디터와 마찬가지로 언어 구조에 맞게 색상이 자동으로 입혀지는 Syntax Highlighting 기능을 제공하고 있습니다. 

<figure>
<img src="/images/2015-11-04/plain-text.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) syntax highlight 미적용
</figcaption>
</figure>

<figure>
<img src="/images/2015-11-04/html-extension.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
    (위) syntax highlight 적용
</figcaption>
</figure>

이 기능은 문법 구조 별로 다른 색상이 적용되고 그 색상의 대비가 크기 때문에 코드의 구조와 문법적 오류를 빠르게 파악할 수 있습니다. 실제로 코드 상의 오류를 찾는데 걸리는 시간을 줄여준다는 연구도 있습니다.[^1] Syntax highlighting로 인해 텍스트의 의미나 기능이 달라지는 것은 아니며 이것은 오로지 사람이 읽을 때의 편의성을 위한 장치입니다. 이 때 사용되는 컬러는 텍스트 에디터/테마 설정/사용자 설정에 따라 바뀔 수 있습니다.

### 1.Extension 설정 확인하기

우선 SublimeText 하단 우측(분홍색으로 표시된 부분)에 현재 쓰고 있는 파일 형식과 동일한 Extension이 설정되어 있는지 확인하세요.
<img src="/images/2015-11-04/extension-location.png" /> 

만약 기본값인 Plain text로 되어 있거나 다른 Extension으로 되어 있다면 알맞은 언어를 선택하여 알맞게 highlight되도록 하면 됩니다.
<img src="/images/2015-11-04/extension.png" />     

### 2.Package Control 설치하기

만약 기본 Extension에서 제공해주지 않는 언어라면 어떻게 해야할까요? 추가적으로 HTML과 CSS를 도와주는 보조 언어/라이브러리를 설치하여 작성하다보면 HTML나 CSS는 언어 구조에 따라 자동으로 컬러가 입혀져 입는 반면에 보조 언어로 쓰여진 부분은 아래 그림처럼 highlighting이 되어 있지 않습니다.
<figure>
<img src="/images/2015-11-04/just-html.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
(위) html 언어 사이에 html가 아닌 언어가 섞여 있다.
</figcaption>
</figure>

이것은 지정된 기존의 언어와 다르기 때문에 생기는 현상입니다. 이 경우에는 syntax highlighting을 도와주는 일종의 플러그인이라고 할 수 있는 Package Control을 설치하면 됩니다. 

<figure>
<img src="/images/2015-11-04/jinja-syntax.png"
     style="margin-right:auto; margin-left:auto;" />
<figcaption>
(위) html뿐만 아니라 다른 언어(jinja)에도 syntax highlighting이 적용되었다.
</figcaption>
</figure>

만약 Sass에 대한 syntax highlighting이 필요하다면 `sublime text syntax highlighting for Sass` 등의 키워드로 검색하면 설치 방법을 쉽게 찾으실 수 있습니다.(?) 지난 글에서 Material design 테마를 PackageControl을 통해 설치하는 방법을 소개해드렸으니 이해하는데 조금은 도움이 되실 겁니다.

[다시 읽기 - PackageControl 설치하기](http://spoqa.github.io)

## 보는 방식으로 코드 가독성 높이기 
- `view` - `word wrap column`

<img src="/images/2015-11-04/column-wrap.png"
     style="margin-right:auto; margin-left:auto;" />

코드에 따라 가로로 꽤 길어지는 경우가 있을 수 있습니다. 이를 한눈에 잘 볼 수 있도록 가상의 

- `view` - `layout`

<img src="/images/2015-11-04/column-wrap.png"
     style="margin-right:auto; margin-left:auto;" />

한번에 여러가지 문서 보면서 고쳐야 할 때 굉장히 유용한 기능입니다. 메뉴 하나씩 소개
이건이거고 저건저건데 나는 컬러2를 제일 많이 애용한다.

## 고치고 싶은 부분 쉽게 찾기

웹뷰로 되어 있는 부분의 스타일을 수정하려고 할 때에는 보통 아래의 절차로 진행합니다.

1. 웹 브라우저에서 요소 검사(Inspect Element)하여 고치고 싶은 부분을 찾는다.
2. Sublime Text에서 고쳐야 하는 부분을 찾아 코드를 수정한다.

1과 2의 사이에서 내가 고치고 싶은 코드를 어떻게 하면 빠르게 찾을 수 있을지 처음에는 알기 어려울 수 있습니다. 이를 테면 어느 파일 몇 번째 줄에 있는지, 찾아야 하는 코드가 두 군데 이상에 적용되어 있을 때 등의 경우에 고민이 생기게 될 것입니다. Sublime Text의 `Find`메뉴에서 제공하는 여러가지 검색 기능으로 해결할 수 있습니다. 

<img src="/images/2015-11-04/sublimetext-find-menu.png"
     style="margin-right:auto; margin-left:auto;" />   

그 중 제가 굉장히 자주 썼던 단축키 2가지를 소개합니다. 


- `command` + `F`

현재 보고 있는 파일 내에서 특정한 단어를 찾을 때 사용합니다.


- `command` + `shift` + `F`

Where에 쓰인 디렉토리 안에 있는 모든 파일에서 검색어가 있는 부분들을 검색합니다. 특정 부분이 어느 파일의 몇 번째 줄에 작성되어 있는지 모를 때 유용한 기능입니다.

<img src="/images/2015-11-04/sublimetext-find-in-files.png"
     style="margin-right:auto; margin-left:auto;" />   

검색어가 쓰여진 곳은 모두 검색 결과에 나오기 때문에 찾고자 여러 군데 쓰이는 단어보다는
찾고자하는 부분에만 쓰이는 클래스 이름 등을 작성하면 찾기가 더 쉽습니다.

검색결과 이미지 넣기 

이 외에도 많은 기능을 제공하고 있지만 이것들만 알아도 사용하는데 큰 무리가 없습니다.
빠른 코딩입문하십셔 ^^~ 행쇼~ 

[^1]: https://en.wikipedia.org/wiki/Syntax_highlighting
- 예시 코드 인용 http://jinja.pocoo.org/