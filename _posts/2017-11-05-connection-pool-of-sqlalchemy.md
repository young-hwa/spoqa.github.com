---
layout: entry
title: SQLAlchemy의 Connection Pooling 이해하기
author: 김재석
author-email: jc@spoqa.com
description: SQLAlchemy의 Connection pool 개념에 대해 이해하고 실전에서 만날 수 있는 이슈를 정리해보았습니다.
publish: true
---

안녕하세요. 스포카 프로그래머 김재석입니다.

[SQLAlchemy][]는 Python의 Database Toolkit으로는 가장 독보적인 수준으로 우아한 기능을 제공하고 있어 많은 사람이 애용하고 있습니다. 스포카에서도 Python 프로젝트인데 Database에 접근해야 한다면 필수로 이용하고 있죠.

오늘은 SQLAlchemy의 Connection Pool에 대한 기본 개념과 실전에서 Connection Pooling과 관하여 알면 좋을 여러 이슈에 대해 다뤄보고자 합니다.

# Connection Pooling 개념

WIP

# SQLAlchemy의 기본 Pool: QueuePool

WIP

# QueuePool의 생애주기

1. QueuePool이 처음부터 Connection을 만드는 것은 아닙니다. 일단 0개로 시작합니다.
2. 요청이 들어올 때, QueuePool에 유효 Connection이 없으면 하나 생성합니다.
3. 설정된 pool_size까지는 더 이상 Connection이 필요하지 않은 상황이라도 Connection을 종료하지 않습니다.
4. 요청이 들어올 때, pool_size까지 다 찼다 할 지라도 유효 Connection이 없으면 초과하여 하나 생성합니다.
5. 4번 이후부터는 overflow 상황이기 때문에, QueuePool은 적극적으로 overflow를 방지하기 위해 새로 들어오는 Connection을 종료하여 pool_size에 총 Connection 수를 맞춥니다.
6. QueuePool이 관리하는 Connection이 pool_size + overflow까지 다 찬 상황에서 요청이 들어오면, 일단 기다리게 합니다. 기본값으로는 30초를 기다립니다.
7. 30초를 기다려도 반환되는 Connection이 없다면 TimeoutError 예외를 발생시킵니다.

# 적절한 QueuePool 설정값

서비스가 작을 때는 기본값이면 충분하지만, 서비스 사용량이 많아지고 규모 문제가 발생하게 된다면 설정을 현재 상황에 맞춰 바꿔주는게 좋습니다. 보통 QueuePool 관련 위 언급한 2가지 값 (pool_size, max_overflow) 를 바꿔주는게 좋은데 기본 값은 5, 10입니다.

- pool_size: 현재 구성에서 Connection 생성 부담을 최소화할 수 있는 가장 작은 값이 되어야 합니다.
- max_overflow: 현재 구성에서 DB, 웹인스턴스가 물리적으로 버틸 수 있는 최대값이 되어야 합니다.

pool_size가 과하게 설정되어있으면 DB 입장에서 너무 많은 커넥션을 점유하고 있으니 비효율적입니다. 그렇다고, 너무 적게 설정한다면 overflow가 자주 발생하여 pooling 으로 얻을 수 있는 효율을 누리지 못합니다. 즉, 파이썬 측에서 비효율적입니다.

max_overflow가 DB나 웹 인스턴스의 한계치보다 너무 빡빡하게 잡혀있으면 조금만 사용자 유입이 늘어도 TimeoutError를 쉽게 만나거나 서비스 속도 저하를 자주 경험하게 됩니다. 그렇다고 무한으로 두면 사용량 폭증 시점에서 이해할 수 없는 에러 파티를 경험하게 될 것입니다. (DB나 파이썬 앱, 혹은 둘 다가 파업합니다.)

결국 서비스마다 그만의 퍼포먼스와 장비 한계치가 있으니만큼 내부에서 스트레스 테스트를 통한 벤치마킹으로 적정값을 뽑아낼 수밖에 없습니다.

# QueuePool 관하여 자주 밟는 문제

## 개발할 때는 문제가 없었는데, 상용 서버로 런칭하면 꼭 5분 정도 지나고 서버가 TimeoutError를 발사하며 응답을 안합니다.

SQLAlchemy 쓰는 서비스를 만들어서, 개발 잘 하고 배포했는데 프로덕션에서 잠깐 잘 돌 더니 TimeoutError에러를 내뱉으며 픽픽 죽어버리는 경험을 많이 하는 것 같습니다. 이 에러 자체는 Session이 QueuePool에게 Connection을 받기 위해 기다리다가 못 참고 TimeoutError를 내는 것인데요. 위의 생애주기 기준, 7번에 해당하는 상황이죠. QueuePool의 timeout 기본값은 30이니까 30초동안 Pool 내의 모든 Connection이 점유된 상태에서 아무것도 받지 못한 상태가 된 것이라고 보시면 됩니다.

위와 같은 경험이라면 서비스 사용량이 폭증하는 쪽보다는 십중팔구는 기 사용 Session에서 제대로 Connection을 반환해주지 않아서 발생하는 문제입니다. 특히 웹서비스라면 flask 등에서 요청시마다 Session이 Connection을 불러다 써놓고 Pool에 돌려주는 일을 빼먹는 실수가 잦은데, flask를 쓰고 계시다면 Flask-SQLAlchemy 등을 쓰셔서 생애주기 관리 자체를 타 라이브러리에 위임하시거나, 현재 구조상에서 요청이 끝나는 시점에 맞춰 session.close()를 적절히 호출해주시면 됩니다. (사실 Flask-SQLAlchemy가 해주는 것도 딱 이 수준입니다.)

## 어느날 갑자기 Connection이 왕창 늘어버렸어요.

역시 웹서비스 개발하다보면 발생하는 이슈입니다. SQLAlchemy를 쓰면 Session 활용을 암시적으로 하게 될 때가 많습니다. Session이 실제로 요청을 보내는 시점에서야 Connection을 시도하기 때문에, 예상치 못한 기능 변경으로 Connection 폭증을 겪는 것인데요. 제가 자주 본 것은 flask의 endpoint 생애주기중 before_request 구현에서 DB에 접근하는 것입니다.

본래 DB 연결이 필요한 endpoint에서만 접속이 발생하던 것이, before_request에 붙으면서 모든 endpoint가 DB 연결을 하게 되면 사용량이 폭증하기 쉽게 되는 것인데요.

## 처음 서버를 실행시켰을 때 커넥션이 확 튑니다.

WIP

# 마치며

WIP
