# CherishiOS
탐욕집착불끈이들 일취월장 일사천리 ~ 🍎🍒



\# 체리쉬 소개







> <b>'~한 서비스, 체리쉬 </b><br/>

> 체리쉬 메인기능 이 ~~에요 

> 

> <br>



## 📃 목차



- [Project 설명](#project)

- [개발 환경 및 라이브러리](#🛠-개발-환경-및-사용한-라이브러리-(development-environment-and-using-library))

- [Coding Convention](#📝-coding-convention)

- [Github mangement](#💻-github-mangement)

- [팀원 소개](#🍎-ios-developer)







## 🍒 Project



* <b> SOPT 27th APPJAM, Cherish 

* 프로젝트 기간: 2020.12.26 ~ 2021.01.16

* 체리쉬는 ~~한 어플리케이션입니다.



//이미지 넣기



#### AutoLayout

- iPhone 12 pro

- iPhone 12 mini

- iPhone SE2







## 🛠 개발 환경 및 사용한 라이브러리 (Development Environment and Using Library)



### Development Environment



![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg) [![Creative Commons License](https://img.shields.io/badge/license-CC--BY--4.0-blue.svg)](http://creativecommons.org/licenses/by/4.0/) <img src="https://camo.githubusercontent.com/068f624eb1aea7290293a41532983b1519da346d/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d31332e332d6c6967687467726579"> <img src="https://camo.githubusercontent.com/09ed72f0fef2987a6ea9ddb10106cd2a14d87944/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f58636f64652d31312e332d626c7565"> 







### Using Library  

| 라이브러리(Library) | 목적(Purpose) | 버전(Version) |

|:---|:----------|----|

| Alamofire  | 서버 통신 | 4.8.2 |

| Kingfisher | 이미지 처리 | 5.0 |

| lottie-ios | Splash screen | 3.1.8 |

| BEMCheckBox | CheckBox 생성 | 







## 📜 Coding Convention 



###📂 폴더구조



- ***Resources\***

- -  SceneDelegate
  - AppDelegate
  - Storyboards
  - Assets
  - APIServices

- ***Sources\***

- - VCs
  - Classes
  - Cells
  - Designs
  - Models
  - Extensions (UIViewExtension, UIColorExtension …)

- ***Info.plist\***



👉 [자세히](https://github.com/TeamCherish/Cherish-iOS/wiki/CodingConvention)



### 네이밍



**클래스 & Struct**



- 클래스이름에는 UpperCamelCase를 사용하자.



- 클래스이름에는 접두사를 붙이지 말자.



 좋은 예 >



 \```swift

 class CherishHomeCell: UITableViewCell

 \```



 나쁜 예 >



 \```swift

 struct watering { }

 \```



**function & 변수 & 상수**



- 함수와 변수에는 lowerCamelCase를 사용하자.



- 버튼명에는 Btn 약자를 사용하자.



- 모든 IBOutlet에는 해당 클래스명을 뒤에 붙이자



 좋은 예 >



 \```swift

 @IBOutlet weak var floatingTodayRecordBtn: UIButton!

 @IBOutlet weak var firstRegisterView: UIView!

 @IBOutlet weak var inventoryTableView: UITableView!

 \```



 나쁜 예 >



 \```swift

 @IBOutlet weak var ScrollView: UIScrollView!

 @IBOutlet weak var leftcollectionview: UICollectionView!

 @IBOutlet weak var rightcollectionview: UICollectionView!

 @IBOutlet weak var tableview: UITableView!

 \```



\### 주석



- `// MARK:` 를 사용해서 연관된 코드를 구분짓자



### 기타



- viewDidLoad() 내에는 Function만 위치시키기

- 반복되는 코드는 Extension이나 Class로 묶기

- 함수끼리 1줄 개행







다음 스타일 Guide를 참고헀음 👉 [Style Guide](https://github.com/InventoryBox/inventorybox_iOS/wiki/InventoryBox_Coding_Convention)







## 💻 Github mangement



**아요체리들의 *일취월장 일사천리* WorkFlow : **Gitflow Workflow**



- Master와 Develop 브랜치



 마스터(master): 마스터 브랜치



 개발(develop): 기능들의 통합 브랜치 역할❗️ 이 브랜치에서 기능별로 브랜치를 따 모든 구현이 이루어져요



- Master에 직접적인 commit, push (X)



- 커밋 메세지는 다른 사람들이 봐도 이해할 수 있게 써주세요



- 풀리퀘스트를 통해 코드 리뷰를 해보아요



- 하루에 1번이상 Merge -> 주로 아침에❗️ 이유는 밤에 개발 잘 되는 사람들이므로



<img src="https://camo.githubusercontent.com/5af55d4c184cd61dabf0747bbf9ebc83b358eccb/68747470733a2f2f7761632d63646e2e61746c61737369616e2e636f6d2f64616d2f6a63723a62353235396363652d363234352d343966322d623839622d3938373166396565336661342f30332532302832292e7376673f63646e56657273696f6e3d393133" width="80%">  



  \```

- Master

​    ├── dev (Develop)

​       ├── HometableView(각 Local Branch)

​       ├── IVRecord     

​       └── IV@@@

  \```

**각자 자신이 맡은 기능 구현에 성공시! 브랜치 다 쓰고 병합하는 방법**



- 브랜치 만듦



\```bash

git branch feature/기능이름

\```



- 브랜치 전환



\```bash

git checkout feature/기능이름

\```



- 코드 변경 (현재 **feature/기능이름** 브랜치)



\```bash

git add .

git commit -m "커밋 메세지" -a // 이슈보드 이름대로 커밋

\```



- 푸시 (현재 **feature/기능이름** 브랜치)



\```bash

git push origin feature/기능이름 브랜치

\```



- feature/기능 이름 브랜치에서 할 일 다 헀으면 **develop** 브랜치로 전환



\```bash

git checkout develop

\```



- 머지 (현재 **develop** 브랜치)



\```bash

git merge origin feature/기능이름

\```



- 다 쓴 브랜치 삭제 (local) (현재 **develop** 브랜치)



\```bash

git branch -d feature/기능이름

\```



- 다 쓴 브랜치 삭제 (remote) (현재 **develop** 브랜치)



\```bash

git push origin :feature/기능이름

\```



- develop pull (현재 **develop** 브랜치)



\```bash

git pull origin develop

\```



- develop push (현재 **develop** 브랜치)



\```bash

git push origin develop

\```













----



## 🍎 iOS Developer



<img src="https://user-images.githubusercontent.com/63224278/103209152-b436e680-4945-11eb-91e4-bd8622e442e2.png" width="15%"> 



* [지은](https://github.com/hwangJi-dev)



  <img src="https://user-images.githubusercontent.com/63224278/103209201-da5c8680-4945-11eb-9824-21c96c4f97bf.jpeg" width="15%">

* [원석](https://github.com/snowedev)



<img src="https://user-images.githubusercontent.com/63224278/103209210-ddf00d80-4945-11eb-85c7-3f85ffc9f96c.png" width="15%"> 



- [서현](https://github.com/seohyun-106)



