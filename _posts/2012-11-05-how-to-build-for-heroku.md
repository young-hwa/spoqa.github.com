---
layout: entry
title: vulcan과 buildpack을 이용한 Heroku 바이너리 배포
author: 문성원
author-email: longfin@spoqa.com
description: Heroku용 빌드 서버인 Vulcan과 배포 도구인 buildpack을 이용해 Heroku에 직접 설정한 바이너리를 빌드하여 적용하는 법을 알아봅니다.
publish: true
---

안녕하세요. [스포카 개발팀]에서 서버 관련 개발 업무를 담당하고 있는 문성원입니다. 오늘은 저희가 사용하는 PasS(Platform as a service)인 [Heroku]에 직접 바이너리를 빌드하여 올리는 방법을 함께 알아보겠습니다.

# Why?
---

지난주 저희 개발팀은 새로운 상점 사진을 출력하기 위해 한 사진을 비율이 다른 이미지로 바꿔서 저장하는 작업을 해야 했습니다. 다행히 이 문제는 [Seam carving], 혹은  Liquid rescaling으로 불리는 방법, 그리고 이를 구현한 [ImageMagick]과 그 [Python] 바인딩인 [wand]로 쉽게 해결할 수 있을 것 같았습니다. (Seam carving과 wand에 대해서는 [이 글](http://blog.dahlia.kr/post/34088303362)을 읽어보시는 것을 권합니다.)

그런데 막상 서비스에 배포하려니 한가지 문제가 있었습니다. 저희는 최근 서비스를 Heroku에서 운영 중인데, 이 Heroku에 ImageMagick 라이브러리는 깔렸었지만, [liblqr]이 없어 Liquid rescalig이 불가능한 상태였던 겁니다. 개발자의 로컬에서 테스트할 때야 소스를 받아서 직접 빌드라도하면 되지만 이 고지식한 PasS에서 그건 무리였죠.

결국, 저희는 Heroku의 배포 도구인 [buildpack]과 바이너리를 빌드하기 위한 서버인 [Vulcan]에 대해서 조사했습니다.

# Workflow
---
Heroku 앱에 사용할 바이너리를 만드는 데는 크게 2가지 과정이 필요합니다. 먼저 빌드 서버인 Vulcan을 통해 필요한 바이너리를 Heroku(정확히는 아마존 EC2)용으로 빌드해야하며, 이를 buildpack을 통해 새로 만들거나 운영 중인 앱에 적용해야 합니다. 

재미있는 점은 Vulcan 서버 역시 [Node.js]로 작성된 Heroku 앱이기때문에 buildpack을 적용할 수 있습니다. 즉 위와 같은 상황이라면 먼저 liblqr을 빌드한 뒤 이를 Node.js 용 buildpack에 적용해서 Vulcan에 올린 뒤 ImageMagick을 빌드해야 합니다. 

![workflow](/images/2012-11-05/workflow.png) 

# I am a Vulcan, bred to peace
---
우선 Vulcan부터 깔아보겠습니다. ([Ruby]와 [Heroku] 계정이 필요합니다. 경우에 따라선 `sudo`가 필요할 수 있습니다.)

    $ gem install vulcan

그다음 빌드에 사용할 서버 애플리케이션을 `vulcan` 커맨드를 통해 만듭니다. (눈치채신 분도 계시겠지만 앱 이름은 적당히 바꿔서 지으셔야 에러가 안 납니다.)

    $ vulcan create vulcan-dodo-dev

혹시 모르니 만들어진 서버의 업데이트를 한번 해줍시다.

    $ vulcan update --app vulcan-dodo-dev

# If I could change to liquid...
---

이제 본격적으로 빌드를 해봅시다. 먼저 필요한 건 [liblqr]입니다. 소스를 적당한 디렉터리에 내려받아 풀어둡니다. 

    $ wget http://liblqr.wikidot.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2
    $ tar xzf liblqr-1-0.4.1.tar.bz2

최신 소스를 원하신다면 [git 저장소](http://repo.or.cz/w/liblqr.git)를 복제하셔도 됩니다.

    $ git clone git://repo.or.cz/liblqr.git

편하신 대로 소스를 다 내려받으셨다면 이제 앞서 생성한 Vulcan을 통해 이를 빌드해봅시다. 

    $ cd liblqr
    $ vulcan build

Vulcan은 현재 디렉토리의 소스를 모두 묶어서 EC2상의 서버로 올린 뒤 그 서버에서 빌드한 바이너리를 다시 사용자의 컴퓨터로 내려줍니다. 이제 이를 buildpack을 통해 Vulcan 서버(vulcan-dodo-dev)에 적용해야 합니다.

# Buildpack is ready
---

buildpack을 직접 만들어 적용하는 건 아주 쉽습니다. 우선 다음 명령어로 Node.js용 buildpack을 복제합니다.

    $ git clone git://github.com/heroku/heroku-buildpack-nodejs.git

그다음에는 Heroku용으로 빌드된 liblqr을 Heroku 앱 빌드시 포함시키기 위해 `bin/compile` 파일의 마지막에 다음 코드를 추가합니다. (앞서 빌드한 liblqr을 외부에서 접근할 수 있게끔 적당한 장소(ex. [Amazon S3], 혹은 [Dropbox]의 Public 디렉터리등)에 올려둬야 합니다.)

    # liblqr                                                                                  
    LIBLQR_BINARY="https://dl.dropbox.com/u/55786385/liblqr-1-0.4.tgz"                        
    SPOQA_VM_VENDOR="vendor/spoqa/liblqr"                                                     
                                                                                          
    mkdir -p $1/SPOQA_VM_VENDOR                                                            
    curl $LIBLQR_BINARY -o - | tar -xz -C $1/$SPOQA_VM_VENDOR -f -

이제 buildpack을 커밋(`commit`)한뒤 적당한 공개 저장소(ex. [github]) 등에 올려(`push`)둡니다. 그리고 나선 아까 만든 Vulcan 앱(vulcan-dodo-dev)의 buildpack을 다음 명령어로 지정합니다.

    $ heroku config:set BUILDPACK_URL=https://github.com/spoqa/heroku-buildpack-nodejs.git --app vulcan-dodo-dev

마지막으로 Vulcan 앱을 업데이트하여 새 buildpack을 반영시킵니다.

    $ vulcan update --app vulcan-dodo-dev

확인을 위해서 Vulcan 앱에 들어가 보는 것도 좋습니다.

    $ heroku run bash --app vulcan-dodo-dev
    heroku run bash --app vulcan-dodo-dev
    Running `bash` attached to terminal... 
    ~ $ ls vendor/
    ls vendor/
    spoqa  gems

# It's a kind of magic
---

이제 liblqr을 이용해서 ImageMagick을 빌드해보죠. 기본적으로는 liblqr을 빌드할때와 다르지 않지만 `./configure`를 통해 옵션을 줘야 하기에 `build` 커맨드가 좀 복잡해집니다.

    vulcan build -p /tmp/ImageMagick -c "export PKG_CONFIG_PATH=/app/vendor/spoqa/liblqr/lib/pkgconfig && export CFLAGS=-I/app/vendor/spoqa/liblqr/include/lqr-1 && LD_LIBRARY_PATH=/app/vendor/spoqa/liblqr/lib && ./configure --prefix=/tmp/ImageMagick --with-lqr && make install" -v

조금만 자세히 살펴보면, `-p` 옵션으로 내려받을 경로를 지정하고 `-c` 옵션으로 실제 빌드에 사용할 커맨드를 지정합니다.(`-v`는 짐작하시다시피 확인을 위한 verbose 옵션입니다.) 앞서 수정한 buildpack에서 liblqr은 `/app/vendor/spoqa/liblqr` 밑에 설치되게끔 되어있기에 PKG_CONFIG와 CFLAGS 설정을 추가해주고 `--with-lqr`을 줘서 LQR 딜리게이트(Delegate)를 활성화 시킵니다.


# On your mark
---

이렇게 만들어진 ImageMagick 바이너리와 liblqr 바이너리를 실 서버에 적용할 buildpack에 추가해주면 이 험난한 여정도 끝입니다. 앞서 했던것처럼 대상 서버에 맞는 buildpack을 똑같이 복제합니다. (여기서는 Python을 사용합니다.)

    $ git clone git://github.com/heroku/heroku-buildpack-python.git

`bin/compile`을 고치는 것도 추가해야 할 라이브러리가 2개라는 점만 빼면 거의 같습니다.

    # ImageMagick with lqr                                                                                                                                                               
    LQR_BINARY="https://dl.dropbox.com/u/55786385/liblqr-1-0.4.tgz"
    IMAGE_MAGICK_BINARY="https://dl.dropbox.com/u/55786385/ImageMagick-6.8.tgz"
    IMAGE_MAGICK_WITH_LQR_DIR="vendor/ImageMagick+lqr"
    
    mkdir -p $1/$IMAGE_MAGICK_WITH_LQR_DIR
    curl $IMAGE_MAGICK_BINARY -o - | tar -xz -C $1/$IMAGE_MAGICK_WITH_LQR_DIR -f -
    curl $LQR_BINARY -o - | tar -xz -C $1/$IMAGE_MAGICK_WITH_LQR_DIR -f -

똑같이 고친 buildpack을 커밋, (적당한 저장소에) 푸시하고 대상 서버의 `BUILDPACK_URL`을 바꿔줍니다.

    $ heroku config:set BUILDPACK_URL=https://github.com/spoqa/heroku-buildpack-python.git --app dodo-dev

바뀐 buildpack을 적용하기 위해서 빈 커밋을 만들어 새로 배포해보겠습니다.

    $ git commit --allow-empty -m "empty commit"
    $ git push heroku master

마지막으로 대상 서버의 설정을 바꿔줍니다. 

    $ heroku config:set MAGICK_HOME=/app/vendor/ImageMagick+lqr LD_PRELOAD=/app/vendor/ImageMagick+lqr/lib/libMagickCore.so --app dodo-dev


  [스포카 개발팀]: https://spoqa.github.io/
  [Heroku]: http://www.heroku.com/
  [wand]: http://wand-py.org/
  [Seam carving]: http://en.wikipedia.org/wiki/Seam_carving
  [Ruby]: http://www.ruby-lang.org/
  [Vulcan]: https://github.com/heroku/vulcan
  [buildpack]: https://devcenter.heroku.com/articles/buildpacks
  [Python]: http://www.python.org/
  [ImageMagick]: http://www.imagemagick.org/script/index.php
  [liblqr]: http://liblqr.wikidot.com/
  [github]: https://github.com/
  [Amazon S3]: http://aws.amazon.com/s3/
  [Dropbox]: https://www.dropbox.com/
  [Node.js]: http://www.nodejs.org/
  
