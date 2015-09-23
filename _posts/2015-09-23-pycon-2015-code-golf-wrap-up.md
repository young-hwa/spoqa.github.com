---
layout: entry
title: "파이콘 한국 2015 코드 골프 되돌아보기"
author: kyu
author-email: kyu@spoqa.com
description: 파이콘 한국 2015 코드 골프 이벤트의 출품작들을 분석해 봅니다.
publish: true
---

안녕하세요. 스포카 개발팀의 박준규입니다.

저희 스포카는 [파이콘 한국 2015] 참가자들을 대상으로 코드 골프[^1] 이벤트를 진행하였습니다. 이 글에서는 제출된 코드들을 분석하고, 코드를 짧게 줄이기 위한 어떤 테크닉들이 사용되었는지를 알아 보겠습니다.

우선 코드 골프 문제에 대해서 알아보시려면, [GitHub 페이지]를 먼저 방문해 주세요.

## 채점과 출제 의도

이 문제는 _데이터를 얼마나 효율적으로 압축할 수 있는지_ 를 보기 위해서 출제하였습니다.

CI 채점[^2]에 사용되는 스크립트인 `test.py` 파일을 분석해 보신 분들이라면 눈치를 채셨겠지만, 출력 결과는 예시와 완벽히 일치할 필요가 없게 되어 있습니다. 약간의 융통성을 허용하여 코드를 더욱 줄일 수 있도록 하기 위함입니다. 일종의 [손실 압축]인 셈이죠. 실제로 순위권 내의 코드들은 모두 `test.py`의 이러한 특성을 이용하고 있었습니다.

## 사례 연구

### 기성 압축 알고리즘

가장 쉽게 생각해볼 수 있는 방법입니다. `zlib.compress`, `bz2.compress` 같은 내장 함수로 데이터를 압축하는 방식입니다. [일찍 제출된 커밋](https://github.com/sublee/spoqa-pycon-2015-codegolf/commit/5a0cc0ec303594b4dcbc15acfd7d28b9d122285a) 중에 이 방법을 사용하는 코드가 많았습니다.

`zlib.compress`로는 데이터를 183바이트, `bz2.compress` 함수로는 데이터를 223바이트까지 줄일 수 있었습니다. 원래 데이터가 3kb에 육박하던 것을 감안하면 손쉬운 방법으로 상당한 압축률을 얻어낸 셈이죠. 일반적으로 bzip2가 zlib에 사용되는 [DEFLATE] 알고리즘보다 압축 효율이 더 좋은 것으로 알려져 있지만, 신기하게도 이 경우에는 zlib이 좀 더 나은 압축 효율을 보이고 있습니다.

하지만 zlib과 bzip2은 일반적인 데이터를 압축하기 위한 범용 알고리즘입니다. 우리는 데이터의 특성을 이미 알고 있습니다. 모든 경우를 위한 범용적인 압축 알고리즘 대신에 특화된 알고리즘을 통해서 좀 더 나은 압축률을 달성할 수 있지 않을까요?

### Latin-1

하지만 zlib이나 bzip2로 압축한 데이터를 소스 코드에 넣으려면 문제가 생깁니다.

    SyntaxError: Non-ASCII character '\xea' in file test.py on line 1, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details

위와 같은 에러가 나옵니다. 압축된 데이터는 8비트 바이너리이기 때문에 소스코드에 넣을 수가 없는 것입니다. 기본적으로 파이썬은 소스 코드가 [ASCII] 인코딩이라고 가정하기 때문에, 7비트 영역을 벗어나는 문자가 소스 코드 안에 포함되면 에러가 납니다.

일반적으로 생각할 수 있는 방법은 이 바이너리 데이터를 [Base64]로 인코딩하는 것입니다. 바이너리 데이터를 base64로 인코딩하면 알파뉴머릭<sub>alphanumeric</sub>으로 표현할 수 있기 때문에 소스 코드에 넣을 수 있는 형태가 됩니다. 하지만 이 방식은 데이터에 33%의 오버헤드를 추가합니다. 게다가 `import base64`와 `base64.b64decode()`와 같이 코드의 양을 불리는 호출이 추가됩니다.

하지만 파이썬에는 소스 코드의 인코딩을 지정할 수 있는 `coding:` directive가 있습니다.

    # coding: latin1

소스 코드 첫줄에 위와 같이 소스 코드의 인코딩을 설정해주면 기본 인코딩인 ASCII 대신에 [Latin-1] [^3] 인코딩을 사용하기 때문에 Base64를 사용하지 않고도 바이너리 데이터를 저장할 수 있게 됩니다. 게다가 @[ipkn]님의 [코드](https://github.com/ipkn/spoqa-pycon-2015-codegolf/blob/36d9093fc8d5755d26098023c2ee1e9eca294ad7/pupu.py)을 보면 `latin1`을 `L1`으로 줄이는 것도 가능한 모양이군요…

### 유전 알고리즘

이번 코드 골프에서 (코드의 길이와 상관없이) 가장 창의적인 솔루션을 꼽으라고 하면 @[stewartpark]님의 [코드](https://github.com/stewartpark/spoqa-pycon-2015-codegolf)를 꼽고 싶습니다. 기본적으로 zlib 압축한 데이터를 Latin1로 표현한다는 아이디어는 동일하지만 손실 압축이 허용된다는 점을 이용하여 허용 한도 내에서 zlib으로 최적의 압축률을 낼 수 있도록 __유전 알고리즘을 통해 데이터를 변형__ 시켰다는 점이 다릅니다.

[구현](https://github.com/stewartpark/spoqa-pycon-2015-codegolf/blob/master/nat_sel.py)에 따르면, 유전 알고리즘의 과정은 이렇습니다.

1. 알파(선택된 유전자[^4])와 알파 후보는 원본 이미지에서 출발합니다.
1. 한 세대 내에서 알파 유전자와 알파 후보 유전자를 각각 10번씩 변이시킵니다.[^5]
1. 알파와 변이된 유전자 20개 중에서 zlib으로 최적의 압축률을 보이는 유전자 두개가 새로운 알파와 알파 후보가 됩니다. 심하게 변형되어 테스트를 통과하지 못하는 결과는 도태됩니다.
1. 다음 세대로 넘어가서 2로 돌아갑니다.

이 과정을 반복하여 최적의 압축률을 보이는 데이터를 얻을 수 있는데, 이 방식으로 데이터를 244바이트까지 줄일 수 있었던 것으로 보입니다.


### RLE (Run-Length Encoding)

[RLE]는 반복되는 문자의 빈도를 표기하는 방식입니다. 코드 골프에 제출된 코드의 대부분이 이 개념을 응용한 것입니다.

먼저 데이터의 특성을 관찰하면 몇 가지 최적화 지점을 찾을 수 있습니다.

* 데이터는 공백과 별로 이루어져 있다 — 즉 각 픽셀은 1 비트입니다. 실질적으로 데이터는 두 가지 상태 사이에서 토글<sub>toggle</sub>될 뿐입니다. 즉 일반적인 RLE와 달리 __어떤 값이 들어가는지에 대한 정보는 필요하지 않고 각 상태가 총 몇 번의 빈도를 가지는지__ 에 대해서만 기록하면 됩니다.
* 데이터는 실질적으로 2차원 이미지다 — 각 행마다 열 수가 정해져 있으므로 줄바꿈 정보를 데이터에 포함시키지 않아도 됩니다.
* 한 글자의 가닥<sub>strand</sub>은 128바이트를 넘지 않는다 — 하나의 시퀸스는 하나의 아스키 글자로 표현할 수 있습니다.

이 점을 이용하면 데이터의 길이를 가능한 최소로 유지할 수 있습니다. 남은 것은 데이터를 `test.py`가 허용하는 한도 내에서 최대한 손실 압축하고 데이터를 디코딩, 출력하는 코드를 최대한 짧게 작성하는 것입니다.

이 방식을 응용하여 제출된 코드입니다.

* @[if1live]님의 [코드](https://github.com/if1live/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (308b) — 데이터에 줄바꿈 문자(`~`)가 포함되어 있는 형태입니다. 디코딩하면서 각 문자에 대한 빈도만큼 버퍼에 쌓고 공백/별표 상태를 전이한 뒤에 `~`를 만나면 버퍼를 출력하고 줄바꿈을 합니다.
* @[JosephDev]님의 [코드](https://github.com/JosephDev/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (729b) — 비슷한 방식입니다. 다른 점은 데이터가 문자열로 인코딩되어 있지 않고, 줄바꿈 문자가 숫자 0이라는 것입니다.
* @[yjroot]님의 [코드](https://github.com/yjroot/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (288b) — 원본 데이터에서 손실 없이 달성한 가장 짧은 코드입니다. 특이한 점이 있다면, 루프 인덱스<sub>loop index</sub>의 홀수/짝수 여부를 통해 공백과 별표 상태를 전이하는 것이 아니라, 루프 안에서 공백과 별표가 한 쌍을 이루는 형태입니다. 줄바꿈 정보는 `n` 변수에 비트 필드<sub>bit field</sub>로 정의되어 있어서 매 루프에서 줄바꿈을 할지에 대한 여부를 결정하게 됩니다.
* @[ganadist]님의 [코드](https://github.com/ganadist/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (835b) — 특별한 미니피케이션<sub>minification</sub> 없이 RLE의 개념을 직관적으로 보여주는 코드입니다.
* @[innover]님의 [코드](https://github.com/innover/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (218b) — 이 코드에는 줄바꿈 정보가 데이터에 포함되어 있지 않습니다. 우선 데이터를 디코딩하여 문자열을 만들고 `range()`로 72바이트 단위로 끊어서 출력하는 형태입니다.
* @[haje01]님의 [코드](https://github.com/haje01/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (393b) — yjroot님의 코드와 비슷하게 데이터를 한 쌍씩 읽어서 한 루프 내에서 공백과 별표를 같이 출력합니다. 데이터 안에 줄넘김 문자가 포함되어 있는데, 줄넘김 문자는 공백입니다.
* @[qwerty1917]님의 [코드](https://github.com/qwerty1917/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (589b) — 빈도가 아스키 숫자로 인코딩되어 있습니다. 데이터에 상태 토글을 위한 이스케이프 문자(`g`)가 별도로 할당되어 있습니다. 줄바꿈 문자는 `h`입니다.
* @[astralhpi]님의 [코드](https://github.com/astralhpi/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (238b) — 데이터가 8비트 바이너리로 인코딩되어 있습니다. 특이한 점은, 한 바이트 안에 빈도 정보와 줄바꿈 정보가 같이 포함되어 있다는 것인데, 공백 여부는 해당 바이트가 140을 초과하는지 여부로 판단하고 빈도 값은 70을 나눈 나머지를 취합니다.
* @[kumjiki]님의 [코드](https://github.com/kumjiki/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (353b) — 위에서 소개한 방식들과 비슷합니다. 다른 점은 줄바꿈 문자가 `0`이라는 것이겠군요.
* @[wookayin]님의 [코드](https://github.com/wookayin/spoqa-pycon-2015-codegolf/blob/submission/pupu.py) (194b) — 이번 코드골프의 우승자입니다.[^6] 알고리즘은 다른 코드와 비슷하지만, 이 이상으로 줄일 수 있을까 싶을 정도로 코드가 잘 줄여져 있습니다. 변수 초기화부터 시작해서, 모든 줄이 공백으로 시작해서 공백으로 끝나는 데이터의 특성을 이용하여 다음 줄로 넘어갈 때 `R=z` 세 글자로 버퍼를 초기화하는 등의 최적화 센스가 돋보였습니다.
* @[EcmaXp]님의 [코드](https://github.com/EcmaXp/spoqa-pycon-2015-codegolf/blob/master/pupu.py) (229b) — 일반적인 (공백, 별표)가 아니라 (_공백, 별표, 줄바꿈 후 공백_)이라는 세가지 상태<sub>tri-state</sub>를 회전하는 형태로 데이터가 인코딩되어 있습니다.

### 그 외 솔루션들

* @[joykunnia]님의 [코드](https://github.com/joykunnia/spoqa-pycon-2015-codegolf/blob/master/pupu.py)는 일종의 [딕셔너리 코더] 알고리즘이라고 볼 수 있습니다. `list1`이 딕셔너리, `list2`가 딕셔너리를 참조하는 압축 데이터입니다.
* 전혀 예상하지 못했던 솔루션을 발견하는 것이야말로 코드 골프의 묘미겠죠. @[dittos]님의 [커밋](https://github.com/dittos/spoqa-pycon-2015-codegolf)은 소스 코드를 한 줄도 고치지 않고 297바이트를 달성했는데, 파이썬 인터프리터는 zip으로 압축된 코드도 실행할 수 있다는 점을 이용한 것입니다.
* `import test;print(test.EXAMPLE)` 등등의 코드들 — 아쉽지만 탈락입니다. 땡.


## 맺으며

이상으로 코드 골프에 제출된 코드들을 하나씩 살펴보았습니다. 이번 이벤트에 응모해주신 모든 분께 감사의 말씀을 드립니다.

그리고 내년 파이콘에서도 재미있는 이벤트로 찾아뵙겠습니다. 감사합니다!

__추신__ : 저희 스포카에서 재능있는 개발자를 모십니다. 페이지 상단의 _채용 공고_ 를 확인해 주세요!


  [파이콘 한국 2015]: http://www.pycon.kr/2015/
  [GitHub 페이지]: https://github.com/spoqa/spoqa-pycon-2015-codegolf
  [손실 압축]: https://ko.wikipedia.org/wiki/%EC%86%90%EC%8B%A4_%EC%95%95%EC%B6%95
  [DEFLATE]: https://en.wikipedia.org/wiki/DEFLATE
  [Base64]: https://ko.wikipedia.org/wiki/%EB%B2%A0%EC%9D%B4%EC%8A%A464
  [ASCII]: https://ko.wikipedia.org/wiki/%EB%AF%B8%EA%B5%AD%EC%A0%95%EB%B3%B4%EA%B5%90%ED%99%98%ED%91%9C%EC%A4%80%EB%B6%80%ED%98%B8
  [Latin-1]: https://en.wikipedia.org/wiki/ISO/IEC_8859-1
  [RLE]: https://ko.wikipedia.org/wiki/%EB%9F%B0_%EB%A0%9D%EC%8A%A4_%EB%B6%80%ED%98%B8%ED%99%94
  [딕셔너리 코더]: https://ko.wikipedia.org/wiki/%EC%82%AC%EC%A0%84_%EA%B8%B0%EB%B0%98_%EB%B6%80%ED%98%B8%ED%99%94
  [ipkn]: https://github.com/ipkn
  [stewartpark]: https://github.com/stewartpark
  [dittos]: https://github.com/dittos
  [if1live]: https://github.com/if1live
  [JosephDev]: https://github.com/JosephDev
  [yjroot]: https://github.com/yhroot
  [ganadist]: https://github.com/ganadist
  [innover]: https://github.com/innover
  [haje01]: https://github.com/haje01
  [qwerty1917]: https://github.com/qwerty1917
  [astralhpi]: https://github.com/astralhpi
  [kumjiki]: https://github.com/kumjiki
  [wookayin]: https://github.com/wookayin
  [EcmaXp]: https://github.com/EcmaXp
  [joykunnia]: https://github.com/joykunnia


  [^1]: 어떤 작업을 수행하는 코드를 _최대한 짧게_ 작성하는 경쟁입니다.

  [^2]: Pull Request를 보내면 CI가 채점을 하도록 되어 있습니다.

  [^3]: Latin-1 인코딩은 ASCII와 달리 8비트 전체를 사용합니다.

  [^4]: 여기서 유전자(gene)의 개념은 이미지에 대응합니다.

  [^5]: 유전자에 대한 변이란 랜덤한 픽셀을 변형하는 방식으로 이루어집니다. 알파는 총 3개의 픽셀을, 알파 후보는 6개의 픽셀을 변형합니다.

  [^6]: 유일하게 200바이트 아래로 내려간 코드이기도 합니다. 개인적으로 200바이트 아래로 내려가리라고는 상상도 못 했습니다…
