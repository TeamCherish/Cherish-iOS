
<img src="https://user-images.githubusercontent.com/63224278/103238523-58448000-498e-11eb-8dc5-4330b53cdda1.png">

## 🍒 Project

* <b> SOPT 27th APPJAM, Cherish </b>
* 프로젝트 기간: 2020.12.26 ~ 2021.01.16
* 체리쉬는 ~~~   서비스입니다.


<img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103210113-1bee3100-4948-11eb-9e21-9d41150e854b.png" width="256px" height = "256px" />



<br>


## 🍎 iOS Developer

<img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103209152-b436e680-4945-11eb-91e4-bd8622e442e2.png" width="200px" /> | <img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103209201-da5c8680-4945-11eb-9824-21c96c4f97bf.jpeg" width="200px" height = "200px" />| <img style="border: 0px solid black !important; border-radius:20px; " src="https://user-images.githubusercontent.com/63224278/103209210-ddf00d80-4945-11eb-85c7-3f85ffc9f96c.png" width="200px" height = "200px" />
| :---: | :---: | :---:
[지은](https://github.com/hwangJi-dev) | [원석](https://github.com/snowedev) | [서현](https://github.com/seohyun-106)


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


### 📱 AutoLayout
- iPhone 12 pro
- iPhone 12 mini
- iPhone SE2


<br>
 <br>

## 📜 Coding Convention 

### 📂 폴더구조

* **Resources**
    * AppDelegate
    * SceneDelegate
    * Assets.xcassets
    * Storyboard
    * APIService
        * APIConstant
    * Font

* **Sources**
    * VC
    * Class
    * Cell
    * Model
        * GenericResponse
    * Extension
        
* **Info.plist**

<br>

### ⚙️ 폴더링 규칙

- 폴더링 한 후 Sources 폴더에 있는 파일들은 각 파일 하위에 자신 스토리보드 이름에 해당하는 폴더를 만들어 관리합니다. 

<img width="265" alt="Sources" src="https://user-images.githubusercontent.com/63224278/103229487-71d9cd80-4976-11eb-860d-5e2585cd58f9.png">

- 파일 네이밍 시, 접두에 스토리보드이름을 붙여서 네이밍합니다.
    -  (ex. 스토리보드 이름이 Main, Watering이라고 가정했을 때 cell파일 생성 시 MainBlahblahCVC, WateringBlahblahTVC와 같이 네이밍합니다.)
    
👉🏻 [자세히](https://github.com/TeamCherish/Cherish-iOS/wiki/CodingConvention)


<br>

### 🖋 네이밍

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

### 🏷 주석

- `// MARK:` 를 사용해서 연관된 코드를 구분짓습니다.
- `///` 를 사용해서 문서화에 사용되는 주석을 남깁니다. (ex. /// 사용자 프로필을 그려주는 뷰)
<br>

### 📎 기타

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


다음 스타일 Guide를 참고헀습니다. 👉🏻[Style Guide](https://github.com/StyleShare/swift-style-guide)


<br>
<br>
 
 ## 💻 Github mangement

**아요체리** 들의  WorkFlow : **Gitflow Workflow**

- Master와 Develop 브랜치

  마스터(master): 마스터 브랜치

  개발(develop): 기능들의 통합 브랜치 역할❗️ 이 브랜치에서 기능별로 브랜치를 따 모든 구현이 이루어집니다.

- Master에 직접적인 commit, push는 가급적 금지합니다. (X)

- 커밋 메세지는 다른 사람들이 봐도 이해할 수 있게 써주세요.

- 풀리퀘스트를 통해 코드 리뷰를 해보아요.



<img src="https://camo.githubusercontent.com/5af55d4c184cd61dabf0747bbf9ebc83b358eccb/68747470733a2f2f7761632d63646e2e61746c61737369616e2e636f6d2f64616d2f6a63723a62353235396363652d363234352d343966322d623839622d3938373166396565336661342f30332532302832292e7376673f63646e56657273696f6e3d393133" width="80%">  

   ```
- Master
        ├── dev (Develop)
             ├── HomeTV(각 Local Branch)
             ├── CherishMain    
             └── CherishWatering@@@
   ```
**각자 자신이 맡은 기능 구현에 성공시! 브랜치 다 쓰고 병합하는 방법**

- 브랜치 만듦

```bash
git branch feature/기능이름
```

- 브랜치 전환

```bash
git checkout feature/기능이름
```

- 코드 변경 (현재 **feature/기능이름** 브랜치)

```bash
git add .
git commit -m "커밋 메세지" -a // 이슈보드 이름대로 커밋
```

- 푸시 (현재 **feature/기능이름** 브랜치)

```bash
git push origin feature/기능이름 브랜치
```

- feature/기능 이름 브랜치에서 할 일 다 헀으면 **develop** 브랜치로 전환

```bash
git checkout develop
```

- 머지 (현재 **develop** 브랜치)

```bash
git merge origin feature/기능이름
```

- 다 쓴 브랜치 삭제 (local) (현재 **develop** 브랜치)

```bash
git branch -d feature/기능이름
```

- 다 쓴 브랜치 삭제 (remote) (현재 **develop** 브랜치)

```bash
git push origin :feature/기능이름
```

- develop pull (현재 **develop** 브랜치)

```bash
git pull origin develop
```

- develop push (현재 **develop** 브랜치)

```bash
git push origin develop
```


<br>
