---
layout: entry
title: iOS Passbook의 signpass 분석
author: JC Kim
author-email: shinvee@spoqa.com
description: iOS Passbook에 들어갈 Pass를 만들 때 반드시 필요한 툴킷인 signpass의 소스코드를 분석하였습니다.
---

## Passbook이란?

![Passbook](https://devimages.apple.com.edgekey.net/passbook/images/passbook-hero.png)

iOS 6에서 새로 추가된 [Passbook](http://www.apple.com/ios/whats-new/#passbook)은 여러 장의 디지털 티켓, 쿠폰, 매장 카드를 담고 편리하게 이용할 수 있는 애플리케이션입니다. Passbook 안에 들어가는 티켓, 쿠폰, 매장 카드들을 Pass라고 부릅니다. Pass는 기존 앱보다 손쉽게 개발, 배포할 수 있으며, 위치나 시간에 따라 최적의 사용 시간에 맞춰 알림을 주기 때문에 더 높은 사용성을 보장할 수 있습니다. 이번 블로그 글에선 Pass를 만드는 과정에서 이용되는 signpass의 소스코드를 분석해보도록 하겠습니다.

## signpass?

signpass는 애플이 Pass 개발에 이용할 수 있게 제공한 툴킷으로, 형식에 맞춰 개발된 Pass 디렉터리를 인증서와 함께 하나의 파일(\*.pkpass)로 묶어주는 프로그램입니다. Xcode Project 형태로 소스코드와 함께 [Passbook Materials](https://developer.apple.com/downloads/index.action?name=passbook)에 포함되어있습니다. Passbook Materials는 애플 개발자 계정이 있으면 무료로 다운받으실 수 있습니다.

## 왜 분석하는가?

signpass가 하는 일은 Pass를 만들어서 배포하는 데 있어 필수적인 과정이지만, 많은 Pass 배포환경이 리눅스 운영체제 위에 각자 고유의 서버 시스템 위에 구축될 것이므로, 해당 커맨드 라인 툴을 그대로 이용하기보단 기반 서비스 플랫폼에 맞춰서 새로 구현해야 할 필요가 있습니다. 다행히 signpass가 하는 일은 간단하며, 애플도 signpass를 주석이 포함된 소스코드 형태로 배포하였기 때문에 어렵지 않게 분석할 수 있습니다. 이 글은 signpass를 분석해야 할 분들에게 더욱 편하게 처리 과정을 이해할 수 있도록 돕고자 합니다.

## signpass의 처리 과정

signpass는 크게 3가지 일을 수행합니다.

 1. 파일명과 hash를 key/value 형태로 담은 manifest.json을 제작
 2. manifest.json을 인증서로 인코딩한 signature 제작
 3. 기존 파일과 앞의 1, 2 번에서 제작한 파일을 함께 zip 압축

signpass에는 이 외에도 validation 기능과 몇 가지 커맨드 라인 처리 기능이 포함되어있지만, pkpass를 만드는 과정만 보고 싶으시다면 PassSigner.m 의 `+(void)signPassWithURL:(NSURL *)passURL certSuffix:(NSString*)certSuffix outputURL:(NSURL *)outputURL zip:(BOOL)zip` 메서드만 참조하시는 것만으로 충분합니다.

### manifest.json 제작

형식에 맞춰 제작된 *.pass 디렉터리의 파일을 훑으면서 json 형태로 저장합니다. key는 파일이름, value는 파일 내용에 대한 SHA1 해싱이 들어가며 (`[fileData SHA1HashString]`), 완성된 json 파일은 보통 아래와 같은 내용을 하게 됩니다.

    {
      "icon@2x.png" : "bd5442b4b08aa4dde333ec9ef0269e7fd93140b3",
      "icon.png" : "ba47a8021c8d74d2146d7244c8a0566be37df43b",
      "pass.json" : "1cdbac541c1736420e7fbd7455c98d0735a71a9e",
      "logo.png" : "780540b3a324bf66aeaee2d352283371356e9502",
      "logo@2x.png" : "a718ffd4e611e404dd3eb701454bcaefdabbe311"
    }

### signature 제작

manifest.json 파일을 애플에서 받은 Pass 인증서를 이용해 인코딩합니다. (`CMSEncodeContent()`) 인증서를 통해 manifest를 인코딩함으로써, 쿠폰 발급자가 아닌 다른 사용자가 임의로 Pass를 편집하는 것을 방지합니다. 인코딩된 파일은 signature라는 이름의 파일로 Pass의 Top-level 디렉터리에 manifest.json과 함께 저장합니다.

CMSEncodeContent는 PKCS #7 기반의 [Cryptographic Message Syntax RFC 3852 표준](http://www.ietf.org/rfc/rfc3852.txt)으로, 해당하는 과정을 다른 플랫폼에 포팅할 때 표준 문서와 애플 인증서 형태를 함께 참조하시기 바랍니다.

### zip 압축

위의 두 파일과 나머지 파일들을 모두 포함하여 zip파일로 압축합니다. 단순한 과정이므로 부가적인 설명은 생략합니다. :-)

## 마치며

signpass의 구현 과정을 이해하였다면, Pass 배포 서비스를 구축 시 기반 플랫폼 의존도가 낮은 시스템을 구축할 수 있습니다. 또한, 이 분석을 통해, 애플이 Pass를 어떠한 방식으로 안전하게 보호하는지를 이해할 수 있으므로, 여러 회사에서 Pass의 도입 여부를 고민할 때 보안 측면에서 좋은 참고 자료가 될 것으로 기대합니다.
