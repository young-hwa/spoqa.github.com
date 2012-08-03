---
layout: entry
title: 파이썬 코딩 컨벤션
author: 문성원
author-email: longfin@spoqa.com
description: PEP 8을 통해 파이썬 코딩 컨벤션을 알아봅니다.
---

스포카 개발팀 문성원입니다. 저희는 (익히 아시다시피) 서버를 개발하는데 [파이썬(Python)][Python]을 사용하고 있는데, 오늘은 이러한 파이썬 코드를 작성할 때 기준이 되는 [코딩 컨벤션(Coding Convention)][Coding Convention]에 대해서 알아보겠습니다.

# Coding Convention

[코딩 컨벤션][Coding Convention]이란 개념에 대해 생소하신 분들도 계실 테니 이를 먼저 알아보죠. 코딩 컨벤션은 프로그램 코드를 작성할 때 사용되는 일종의 기준입니다. 이를테면 들여쓰기(Indentation)는 공백으로 할거냐 탭으로 할거냐. 부터 <code>var a = 3;</code> 과 같은 코드에서 <code>a</code>와 <code>=</code>를 붙이느냐 마느냐라던지를 정해주는 것이죠. 알고 계시는 것처럼 이러한 차이는 특별히 실행 결과의 영향을 주지 않습니다. 다르게 이야기하자면 "실행 결과에 별 차이가 없는 선택지들"이기 때문에 일관성이 있는 기준을 두어 통일하자는 것이지요.

그렇다면 왜 이런 선택지를 통일해야 할까요? 불행히도 우리가 작성한 코드는 많은 사람들이 보게 됩니다. 같이 일하는 동료, 이바지하고 있는 프로젝트의 리뷰어, 심지어 내일의 자기 자신까지도 말이죠. 그런데 이런 많은 사람들이 우리가 코드를 작성할 때 했던 선택지를 일일이 추론해서 이해하는 건 굉장히 피곤하고 짜증 나는 일입니다. 그래서 우리는 사소한 것부터 일종의 규칙을 정해서 이런 짜증과 불편함을 줄이려는 겁니다. 또한, 일반적으로 좋은 기준에는 훌륭한 프로그래머들의 좋은 습관이 배어있기 때문에 더 나은 품질의 코드를 작성하는 데에도 많은 도움이 됩니다. 

이런 코딩 컨벤션은 극단적으로 이야기하면 프로젝트마다 하나씩 존재한다고 볼 수도 있지만, 일반적으로 그 언어문화를 공유하는 공동체에서 인정하는 컨벤션은 대부분 통일되어 있습니다. 파이썬은 지금부터 살펴볼 [PEP 8]이 대표적입니다.

# PEP?

[PEP(Python Enhance Proposal)][PEP]이란 이름대로 본디 파이썬을 개선하기 위한 개선 제안서를 뜻합니다. 이러한 제안서는 새로운 기능이나 구현을 제안하는 Standard Track, (구현을 포함하지 않는) 파이썬의 디자인 이슈나 일반적인 지침, 혹은 커뮤니티에의 정보를 제안하는 Informational, 그리고 파이썬 개발 과정의 개선을 제안하는 Process의 3가지로 구분할 수 있습니다. (좀 더 자세한 사항은 [PEP]에 대해 다루고 있는 [PEP]인 [PEP 1](http://www.python.org/dev/peps/pep-0001)을 참고하세요.) 파이썬은 언어의 컨벤션을 이러한 제안서(Process)로 나타내고 있는데 이것이 바로 [PEP 8]입니다.

# Laplace's Box

기본적으로 가이드라인이니만큼 규칙만 빽빽할 것 같지만, [PEP 8]는 서두부터 [예외를 언급한 섹션](http://www.python.org/dev/peps/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds)이 있습니다.

> A style guide is about consistency. Consistency with this style guide is important. Consistency within a project is more important. Consistency within one module or function is most important.

> 스타일 가이드는 일관성(consistency)에 관한 것입니다. 이 스타일 가이드의 일관성은 중요하죠. 하지만 프로젝트의 일관성은 더욱 중요하며, 하나의 모듈이나 함수의 일관성은 더더욱 중요합니다.

> But most importantly: know when to be inconsistent -- sometimes the style guide just doesn't apply. When in doubt, use your best judgment. Look at other examples and decide what looks best. And don't hesitate to ask!

> 하지만 가장 중요한 건 언제 이것을 어길지 아는 것입니다. -- 때때로 스타일 가이드는 적용되지 않습니다. 의심이 들 때는 여러분의 최선의 판단을 따르세요. 다른 예제를 보고 어느 게 제일 나은지 골라야 합니다. 질문을 주저하지 마세요!


> Two good reasons to break a particular rule:

> 1. When applying the rule would make the code less readable, even for someone who is used to reading code that follows the rules.
> 2. To be consistent with surrounding code that also breaks it (maybe for historic reasons) -- although this is also an opportunity to clean up someone else's mess (in true XP style).

> 다음은 규칙들을 어기는 2가지 좋은 예외 사항입니다.

> 1. 규칙을 적용한 코드가 (규칙을 숙지한 사람 눈에도) 읽기 어려운 경우
> 2. 일관성을 지키려고 한 수정이 다른 규칙을 어기는 경우(아마도 역사적인 이유겠죠.) 

아직 아무것도 안나왔는데 좀 이르다구요?

# It's all about common sense

예외 규정을 보여주며 시작하는 [PEP 8]이지만 얼개는 그리 복잡하지도 않고 크게 난해하지도 않습니다. 여기서는 대표적인 몇 가지만 추려서 소개하겠습니다. 

## [Code lay-out](http://www.python.org/dev/peps/pep-0008/#code-lay-out)

- 들여쓰기는 공백 4칸을 권장합니다.
- 한 줄은 최대 79자까지
- 최상위(top-level) 함수와 클래스 정의는 2줄씩 띄어 씁니다.
- 클래스 내의 메소드 정의는 1줄씩 띄어 씁니다.

## [Whitespace in Expressions and Statements](http://www.python.org/dev/peps/pep-0008/#whitespace-in-expressions-and-statements)

- 다음과 같은 곳의 불필요한 공백은 피합니다.
    - 대괄호([])와 소괄호(())안
    - 쉼표(,), 쌍점(:)과 쌍반점(;) 앞
- 키워드 인자(keyword argument)와 인자의 기본값(default parameter value)의 <code>=</code> 는 붙여 씁니다.
 
## [Comments](http://www.python.org/dev/peps/pep-0008/#comments)

- 코드와 모순되는 주석은 없느니만 못합니다. 항상 코드에 따라 갱신해야 합니다.
- 불필요한 주석은 달지 마세요.
- 한 줄 주석은 신중히 다세요.
- [문서화 문자열(Docstring)][Docstring]에 대한 컨벤션은 [PEP 257](http://www.python.org/dev/peps/pep-0257/)을 참고하세요.

## [Naming Conventions](http://www.python.org/dev/peps/pep-0008/#naming-conventions)

- 변수명에서 \_(밑줄)은 위치에 따라 다음과 같은 의미가 있습니다.
    - \_single\_leading\_underscore: 내부적으로 사용되는 변수를 일컫습니다.
    - single\_trailing\_underscore\_: 파이썬 기본 키워드와 충돌을 피하려고 사용합니다.
    - \_\_double\_leading\_underscore: 클래스 속성으로 사용되면 그 이름을 변경합니다. (ex. FooBar에 정의된 \_\_boo는 \_FooBar\_\_boo로 바뀝니다.)
    - \_\_double\_leading\_and_trailing\_underscore\_\_: [마술(magic)](http://en.wikipedia.org/wiki/Magic_\(programming\))을 부리는 용도로 사용되거나 사용자가 조정할 수 있는 네임스페이스 안의 속성을 뜻합니다. 이런 이름을 새로 만들지 마시고 오직 문서대로만 사용하세요.
- 소문자 L, 대문자 O, 대문자 I는 변수명으로 사용하지 마세요. 어떤 폰트에서는 가독성이 굉장히 안 좋습니다.
- 모듈(Module) 명은 짧은 소문자로 구성되며 필요하다면 밑줄로 나눕니다.
    - 모듈은 파이썬 파일(.py)에 대응하기 때문에 파일 시스템의 영향을 받으니 주의하세요.
    - C/C++ 확장 모듈은 밑줄로 시작합니다.
- 클래스 명은 [카멜케이스(CamelCase)](http://en.wikipedia.org/wiki/CamelCase)로 작성합니다. 
    - 내부적으로 쓰이면 밑줄을 앞에 붙입니다.
    - 예외(Exception)는 실제로 에러인 경우엔 "Error"를 뒤에 붙입니다.
- 함수명은 소문자로 구성하되 필요하면 밑줄로 나눕니다. 
    - 대소문자 혼용은 이미 흔하게 사용되는 부분에 대해서만 하위호환을 위해 허용합니다.
- 인스턴스 메소드의 첫 번째 인자는 언제나 <code>self</code>입니다.
- 클래스 메소드의 첫 번째 인자는 언제나 <code>cls</code>입니다.
- 메소드명은 함수명과 같으나 비공개(non-public) 메소드, 혹은 변수면 밑줄을 앞에 붙입니다.
- 서브 클래스(sub-class)의 이름충돌을 막기 위해서는 밑줄 2개를 앞에 붙입니다.
- 상수(Constant)는 모듈 단위에서만 정의하며 모두 대문자에 필요하다면 밑줄로 나눕니다.

## [Programming Recommendations](http://www.python.org/dev/peps/pep-0008/#programming-recommendations)

- 코드는 될 수 있으면 어떤 구현(PyPy, Jython, IronPython등)에서도 불이익이 없게끔 작성되어야 합니다.
- <code>None</code>을 비교할때는 <code>is</code>나 <code>is not</code>만 사용합니다.
- 클래스 기반의 예외를 사용하세요.
- 모듈이나 패키지에 자기 도메인에 특화된(domain-specific)한 기반 예외 클래스(base exception class)를 빌트인(built-in)된 예외를 서브클래싱해 정의하는게 좋습니다. 이 때 클래스는 항상 문서화 문자열을 포함해야 합니다.

{% highlight python %}
class MessageError(Exception):
    """Base class for errors in the email package."""
{% endhighlight %}

- <code>raise ValueError('message')</code>가 (예전에 쓰이던) <code>raise ValueError, 'message'</code> 보다 낫습니다. 
- 예외를 <code>except:</code>로 잡기보단 명확히 예외를 명시합니다.(ex. <code>except ImportError:</code>
- <code>try:</code> 블록의 코드는 필요한 것만 최소한으로 작성합니다.
- <code>string</code> 모듈보다는 <code>string</code> 메소드를 사용합니다. 메소드는 모듈보다 더 빠르고, 유니코드 문자열에 대해 같은 API를 공유합니다.
- 접두사나 접미사를 검사할 때는 <code>startswith()</code>와 <code>endwith()</code>를 사용합니다.
- 객체의 타입을 비교할 때는 <code>isinstance()</code>를 사용합니다.
- 빈 시퀀스(문자열, 리스트(list), 튜플(tuple))는 조건문에서 거짓(false)입니다.
- 불린형(boolean)의 값을 조건문에서 <code>==</code>를 통해 비교하지 마세요.

# Give me a reason

하지만 몇몇 규칙은 그 자체만으론 명확한 이유를 찾기 어려운 것도 있습니다. 가령 예를 들면 이런 규칙이 있습니다.

> More than one space around an assignment (or other) operator to align it with another.

Yes:
<quote>
{% highlight python %}
x = 1
y = 2
long_variable = 3
{% endhighlight %}
</quote>
No:
{% highlight python %}
x             = 1
y             = 2
long_variable = 3
{% endhighlight %}

보통 저런 식으로 공백을 통해 <code>=</code>를 맞추는 건 보기에도 좋아 보입니다. 하지만 [변수가 추가되는 경우에는 어떨까요.](http://blog.dahlia.kr/post/18035893350) 변수가 추가 될때마다 공백을 유지하기 위해 불필요한 변경이 생깁니다. 이는 소스를 병합(merge)할 때 혼란을 일으키기 쉽습니다.

언뜻 보면 잘 이해가 안 가는 규칙은 이런 것도 있습니다.

> Imports should usually be on separate lines, e.g.:
{% highlight python %}
Yes: import os
     import sys
No:  import sys, os
{% endhighlight %}

굳이 한 줄씩 내려쓰면 길어지기만 하고 보기 안 좋지 않을까요? 하지만 이 역시 [대부분의 변경 추적 도구가 행 기반임을 고려하면 그렇지 않습니다.](http://stackoverflow.com/questions/9125169/why-pep8-states-imports-should-usually-be-on-separate-lines) 

  [Python]: http://www.python.org/
  [PEP]: http://www.python.org/dev/peps/
  [PEP 8]: http://www.python.org/dev/peps/pep-0008/
  [Coding Convention]: http://en.wikipedia.org/wiki/Coding_conventions
  [Docstring]: http://en.wikipedia.org/wiki/Docstring
