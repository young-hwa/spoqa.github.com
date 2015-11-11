---
layout: entry
title: SublimeText 시작하기
author: yeun
author-email: yeun@spoqa.com
description: SublimeText를 설치하고 Package control을 사용해 테마를 적용해봅니다.
publish: true
---


오늘은 텍스트 편집기인 SublimeText를 설치하고 Package control을 사용해 테마를 적용해보는 과정을 설명하려고 합니다. SublimeText는 emacs나 vim보다 쉽고, 무료인 데다가 다른 텍스트 편집기들에 비해 예쁘기까지 하므로 스포카의 디자이너들이 애용하는 프로그램입니다. 꼭 스포카에서 뿐만 아니더라도 디자이너가 코드를 접하게 되면서 가장 먼저 필요한 프로그램이 SublimeText가 아닐까 생각합니다. 하지만 이 프로그램을 설치하기는 쉬워도 Package control을 사용해서 테마나, Syntax highlighting을 적용하는 것은 코드에 입문하는 디자이너에겐 다소 낯설 수 있습니다. 그런 디자이너들에게 조금이나마 도움이 되면 좋겠습니다.

## SublimeText 설치하기

1. [SublimeText 3 Beta 설치 페이지](http://www.sublimetext.com/3)에 접속해서 OS에 맞는 설치 파일을 다운받습니다. 정식 버전은 2.0.2가 최신이지만 SublimeText 3 Beta도 충분히 안정적이고 무엇보다도 아래에서 설치할 Material Theme를 비롯한 많은 확장 기능들이 SublimeText 3만 지원하기 때문에 Beta 버전을 받는 것이 좋습니다.

2. 다운받은 파일을 설치해서 실행합니다. 아래 화면과 같이 프로그램이 열린다면 정상적으로 설치가 끝났습니다.
<img src="/images/2015-11-11/sublime-default.png" style="margin: 0 auto; width: 752px;" />


## Package Control 설치하기

SublimeText에서 테마나 Syntax highlighting 등의 확장 기능을 손쉽게 설치하고 제거하기 위해 Package Control을 설치합니다. Adobe의 Extension Manager와 비슷한 개념입니다. 

1. [Package Control 웹사이트](https://packagecontrol.io/installation)에 접속합니다.

2. `SUBLIME TEXT 3` 용 코드를 복사합니다. *실제 코드는 아래 이미지와 다를 수 있습니다. 꼭 [Package Control 웹사이트](https://packagecontrol.io/installation)에 들어가셔서 코드를 복사해주세요.*
<img src="/images/2015-11-11/sublime-code.png" style="margin: 0 auto; width: 688px;" />

3. SublimeText에서 ```control+` ``` 를 누르거나 `View`>`Show Console`에 들어가서 콘솔 메뉴를 열고 복사한 내용을 붙여넣고 엔터를 칩니다.
<img src="/images/2015-11-11/sublime-console.png" style="margin: 0 auto; width: 752px;" />

4. 설치가 끝나면 아래 이미지와 같은 경고창이 뜹니다. 확인 버튼을 누릅니다.
<img src="/images/2015-11-11/sublime-popup.png" style="margin: 0 auto; width: 532px;" />

5. SublimeText를 재시동합니다. 

5. 메뉴의 `Preferences` > `Package Control`이 보이면 성공적으로 설치된 것입니다.
<img src="/images/2015-11-11/sublime-preferences.png" style="margin: 0 auto; width: 410px;" />

## Material Theme 적용하기

  1. [Material Theme 웹사이트](http://equinusocio.github.io/material-theme/)에 접속합니다.
    <img src="/images/2015-11-11/sublime-theme.png" style="margin: 0 auto; width: 1033px;">

  2. “INSTALL NOW” 버튼을 눌러 아래 페이지로 이동합니다.
    <img src="/images/2015-11-11/sublime-themeinstall.png" style="margin: 0 auto; width: 1043px;">

  3. 스크롤을 내려보면 중반부에 설치에 관한 내용이 있습니다.

        >**Easy installation**
        >
        >You can install this awesome theme through the Package Control. Search for “Material Theme”, install, restart SublimeText and enjoy!

        >**쉬운 설치법**
        >
        >Package Control에서 “Material Theme”를 검색한 뒤 설치하고 SublimeText를 재시동하면 테마를 즐길 수 있습니다.

  4. 다시 SublimeText로 돌아가서 메뉴의 `Preferences`>`Pakage Control`을 눌러 Panel을 엽니다. <img src="/images/2015-11-11/sublime-panel.png" style="margin: 0 auto; width: 752px">
  
  5. “Package Control: Install Package”를 선택합니다. 선택 직후 아무 변화가 없는 것 같지만 SublimeText의 하단 바를 보면 `[=   ]` 이렇게 생긴 로딩 바가 돌아가는 걸 볼 수 있습니다. <img src="/images/2015-11-11/sublime-install.png" style="margin: 0 auto; width: 752px">
  
  6. Panel에 설치할 수 있는 Package목록이 나타나면 `Material Theme`를 검색해서 선택합니다. <img src="/images/2015-11-11/sublime-search.png" style="margin: 0 auto; width: 752px">
  
  7. 테마가 설치되면 다음과 같은 메세지가 에디터 창에 나타납니다. 지금은 테마가 설치되었지만 적용되지는 않은 상태입니다. 계속해서 테마를 적용해봅시다. <img src="/images/2015-11-11/sublime-doc.png" style="margin: 0 auto; width: 752px">
  
  8. 메시지를 읽어보면 다음과 같은 내용이 나옵니다. 

        <pre><code>If installing manually (not through Package Control), add the following to your Settings - User file and restart Sublime Text after:
{
   "theme": "Material-Theme.sublime-theme",
   "color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",
}</code></pre>
  문서에는 수동으로 설치했을 경우에만 위 내용을 따르라고 쓰여 있지만, Package Control을 사용해서 설치해도 적용이 자동으로 되지는 않으므로 수동으로 적용해줘야 합니다. 
  적용할 코드를 복사합니다. 이때 중괄호는 복사하지 않습니다. 
        
        <pre><code>"theme": "Material-Theme.sublime-theme",
"color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",</code></pre>

  9. 메뉴의 `Preferences`로 들어가서 `Settings - User`를 눌러 설정 창을 엽니다. 
    <img src="/images/2015-11-11/sublime-user.png" style="margin: 0 auto; width: 410px;">
    <img src="/images/2015-11-11/sublime-pref.png" style="margin: 0 auto; width: 752px;">
  
  10. 8번에서 복사한 두 줄의 코드를 문서의 `{``}`안에 붙여넣습니다. 아래와 같이 붙여넣었다면 `command + s`를 눌러 저장합니다. 
  <img src="/images/2015-11-11/sublime-apply.png" style="margin: 0 auto; width: 752px;">
  혹시 붙여넣었는데 에러가 났다면 쉼표`,`가 제대로 쓰였는지 살펴봅니다. 줄마다 쉼표`,`로 구분하고 가장 마지막 줄에는 쉼표`,`를 쓰지 않으므로 위 이미지 상에서 

      <pre><code>"ignored_packages":
[
  "Vintage"
]</code></pre>
  밑에 붙여넣는다면, 아래와 같이 적어줘야 합니다. 

      <pre><code>"ignored_packages":
[
  "Vintage"
],
"theme": "Material-Theme.sublime-theme",
"color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme"</code></pre>
  
  11. 위 과정에서 `command + s`를 눌러 저장하면 바로 테마가 적용됩니다. 안정적으로 사용하기 위해 SublimeText를 한번 재부팅 해주면 모든 설치가 완료됩니다. 


## Material Theme 색상 바꾸고 스타일 조정하기

[Material Theme 웹사이트](http://equinusocio.github.io/material-theme/)에서 확인할 수 있듯이 Material Theme는 총 Default, Lighter, Darker 세 가지 버전을 제공합니다. 방금 설치한 테마를 Lighter 버전으로 바꾸고 줄 간격과 글자 크기 등을 더 보기 좋게 수정해봅시다.

  1. [Material Theme 설치 페이지](https://packagecontrol.io/packages/Material%20Theme)에 들어갑니다. 

  2. 스크롤을 내려 **Theme styles** 부분을 찾아서 아래 코드를 복사합니다. 

        <pre><code>"theme": "Material-Theme-Lighter.sublime-theme",
"color_scheme": "Packages/Material Theme/schemes/Material-Theme-Lighter.tmTheme",</code></pre>
    
  3. 메뉴의 `Preferences`로 들어가서 `Settings - User`를 눌러 설정 창을 엽니다.
    <img src="/images/2015-11-11/sublime-user.png" style="margin: 0 auto; width: 410px;">
  
  4. 위에서 Material Theme를 적용하기 위해 붙여넣은 코드를 방금 복사한 코드로 교체합니다.  

        <h5>기본  Material Theme용 코드</h5>

        <pre><code>"theme": "Material-Theme.sublime-theme",
"color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",</code></pre>

        <h5>Material Theme Lighter용 코드</h5>

        <pre><code>"theme": "Material-Theme-Lighter.sublime-theme",
"color_scheme": "Packages/Material Theme/schemes/Material-Theme-Lighter.tmTheme",</code></pre>

        두 코드를 비교해보면 Lighter 테마는 기본 테마 코드에 Lighter라는 이름이 추가된 것임을 알 수 있습니다. 
  
  5. `command + s`를 눌러 저장하면 아래 이미지처럼 테마가 변경됩니다. 
    <img src="/images/2015-11-11/sublime-lighter.png" style="margin: 0 auto; width: 752px;">
  
  6. 이번에는 텍스트 스타일을 조정해보려고 합니다. [Material Theme 설치 페이지](https://packagecontrol.io/packages/Material%20Theme)로 다시 들어가서 **Recommended UI and font settings for a better experience:** 부분을 찾아봅니다. 

  7. 코드를 복사해서 위에서 열어놓은 `Preferences.sublime-settings`문서에 붙여넣습니다. 

        <pre><code>"overlay_scroll_bars": "enabled",
"line_padding_top": 3,
"line_padding_bottom": 3,
"always_show_minimap_viewport": true,
"bold_folder_labels": true,
"indent_guide_options": [ "draw_normal", "draw_active" ],   // Highlight active indent
"font_options": [ "gray_antialias" ],                      // On retina Mac</code></pre>
  
  8. 마찬가지로 `command + s`를 눌러 저장하면 테마의 스타일이 변합니다. 
    <img src="/images/2015-11-11/sublime-ui.png" style="margin: 0 auto; width: 752px;">
  
  9. 폰트가 흐리게 보여서 가장 마지막 줄의 `"font_options": [ "gray_antialias" ]`을 지웠습니다. 
    <img src="/images/2015-11-11/sublime-regular.png" style="margin: 0 auto; width: 752px;">
  
  10. 원하는 크기대로 `"font_size"`와 `"line_padding_top"`, `"line_padding_bottom"`을 조정합니다. 

  11. 설정을 저장하고 SublimeText를 재시작합니다. 

---

잘 읽으셨나요? 디자이너분들이 조금 더 쉽게 코드에 입문할 수 있도록 관련 주제의 포스팅을 지속해서 올릴 예정입니다. 다음에는 기초적인 SublimeText 사용법으로 찾아뵙겠습니다. 읽어주셔서 감사합니다.




