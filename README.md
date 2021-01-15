
<img src="https://user-images.githubusercontent.com/42789819/104716209-f1cfa800-576a-11eb-8275-3d2e69cce546.png">


## 🍒 Project

* <b> SOPT 27th APPJAM, Cherish </b>
* 프로젝트 기간: 2020.12.26 ~ 2021.01.16
> 당신의 소중한 사람들을 위한 연락관리 서비스, CHERISH.


<img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103210113-1bee3100-4948-11eb-9e21-9d41150e854b.png" width="256px" height = "256px" />



<br>
<br>

## 🛠 개발 환경 및 사용한 라이브러리 (Development Environment and Using Library)

### Development Environment

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg) [![Creative Commons License](https://img.shields.io/badge/license-CC--BY--4.0-blue.svg)](http://creativecommons.org/licenses/by/4.0/) </br>
<img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white"> <img src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white"> 


### Using Library  
| 라이브러리(Library) | 목적(Purpose) | 버전(Version) |
|:---:|:----------:|:----:|
| Alamofire   | 서버 통신 | 5.4.1 |
| Kingfisher  | 이미지 처리 | 5.15.8 |
| SnapKit  | 오토레이아웃 | 5.0.1 |
| Lottie-iOS  | 애니메이션 처리  | 3.1.9 |
| FSCalendar  | 캘린더 뷰 만들기 | 2.8.2 |
| OverlayContainer  | BottomSheet애니메이션  |  |

### 📱 AutoLayout
- iPhone 12 pro
- iPhone 12 mini
- iPhone SE2


<br>
 <br>
 
 ## 📜 Coding Convention 
 <details>
 <summary> 📂 폴더구조 </summary>
 <div markdown="1">       

<br>

**Resources**
* AppDelegate
* SceneDelegate
* Assets.xcassets
* Storyboard
* APIService
    * APIConstant
* Font

**Sources**
* VC
* Class
* Cell
* Model
    * GenericResponse
* Extension
            
**Info.plist**

<br>

<img width="265" alt="Sources" src="https://user-images.githubusercontent.com/63224278/103536269-89b0d480-4ed5-11eb-9202-0ed38090b499.png">

<br>
 </div>
 </details>
 
 
 <details>
 <summary> ⚙️ 폴더링 규칙 </summary>
 <div markdown="1"> 
 
 
 규칙

- 폴더링 한 후 Sources 폴더에 있는 파일들은 각 파일 하위에 자신 스토리보드 이름에 해당하는 폴더를 만들어 관리합니다. 

<img width="265" alt="Sources" src="https://user-images.githubusercontent.com/63224278/103536203-6b4ad900-4ed5-11eb-9614-b4731aa3773a.png">

- 파일 네이밍 시, 접두에 스토리보드이름을 붙여서 네이밍합니다.
    -  (ex. 스토리보드 이름이 Main, Watering이라고 가정했을 때 cell파일 생성 시 MainBlahblahCVC, WateringBlahblahTVC와 같이 네이밍합니다.)
        
👉🏻 [자세히](https://github.com/TeamCherish/Cherish-iOS/wiki/CodingConvention)

 </div>
 </details>



<details>
<summary> 🖋 네이밍 </summary>
<div markdown="1">       

**Class & Struct**

- 클래스/구조체 이름은 **UpperCamelCase**를 사용합니다.

- 클래스 이름에는 접두사를 붙이지 않습니다.

 좋은 예 >

  ```swift
  class CherishTVC: UITableViewCell
  ```

 나쁜 예 >

  ```swift
  struct cherishCVCInfo { }
  ```

**함수 & 변수 & 상수**

- 함수와 변수에는 **lowerCamelCase**를 사용합니다.

- 버튼명에는 **Btn 약자**를 사용합니다.

- 모든 IBOutlet에는 해당 클래스명을 뒤에 붙입니다. 
    - ~~ImageView, ~~Label, ~~TextField와 같이 속성값을 붙여줍니다.
    
- 테이블 뷰는 **TV**, 컬렉션뷰는 **CV**로 줄여서 네이밍합니다.

- 테이블 뷰 셀은 **TVC**, 컬렉션뷰 셀은 **CVC**로 줄여서 네이밍합니다.

 좋은 예 >

  ```swift
  @IBOutlet weak var wateringBtn: UIButton!
  @IBOutlet weak var cherishMainView: UIView!
  @IBOutlet weak var cherishTV: UITableView!
  ```

 나쁜 예 >

  ```swift
  @IBOutlet weak var ScrollView: UIScrollView!
  @IBOutlet weak var cherishcollectionview: UICollectionView!
  @IBOutlet weak var tagcollectionview: UICollectionView!
  @IBOutlet weak var tableview: UITableView!
  ```
<br>

</div>
</details>
 
 
 
 <details>
 <summary> 🏷 주석 </summary>
 <div markdown="1">       
 
 - `// MARK:` 를 사용해서 연관된 코드를 구분짓습니다.
 - `///` 를 사용해서 문서화에 사용되는 주석을 남깁니다. (ex. /// 사용자 프로필을 그려주는 뷰)
 <br>

 </div>
 </details>


<details>
<summary> 📎 기타 </summary>
<div markdown="1">       

- viewDidLoad() 내에는 **Function만 위치**시킵니다.
- 중복되는 부분들은 +Extension.swift로 만들어 활용합니다.
- 메인컬러와 같이 자주 쓰이는 컬러들은 Asset에 Color Set을 만들어서 사용합니다.
- , 뒤에 반드시 띄어쓰기를 합니다.
- 함수끼리 1줄 개행합니다.
- 중괄호는 아래와 같은 형식으로 사용합니다.
```swift
if (condition){

  Statements
  /*
  ...
  */
  
}
```
</div>
</details>
 
 
<br>

 다음 스타일 Guide를 참고헀습니다. 👉🏻[Style Guide](https://github.com/StyleShare/swift-style-guide)


## ✉️ Commit Messge Rules
<details>
<summary> 아요체리🍒 들의  Git Commit Message Rules </summary>
<div markdown="1">       


- 반영사항을 바로 확인할 수 있도록 작은 기능 하나라도 구현되면 커밋을 권장합니다.
- 커밋할 땐 **iOS 슬랙에 노티**합니다.
- 기능 구현이 완벽하지 않을 땐, 각자 브랜치에 커밋을 해주세요.
<br>


### 📜 커밋 메시지 명령어 모음

```
- feat    : 기능 (새로운 기능)
- fix     : 버그 (버그 수정)
- refactor: 리팩토링
- style   : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
- docs    : 문서 (문서 추가, 수정, 삭제)
- test    : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
- chore   : 기타 변경사항 (빌드 스크립트 수정 등)
```
<br>

### ℹ️ 커밋 메세지 형식
  - `[커밋메세지] 설명` 형식으로 커밋 메시지를 작성합니다.
  - 커밋 메시지는 영어 사용을 권장합니다.

좋은 예 > 

```
  [Feat] fetchcontacts
```

나쁜 예 >
```
  연락처 동기화 기능 추가
```

</div>
</details>
 

## 💻 Github mangement

<details>
<summary> 아요체리🍒들의  WorkFlow : Gitflow Workflow </summary>
<div markdown="1">       


- main 브랜치

 메인(main): 메인 브랜치

 기능(cherish뷰이름): 기능별 (뷰별) 로컬 브랜치 

- 커밋 메세지는 다른 사람들이 봐도 이해할 수 있게 써주세요.

- 풀리퀘스트를 통해 코드 리뷰를 해보아요.

<br>

```
- Main
   ├── cherishMainView(각 Local Branch)
   ├── cherishAddView    
   └── cherishWateringView
```

<br>

**각자 자신이 맡은 기능 구현에 성공시! 브랜치 다 쓰고 병합하는 방법**

- 브랜치 만듦

```bash
git branch 기능(or 뷰)이름
```

- 원격 저장소에 로컬 브랜치 push

```bash
git push --set-upstream origin 브랜치이름(뷰이름)
```
```bash
git push -u origin 브랜치이름(뷰이름)
```


- 브랜치 전환

```bash
git checkout 뷰이름
```

- 코드 변경 (현재 **뷰이름** 브랜치)

```bash
git add .
git commit -m "커밋 메세지" origin 뷰이름
```

- 푸시 (현재 **뷰이름** 브랜치)

```bash
git push origin 뷰이름 브랜치
```

- 뷰이름 브랜치에서 할 일 다 했으면 **main** 브랜치로 전환

```bash
git checkout main
```

- 머지 (현재 **main** 브랜치)

```bash
git merge 뷰이름
```

- 다 쓴 브랜치 삭제 (local) (현재 **main** 브랜치)

```bash
git branch -d 뷰이름
```

- 다 쓴 브랜치 삭제 (remote) (현재 **main** 브랜치)

```bash
git push origin :뷰이름
```

- main pull (현재 **main** 브랜치)

```bash
git pull or git pull origin main
```

- main push (현재 **main** 브랜치)

```bash
git push or git push origin main
```
</div>
</details>
  
  
  <br>
   <br>

 ## 서비스 workflow
 <img width=100%, src="https://user-images.githubusercontent.com/42789819/104694023-ed48c680-574d-11eb-82d6-ad570e35e9ca.png">


<br>
 <br>
 
## 기능별 개발여부 + 담당자


| 기능 | 개발 여부 | 담당자 |
|:----------:|:----------:|:----:|
| Login & Splash | 🍒 | 황지은 |
| Push Alert | 🍒 | 황지은 |
| MainView | 🍒 | 황지은 |
| Watering Flow & 연락 수단 연결 | 🍒 | 이원석 |
| Calendar View | 🍒 | 이원석 |
| 리뷰 수정 | 🍒 | 이원석 |
| Plant Detail | 🍒 | 황지은 |
| Add User | 🍒 | 장서현 |
| MyPage | 🍒 | 황지은,장서현 |  

* [Cherish iOS 개발 일지📔 및 칸반보드👨‍🏫 ](https://www.notion.so/iOS-6d2c0ea99df5403eaa7154b42a1cae4c)
<br>
 <br>
 
 ### `Splash+Login+권한요청`
 <img width="714" alt="Cherish_Splash_Login" src="https://user-images.githubusercontent.com/42789819/104697614-5f6fda00-5753-11eb-8ceb-df88d9877d46.png">


* 사용자가 로그인을 하게 되면 앱에서 필요로 하는 연락처, 푸쉬알림등에 대한 권한 요청이 이루어집니다.


<br>

### `메인뷰`
<img width="738" alt="Cherish_MainView" src="https://user-images.githubusercontent.com/42789819/104694986-5d0b8100-574f-11eb-9ceb-9917ea389b9b.png">   


* 2 Step Bottom Sheet
* 선택한 식물에 따라 메인 뷰에 변화가 생깁니다
    * 메인 뷰의 식물들이 등록된 식물로 변화
    * D-DAY 라벨과 식물의 네이밍 변화
    * 식물 네이밍 위의 '아직 수명이 탄탄한' 등의 수식어는 랜덤으로 지정
    * 좌측에 위치한 해당 식물에 대한 애정도 Bar
* Bottom Sheet의 첫 번째 Cell은 사용자가 선택한 Cell로 변경됩니다
* Bottom Sheet의 각 Cell들은 물주기가 임박한 순서대로 정렬됩니다


<br>

### `물주기 Flow`
<img width="915" alt="Cherish_Watering" src="https://user-images.githubusercontent.com/42789819/104696355-80373000-5751-11eb-8853-457a7071baf8.png">


**메인뷰에 위치한 물주기 버튼을 통해 각 식물에게 물을 줄 수 있습니다**

* 물주기
    * 물주기는 전화, 메시지, 카카오톡의 3가지 수단으로 진행 할 수 있습니다
    * 각 연락수단을 통해 소중한 연락을 한 뒤에는 오늘 한 연락에 대한 리뷰를 작성하는 화면으로 진입합니다


* 연락 후기
    * 리뷰의 작성은 사용자의 선택입니다
    * 리뷰에서는 최대 5글자, 최대 3개의 키워드를 등록할 수 있고 100자 제한의 메모를 작성할 수 있습니다
    * 리뷰를 완료한 순간이 물주기가 완료된 순간입니다
    
    
* 물주기를 성공하면 메인뷰의 식물은 물주기 모션에 진입합니다
    * 리뷰를 작성한 물주기의 경우 애정도가 +2 상승
    * 리뷰를 건너 뛴 물주기의 경우 애정도가 +1 상승
    
    
* 물주기를 미룰 경우 메인뷰의 식물은 시드는 모션에 진입합니다
    * 원래 연락하려는 날에서 최소 1일 부터 7일까지 미룰 수 있음
    * 식물 당 3번까지는 애정도의 감소가 없으나 4회부터는 감소 


<br>

### `식물 등록(Add User)`
<img width="877" alt="Cherish_AddUser" src="https://user-images.githubusercontent.com/42789819/104698017-06ed0c80-5754-11eb-8f6f-040a6a1e3a3c.png">


* 사용자는 자신이 연락 관리를 하고싶은 사람을 연락처에서 선택합니다
* 사용자는 식물 애칭, 생일, 물주기 알람(푸쉬알람) 주기, 물주기 알람(푸쉬알람) 시간을 지정할 수 있습니다
    * 단, 이름과 전화번호는 수정이 되지 않는 상태로 넘어오게됩니다
* 사용자가 지정한 물주기 알람 주기에 따라 그에 맞는 식물이 배정됩니다
* 식물 종류는 단모환, 민들레, 로즈마리, 스투키, 아메리칸블루 이상 5가지 입니다


<br>

### `식물 상세 뷰`
<img width="817" alt="image" src="https://user-images.githubusercontent.com/42789819/104714955-322e2680-5769-11eb-9e2e-5f6ed6084a67.png">


* 메인 뷰에서 식물을 터치하면 식물 상세뷰로 이동합니다
* 식물 상세 뷰에서는 Circle Status Bar로 식물의 물주기의 임박 정도를 알 수 있습니다
* 등록한 친구의 연락처상 이름, 사용자가 등록한 친구의 별명, 친구의 생일을 알 수 있습니다
* 해당 식물에게 물을 준 적이 있고, 후기를 작성한 적이 있다면 식물 상세 뷰 하단에서 후기를 최대 2개까지 모아 볼 수 있습니다(이 때 키워드는 가장 최근 연락 시 작성한 키워드입니다)


<br>

### `캘린더 뷰+리뷰 수정`
<img width="783" alt="Cherish_Calendar" src="https://user-images.githubusercontent.com/42789819/104715101-699cd300-5769-11eb-9140-b9a177fb7cc0.png">


* 식물 상세 뷰에서 하단에 위치한 메모들 중 사용자가 원하는 메모 최 우측의 ‘>’ 버튼을 선택하면캘린더 뷰 해당 날짜로 이동하여 메모를 보여줍니다
* 식물 상세 뷰에서 상단 우측에 위치한 달력 버튼을 클릭하면 캘린더 뷰로 이동합니다
* 캘린더는 각 식물마다 배정되어 있으며 지금까지 물 준 날과 앞으로 물 줄 날을 Dot으로 표시해줍니다
* 사용자가 해당 식물에게 물 준 날 리뷰까지 작성했다면 캘린더 하단에 그 날 작성한 리뷰가 표시됩니다
* 이 때, 우측에 위치한 연필 버튼을 통해 해당 날짜의 리뷰를 수정할 수 있습니다


<br>

### `푸쉬 알림`
<img width=20%, src="https://user-images.githubusercontent.com/42789819/104715202-8e914600-5769-11eb-8dba-6391374df7d8.png">


* 사용자가 등록한 식물의 물주기가 다가왔을 때 푸쉬알림이 사용자의 휴대폰으로 전송됩니다
* 사용자가 등록한 식물의 생일이 되었을 때 푸쉬알림이 사용자의 휴대폰으로 전송됩니다


<br>

### `마이페이지`
<img width="783" alt="Cherish_MyPage1" src="https://user-images.githubusercontent.com/42789819/104715410-e0d26700-5769-11eb-8729-1163c2a9dc2c.png">  
<img width="830" alt="Cherish_MyPage2" src="https://user-images.githubusercontent.com/42789819/104715425-e5971b00-5769-11eb-99be-52c8f4aed02f.png">


* 마이페이지의 내 식물 탭에서는 지금까지 사용자가 등록한 식물들을 모아 볼 수 있습니다
* 내 식물 탭 우측의 연락처 탭에서는 새로운 사람을 들록 할 수 있습니다
* 마이페이지 우측 상단에 있는 돋보기 버튼을 통해 검색이 가능합니다

<br>
 <br>
 
## 핵심 기능 구현 방법(코드포함)
[Cherish-iOS 핵심 기능 구현 방법](https://www.notion.so/9b0189b165974dfeae8b3df27d5a99c2)  

<br>
 <br>

## Extension을 통해 작성한 메소드 설명  
```Swift
// 기기별 사이즈를 알기 위한 Extension
UIDevice+ScreenSize.swift

// 색상을 정의해놓은 Extension
UIColor+Additions.swift

// Notification을 쓰기 위한 Name Extension 
NotificationName.swift

// 자주 사용하는 Radius와 Shadow 를 함수로 정의해 놓은 Extension
UIView+Extension.swift

// TextField의 입력 구역을 정의를 위한 Extension
UITextField+Extension.swift

// 버튼의 자간을 설정하기 위한 Extension
UIButton+Extension.swift

// ImageView에서 Gif를 불러오기 위한 Extension
UIImage+Extension.swift
```


<br>
<br>
 

## 🍎 iOS Developer Introduction


| 팀원 | 팀원 이름 | 소개 |역할 |
|:---:|:---------:|:-------:|:---------------:|
| <img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103209152-b436e680-4945-11eb-91e4-bd8622e442e2.png" width="200px" />  | [지은](https://github.com/hwangJi-dev) | 안녕하세요🍒 Cherish의 비타민같은 존재 황지은 입니다!  | 황구글(물어보면 바로 찾아줌), 황사인 볼트(개발속도 개빠름) |
| <img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103280936-ee22ee00-4a14-11eb-9161-aa5249d74f20.png" width="250px" height = "200px" />  | [원석](https://github.com/snowedev) | 안녕하세요🍒 Cherish가 정말 필요한 개발자 이원석입니다!  | 캘린더, 키워드의 노예, 늘리고 줄이기 달인 |
| <img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103281341-e9ab0500-4a15-11eb-877b-e9c384c7de88.png" width="250px" height = "200px" />  | [서현](https://github.com/seohyun-106) | 안녕하세요🍒 Cherish의 귀염둥이 막내 장서현입니다! | 라디오 버튼의 노예..저 이제 라디오 안듣습니다.. |


<br>
<br>
