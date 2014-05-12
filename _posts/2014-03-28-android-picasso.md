---
layout: entry
title: Picasso 파헤치기
author: 정현우
author-email: hyunwoo@spoqa.com
description: Android Image Loading Library 중 하나인 Picasso 에 대해 알아봅니다.
---

안녕하세요. 스포카 개발팀의 정현우입니다. 저희 안드로이드 모바일앱이 세 번째 버전으로 업데이트되면서 외적(사용자 측면)으로나 내적(구현 측면)으로 많은 변화가 있었는데요. 내적인 변화 중 하나는 검증된 오픈소스 라이브러리들을 많이 사용했다는 점입니다. 그중에 하나인 [Picasso][picasso website]에 관해 얘기해 보려고 합니다.

[picasso website]: http://square.github.io/picasso/


What is Picasso?
----------------

안드로이드에서 여러 이미지가 화면에 나열 되는 UI는 자주 쓰이고 있습니다. 많은 개발자가 이것을 편리하게 하려고 라이브러리를 제작하여 공개했습니다. Picasso는 그 중에 하나로써 [Square][] 사의 [Jake Wharton][]이 개발한 라이브러리입니다.

[Square]: http://square.github.io/
[Jake Wharton]: https://github.com/JakeWharton

Why Picasso?
------------

직접 수많은 라이브러리를 비교해보지는 못했고 대신 Hello World 블로그의 [Android의 이미지 로딩 라이브러리][1]를 참고했습니다. Picasso를 선택한 이유는 다음과 같습니다.

1. 모듈화가 잘 되어있어서 확장에 용이하다
2. API가 간결하다
3. <del>Jake Wharton이 개발했다</del>

[1]: http://helloworld.naver.com/helloworld/429368

Dive into Picasso
-----------------

Picasso가 작동하는 방식과 중요한 클래스들을 살펴보도록 하겠습니다. (소스는 [v2.2.0][2]을 기준으로 합니다.)

![workflow][]

[2]: https://github.com/square/picasso/commit/f78c6b989d365b4bbe32f05bfd618f731aac30f9

[workflow]: /images/2014-03-28/1.png

### 1. 이미지 불러오기 요청

이미지를 불러오기 위해 [`Picasso`][picasso]를 사용합니다. 간단한 용례는 다음과 같습니다.

	Picasso.with(context)
	       .load(placeImageUrl)
	       .error(R.drawable.error)
	       .placeholder(R.drawable.placeholder)
	       .transform(myTransformer)
	       .into(placeImageView);

### 2. 캐시 검사

[Picasso](#picasso)는 [`Cache`][cache] 인터페이스를 통해 캐시를 저장하고 가져옵니다. 만약 캐시에 요청한 이미지가 존재하면 캐시를 사용합니다.

### 3–4. 백그라운드로 스레드에서 이미지 불러오기

[`Cache`][cache]에 캐시된 이미지가 없다면 [`Dispatcher`][dispatcher]를 통해 백그라운드 스레드에서 [`BitmapHunter`][bitmaphunter]가 이미지를 불러올 수 있도록 합니다.

### 5. 캐시 검사 및 이미지 불러오기

다시 한 번 캐시를 검사합니다. 이때 캐시된 이미지가 있으면 그걸 사용합니다. 없다면 [`BitmapHunter`][bitmaphunter] 인터페이스는 실제 구현에 따라 이미지 불러오게 됩니다. [`BitmapHunter`][bitmaphunter]의 구현체가 NetworkBitmapHunter인 경우 [`Downloader`][downloader] 인터페이스를 통해 이미지를 내려받습니다.

### 6. 이미지 후처리

[`BitmapHunter`][bitmaphunter]가 이미지를 불러오면 [`Transformer`][transformer] 인터페이스를 통해 이미지 후처리를 할 수 있도록 합니다.

### 7–8. 불러온 이미지 적용

이미지 불러오기를 마친 [`BitmapHunter`][bitmaphunter]는 다시 [`Dispatcher`][dispatcher]를 통해 UI 스레드로 비트맵을 전달합니다. [`Dispatcher`][dispatcher]는 비트맵을 [`Action`][action] 인터페이스로 구현된 방식으로 이미지를 처리합니다.

이렇게 Picasso는 단계별로 인터페이스를 두고 확장 가능하도록 구현되어 있습니다. 필요에 따라 캐시 방식을 바꾸고 싶다면 [`Cache`][cache] 인터페이스를 구현하고 이미지 후처리 방식을 바꾸고 싶다면 [`Transformer`][transformer] 인터페이스를 구현하면 됩니다. 별도로 구현하지 않으면 이미 정의된 구현체들이 각 단계별로 사용됩니다.

[picasso]: #picasso
[dispatcher]: #dispatcher
[cache]: #cache
[bitmaphunter]: #bitmaphunter
[downloader]: #downloader
[transformer]: #transformer
[action]: #action


Appendix
--------

<h3 id="picasso">com.squareup.picasso.Picasso(<a href="http://square.github.io/picasso/javadoc/index.html">javadoc</a>)</h3>

Picasso로 이미지를 불러올 때 사용하게되는 빌더입니다. `RequestCreator`와 함께 [Method Chaining][] 혹은 [Builder Pattern][]로 불리는 방법으로 API를 간결하게 사용 할 수 있도록 합니다.

[Method Chaining]: http://en.wikipedia.org/wiki/Method_chaining
[Builder Pattern]: http://en.wikipedia.org/wiki/Builder_pattern
[picasso.javadoc]: http://square.github.io/picasso/javadoc/index.html


<h3 id="dispatcher">com.squareup.picasso.Dispatcher</h3>

백그라운드 스레드와 UI 스레드 간에 통신하게되는 통로입니다. [`Picasso`][picasso]에서 요청 데이터를 전달 받아 Background 에서 [`BitmapHunter`][bitmaphunter]가 비트맵을 불러올 수 있도록 합니다. 비트맵을 UI 스레드에 전달해서 처리할 수 있도록 합니다.

<h3 id="cache">com.squareup.picasso.Cache(<a href="http://square.github.io/picasso/javadoc/com/squareup/picasso/Picasso.html">javadoc</a>)</h3>

이미지 캐싱을 위한 모듈입니다. 기본 구현체로는 [LRU][] 방식으로 캐시하는 `LruCache`가 사용됩니다.

[LRU]: http://en.wikipedia.org/wiki/Least_Recently_Used#LRU

<h3 id="bitmaphunter">com.squareup.picasso.BitmapHunter</h3>

비트맵을 불러오는 모듈입니다. 자주 사용되는 구현체로는 `ResourceBitmapHunter`와 `NetworkBitmapHunter`가 있습니다.

 `Picasso.load()`메소드에 리소스 아이디를 넘겨주면 `ResourceBitmapHunter`가 사용되고 [Uri][]를 넘겨주면 [URI Scheme][]에 따라서 `NetworkBitmapHunter`, `ContentProviderBitmapHunter`, `AssetBitmapHunber` 등이 사용됩니다. (자세한 내용은 `BitmapHunter.forRequest`메소드에 구현되어 있습니다.)

[Uri]: http://developer.android.com/reference/android/net/Uri.html
[URI Scheme]: http://en.wikipedia.org/wiki/URI_scheme

<h3 id="downloader">com.squareup.picasso.Downloader(<a href="http://square.github.io/picasso/javadoc/com/squareup/picasso/Downloader.html">javadoc</a>)</h3>

`NetworkBitmapHunter`가 이미지를 내려받을 때 사용하는 인터페이스입니다. 기본 구현체는 [OkHttp][]를 사용할 수 있는지 여부에 따라 다릅니다.

[OkHttp]: http://square.github.io/okhttp/

1. 만약 [OkHttp][]를 사용할 수 있다면 Http Client 를 [OkHttp][]로 사용하는 `OkHttpDownloader`가 기본 구현체가 됩니다.
2. 그렇지 않은 경우에는 Http Client 를 `HttpURLConnection`로 사용하는 `UrlConnectionDownloader`가 기본 구현체가 됩니다.

<h3 id="transformer">com.squareup.picasso.Transformer</h3>

[`BitmapHunter`][bitmaphunter]가 비트맵을 만들면 후처리를 하는 모듈입니다. 불러온 이미지를 마스킹 한다던지 블러 효과를 주고싶다면 [`Transformer`][transformer]인터페이스를 구현하면 됩니다.

<h3 id="action">com.squareup.picasso.Action</h3>

[`BitmapHunter`][bitmaphunter]를 통해 불러오고 [`Transformer`][transformer]를 통해 후처리가 끝난 비트맵은 [`Action`][action]이 가져가서 처리를 하게됩니다. 불러온 비트맵을 어떻게 할지 결정하는 모듈이라고 볼 수 있습니다. 일반적으로 쓰게되는 [`Action`][action]의 구현체는 `ImageViewAction` 인데, 생성된 키트맵을 `ImageView` 에 설정합니다.










