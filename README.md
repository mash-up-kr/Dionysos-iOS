# Dionysos-iOS
## Deployment Info

Target: 13.0

Device: iPhone, iPad

Orientation: Portrait, Landscape Left, Landscape Right

## D**ependency**

### Use

Swift Package Manager

### Frameworks

- Alamofire
- Moya
- SDWebImage
- Firebase
- Promises

## **SwiftLint**

### **installation**

`brew install swiftlint`

### rules

룰은 정해가면서 변경해가는걸로

## **Github Actions**

액션이 동작중이므로 feature -> develop에 PR시에는 빌드가 성공해야지만 머지가 가능합니다.

## 로거

print대신에 logger사용

```swift
logger("test")
```

```swift
 ❤️<23:39:05>  <UI> ViewController.swift viewDidLoad()[15]: "test"
```

## 깃 전략
- PR을 무조건 한다.
- PR을 하기전에 이슈를 만든다.
- 프로젝트를 모각공으로 설정하고, assignment를 할당한다.
- PR생성이후에 이슈 링크를 한다.
- 작업은 이슈별로 피쳐를 따서 feature/작업명
- 커밋은 자율에 맡긴다.
- Squash Merge로만 진행한다.

## UI작업

스토리보드 이용
