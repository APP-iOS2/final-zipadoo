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

mvvm에 따르려 했으나 실제 작업시에 여러뷰에 필요한 뷰모델인 store도 만들어서 개발을 진행해야했습니다.
패턴에 종속되어 작업하는 것 뿐만 아니라 유동적으로 개발 패턴을 생각할 필요가 있다는 것을 느껴 MVVM과 여러뷰에 필요한 Store이라고 불리는 뷰모델을 섞어 사용하게 되었습니다.

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


- 지난 약속에서는 추적이 끝난 약속을 최근에 종료된 순으로 확인할 수 있습니다.
- 한 페이지에 10개의 약속이 노출되고, 최대 50개의 지난약속을 볼 수 있습니다.
- 지난약속을 누르면 친구들이 얼마나 일찍/늦게 도착했는지, 몇등으로 도착했는지 결과가 나옵니다.
<img width = "20%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/affa0684-389c-43dd-bb18-a5f425cfd1e7"/>


## <img width = "5%" src = "https://github.com/APPSCHOOL3-iOS/final-zipadoo/assets/102401977/6785967f-2630-4cd4-95ab-634833cd2d51"/>Trouble Shooting

> 1. 지도
- 남은 거리, 위치 현황 %구현
 -> https://github.com/APPSCHOOL3-iOS/final-zipadoo/issues/71<br>
지파두의 필수기능인 약속장소까지의 남은거리, 또한 친구들 현황을 한눈에 표시해 줄 프로그레스바를 구현해야했다.
이를 지도상의 위도,경도를 x,y로 생각하여 두점 사이의 거리를 구하고, 빗변의 길이를 구하는 피타고라스의 정리를 사용하여 메서드를 구현할 수 있었다.

- 실시간 유저 위치정보 가져오기, 적용하기
 -> https://github.com/APPSCHOOL3-iOS/final-zipadoo/issues/151<br>
실제 유저의 위치정보를 가져오고 적용하기 위해, 유저의 데이터를 주기적으로 파이어스토어에 저장하고 불러오는 아이디어를 내었다. 하지만 실제로 서버용량에 무리가 가지 않을까 하는 걱정과 어떻게 하면 계속하여 저장하고 불러올 수 있을지가 고민되었다. 이를 Timer 메서드로 5초 당 한번씩 쓰고 읽기를 하는 방식으로 해결하였다. 그러나 초를 줄일 수록 서버에 부담이 됨으로 더 좋은 최적화 방법이 필요할 것으로 보인다.  

- 참여자의 위치정보와 개인정보를 같이 가져와야했던 문제
 -> https://github.com/APPSCHOOL3-iOS/final-zipadoo/issues/216<br>
  서로 다른 구조체에 들어가 있는 위치정보와 유저의 개인정보를 맵뷰에 동시에 불러와야했다.
위치 구조체가 유저 id를 가지고 있는 has a 관계로 파이어스토어에 저장한 적합한 데이터를 가지고 오는데 어려움이 있었다. 이를 해결하기 위해 원하는 데이터를 가지고 있는 또하나의 구조체를 만들어 ViewModel에 적합한 값을 가지고 오는 패치 함수를 만들어 원하는 값을 넣어주어 새로운 구조체를 가지고 뷰를 그려주는 방식으로 해결하였다.

- 현재위치를 가져올때 뷰가 그려지기 전에 가져와지는 문제 -> 

> 2. 위젯
- 앱 데이터 공유하기 문제
- 위젯에서 navigationLink 영역 설정 문제
  -> https://github.com/APPSCHOOL3-iOS/final-zipadoo/issues/244
  -> https://github.com/APPSCHOOL3-iOS/final-zipadoo/pull/288

> 로티 애니메이션
- 

> 3. 그 외
 - 약속 리스트 참여자 프로필 노출
-> https://github.com/APPSCHOOL3-iOS/final-zipadoo/pull/322<br/>
   약속리스트 약속마다 참여자의 프로필 사진이 겹쳐지도록 뜨게 하고 싶었지만 모든 카드가 똑같이 뜨는 오류가 있었습니다. HomeMainView에서 프로필이미지를 하나하나 패치 해와야했고 이를 뷰에 카드마다 다르게 그려줘야 했는데 카드뷰를 func promiseListCell함수로 빼서 진행했더니 계속 난항이었습니다. 이후 프로필 이미지 경로배열이 저장된 class를 카드마다 생성해주는 것으로 바꿨지만 하나의 struct안에서 여러번 class LocationStore을 초기화해 만들어 주는것에 주의표시가 떴습니다. 그래서 아예 카드뷰를 struct PromiseListCell로 하나 만들어서 생성했고 내부 onappear메서드로 이미지들을 불러와 해결했습니다. 막상 해결하고 보니 꼬아서 생각해 벌어진 이슈였지만, 코드를 짜면서 느낀 점이 많아 트러블슈팅으로 넣게 되었습니다.
      

  


