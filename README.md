# 🎞️ Sceeniary
나만의 미디어 라이브러리를 만들고, 감상을 기록하며, 시청 습관을 관리할 수 있는 미디어 아카이빙 앱입니다.


## 🛠️ 기술 스택
### Platform: MAC

### IDE: Xcode

### Framework: SwiftUI

### DB: Firebase (Firestore, Authentication, Storage)


## ✨ 주요 기능
### 1. 미디어 기록 및 관리
통합 미디어 관리: 시청 상태(시청 예정, 시청 중, 시청 완료)를 통해 모든 미디어를 하나의 데이터 모델로 관리합니다.

정보 집약적 카드 뷰:
시청 중 상태에서는 프로그레스 바로 진행률을 표시합니다.
시청 완료 상태에서는 사용자가 매긴 별점을 표시합니다.
카드에서 장르, OTT, 유형 등의 태그를 한눈에 확인할 수 있습니다.

상세 정보 입력:
필수: 제목
선택: 장르, 시청 상태, 회차 수, 이미지, 시청 날짜, 별점, OTT(다중 선택), 유형 태그, 메모, 즐겨찾기

상세 회고 및 회차별 기록:
작품에 대한 전체적인 감상(메모)을 기록할 수 있습니다.
시리즈 작품의 경우, 회차별 기록 기능을 통해 각 에피소드에 대한 개별적인 메모와 정보를 남길 수 있습니다.

### 2. 검색 및 필터링
통합 검색: 제목 기반의 텍스트 검색 기능을 제공합니다. (부분 일치, 대소문자 구분x)

정렬 기능: 최신순, 별점순 등 다양한 기준으로 기록을 정렬할 수 있습니다.

상세 필터링: OTT, 장르, 유형 태그 등 여러 조건을 조합하여 원하는 미디어를 정확하게 찾아낼 수 있습니다.

### 3. 사용자 기능
로그인/회원가입:
이메일 기반의 일반 회원가입 및 로그인을 지원합니다.
Firebase Authentication을 통한 Google 소셜 로그인 기능을 제공합니다.

즐겨찾기: 중요한 미디어를 즐겨찾기하여 별도로 모아볼 수 있습니다.

마이페이지(고도화):
사용자의 프로필 정보를 관리합니다.
총 시청 시간, 완료 작품 수, 선호 장르 등 자신의 미디어 활동에 대한 개인 통계를 확인할 수 있습니다.

### 4. 커뮤니티 및 알림(고도화과정)
사용자 간 채팅: Firebase를 활용하여 다른 사용자와 미디어에 대한 감상을 나누는 실시간 채팅 기능을 제공합니다.

시청 알림: '시청 예정'으로 등록한 미디어의 시청할 날짜가 되면 푸시 알림을 보내줍니다. (Firebase Cloud Messaging)
