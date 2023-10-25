# 지파두 - 지각 파는 두더지 (Zipadoo)
테킷 iOS앱스쿨 2기 최종프로젝트


## <img width = "5%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6785967f-2630-4cd4-95ab-634833cd2d51"/> 목차

- 프로젝트 소개
- 아키텍처
- 컨벤션
- 파일 구조
- 화면별 기능소개
- TroubleShooting
- 사용 기술
- 얻은 교훈


## <img width = "5%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6785967f-2630-4cd4-95ab-634833cd2d51"/>프로젝트 소개
> ADS
>  - 자주 지각하는 사람들에게는 습관을 고칠 수 있도록 동기를 제공하고 
> 지각하지 않는 사람들에게는 소소한 금전적 보상과 성취감을 제공해주는 앱 입니다.

- 친구들과 약속을 잡으면 지도상에 약속참여자의 위치를 실시간으로 보여주어 약속을 지키는 문화를 만들고자 하는 iOS앱
(사진)
- 팀원, 깃헙링크
  (iOS, 파이어베이스)
  - 임병구(PM) : https://github.com/9oos
  - 윤해수(PO) : https://github.com/Haesus
  - 김상규 : https://github.com/skkim125
  - 나예슬 : https://github.com/ffv1104
  - 남현정 : https://github.com/nhyeonjeong
  - 선아라 : https://github.com/SunAra25
  - 이재승 : https://github.com/JASONLEE-hub
  - 장여훈 : https://github.com/jangyeohoon
  - 정한두 : https://github.com/B-SSandoo
 
- 진행 기간
  - 기획 : 2023.9.19 ~ 9.22
  - 개발 : 2023.9.21 ~ 10.24

- 기술 스택
    - 개발언어 : Swift
    - 개발환경 : iOS 17.0, XCode Version 15.0 / Firebase
    - 협업도구 : Github, Discord, Figma, Notion, SwiftLint
    - 라이브러리 : Firebase, SwiftLint, Lottie, Alamofire, TossPayments


## <img width = "5%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6785967f-2630-4cd4-95ab-634833cd2d51"/>아키텍처
MVVM

## <img width = "5%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6785967f-2630-4cd4-95ab-634833cd2d51"/>컨벤션
- 폴더 구조
```
📦 AppleStore
|
+--- 🗂 App // app 실행 파일 폴더
|
+--- 🗂 Extention // Extention 파일 폴더
|
+--- 🗂 Modifier // Modifier 파일 폴더
|
+--- 🗂 Views // View.swift 폴더
|    |
|    +--- 🗂 Home // HomeView의 파일들
|    |
|    +--- 🗂 Friends // FriendsView의 파일들
|    |
|    +--- 🗂 Mypage // MypageView의 파일들
|
+--- 🗂 Models // Models 파일 폴더, 모델이 많아지면 뷰별로 묶어서 분류하셔도 됩니다.
|
+--- 🗂 ViewModels // ViewModels 파일 폴더
|
+--- 🗂 TestData // TestData 파일 폴더
```

## 화면별 기능 소개

> **홈에서는 추적중인(진행중인)약속과 예정된 약속을 볼 수 있습니다**
- 약속장소와 날짜, 시간을 정해 약속을 만들어줍니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/9b77f4da-b1ee-4270-8483-c5e7eac4fba5"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/3f696b72-9987-471b-aefc-87403b91d5c9"/>



- 약속시간 30분이 전이 되면 푸시알람이 뜨며 추적중인 약속으로 분류됩니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/dbba3efb-312e-4175-b523-a12114dc4fb8"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/4ef69c8c-fa3f-4107-ba11-d01ae381a9a6"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/b714a928-f377-446f-b941-31d02efa90d7"/>

- 추적중인 약속을 들어가면 친구들의 위치를 실시간으로 확인할 수 있으며 도착하면 알람이 뜹니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/1801a698-c3c2-4069-8baa-61991b4e073f"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/e5e0b553-cbe1-4625-8026-953f921d61f5"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/83b13436-3e1d-47a0-bc54-3b5011646746"/><br/><br/>



> **친구탭바에서는 친구목록과 요청이들어온 친구목록을 확인할 수 있습니다**
- 친구는 밀어서 삭제 가능하며 친구요청은 수락/거절이 가능합니다
- 친구요청이 들어온 수는 친구탭바의 뱃지로도 확인할 수 있습니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/c93cf247-2e17-44a1-abfc-00fb063cd916"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6c39892c-6bf0-4320-be2b-fc612c060652"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/ac72d458-e748-4bd7-aa74-5595706c058e"/>


- 친구추가는 닉네임으로 가능합니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/163f13f5-d353-4653-9e57-71601f757a9b"/>


> **마이페이지에서는 나의 지각비율과 지난약속목록을 확인할 수 있습니다**
- 지각 횟수 및 감자(포인트) 현황 확인할 수 있습니다.
- 토스페이를 통해 캐시를 충전할 수 있습니다.
- 회원정보 수정을 통해 정보 수정이 가능합니다
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/9f3a45f9-5f70-48b6-8669-75400dc48419"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/00c4aa46-40f1-4efa-88b6-c6f21078594d"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/b505a2da-870f-44f1-8828-bca1ddf3306e"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/00f93941-75fc-47a2-9f72-93b4f5340d09"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/2f0bfbd5-3b3d-4680-aee0-19ad1cd1f337"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/10be68d0-4cb3-4ba7-b424-e8a83590c93a"/>
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/52594310/5d15c5ee-1c59-4fc9-b984-567539abeb48"/>


