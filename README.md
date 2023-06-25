# 계산기


## 📖 목차
1. [소개](#-소개)
2. [팀원](#-팀원)
3. [시각화된 프로젝트 구조](#-시각화된-프로젝트-구조)
4. [실행 화면](#-실행-화면)
5. [트러블 슈팅](#-트러블-슈팅)
6. [참고 링크](#-참고-링크)

</br>

## 🍀 소개
사용자로부터 UI 입력을 받아 계산기 동작을 수행하는 프로그램입니다.

* 주요 개념: `UIKit`, `Outlet/Action`, `OOP`, `SOLID`, `Queue`, `Linked-List`

</br>

## 👨‍💻 팀원
| Zion |
| :--------: |
|<Img src= "https://hackmd.io/_uploads/rJqMfSoVn.png" width="200" height="200"> |
|[Github Profile](https://github.com/LeeZion94) |

## 👀 시각화된 프로젝트 구조


### Diagram
![UML](UML.png)
</br>

## 💻 실행 화면 
|입력을 받은 수 계산화면|소수점 입력을 받은 수 계산화면|
|:--:|:--:|
|<img src="https://hackmd.io/_uploads/ryrYSutvn.gif?" width="400">|<img src="https://hackmd.io/_uploads/H1jZLdFv3.gif" width="400">|

|이전 결과값에 이어서 계산하는 화면|AllClear로 결과값을 전부 지우는 실행화면|
|:--:|:--:|
|<img src="https://hackmd.io/_uploads/BJQ7UdYv3.gif" width="400">|<img src="https://hackmd.io/_uploads/Hy6XUOKwh.gif" width="400">|


</br>

## 🧨 트러블 슈팅

1️⃣ 시간복잡도 <br>
-
🔒 **문제점** <br>
`Queue`를 구현할 수 있는 자료구조`(Array, DoubleStack, Linked-List)` 중 어떤 자료구조를 선택하여 `Queue`를 구현했을 때의 시간복잡도가 제일 낮을 수 있는지 고민했습니다.
`enqueue`와 `dequeue` 중 둘중 한개의 기능이 `O(n)`을 가지고 있기 때문에 `enqueue`와 `dequeue` 모두 `O(1)`로 가지는 자료구조를 구현하고자 했습니다.

🔑 **해결방법** <br>
[DoubleStack vs Linked-List 정리 자료](https://medium.com/@LeeZion94/linked-list-vs-double-stack-big-o-9fbc1624c240)
`Double Stack`을 사용하여 문제를 해결하고자 했지만 `Double Stack`의 핵심 로직중 `reversed()` 메서드의 빅오는 `O(1)`이지만 이를 변수로 할당할 때 즉 인덱싱 할 때 `O(1)`가 깨지는 것으로 확인되어 `Sigle Linked List`에서 `head`, `tail` 포인터를 두어 `enqueue`와 `dequeue`시 모두 빅오를 `O(1)` 가질 수 있도록 구현했습니다.

```swift
struct CalculatorItemQueue<Element: CalculateItem>: Queueable {
    private var head: Item<Element>?
    private var tail: Item<Element>?
    
    mutating func enqueue(element: Element) {
        let item = Item(element)
        
        if head == nil {
            head = item
            tail = item
            return
        }
        
        tail?.next = item
        tail = item
    }
    
    mutating func dequeue() -> Element? {
        guard head != nil else { return nil }
        
        let element = head?.element
        
        head = head?.next
        return element
    }
}
```


<br>

2️⃣ 노드 메모리 해제 <br>
-
🔒 **문제점** <br>
swift와 같은 ARC환경에서의 각각의 노드들에 대한 메모리해제가 어떻게 진행될 수 있는지 고민했습니다.

🔑 **해결방법** <br>
특정 인스턴스에 대한 Reference Count가 아무도 참조하고 있지 않음을 나타내는 순간 ARC를 통해 해당 객체나 인스턴스는 해제되게 됩니다. 따라서 구현한 링크드 링크드리스트의 head 및 tail을 지칭하고 있는 포인터를 가지고 있기 때문에 Queue가 해제될 때 해당 포인터들을 해제하면서 연결된 모든 노드들을 순차적으로 해제하게 됨을 알 수 있었습니다.

또한, dequeue 시 head에 대한 포인터를 변경할 때 이전의 head 포인터를 가지고 있지 않더라도 reference count가 줄었을 때 이전 head를 알아서 메모리 해제하기 때문에 추가적인 메모리 해제로직을 작성할 필요가 없다는 것을 알게되었습니다.
<br>

3️⃣ **UI를 갱신하는 타이밍 고민** <br>

🔒 **문제점** <br>
계산기의 계산식이 추가될 때마다 ScrollView내부의 StackView에 계산식이 쌓이고 늘어난 Scroll ContentSize에 ScrollToBottom을 해주는 로직을 추가했습니다.

하지만, 계산식이 추가되어 스크롤이 될 때마다 한 개의 계산식 만큼 밀려서 스크롤이 되는 현상이 이슈로 나타나게되었습니다.

🔑 **해결방법** <br>
원인은 UI의 갱신 타이밍이었습니다. ScrollView내부의 StackView에 계산식이 쌓이고 늘어난 ScrollView에 대해 ScrollToBottom이 되어야 했지만 늘어나기 이전의 ContentSize를 기준으로 ScrollToBottom 동작을 하게되어 해당 이슈가 발생했습니다.

따라서, 해당 이슈를 해결하기 위해 UI를 갱신하기 위한 메서드들을 살펴봤습니다.
정리한 내용을 같이 공유드립니다! [UI 갱신 메서드 비교](https://medium.com/@LeeZion94/layoutifneeded-vs-setneedslayout-23a29471582a)


4️⃣ **비슷한 기능 및 역할을 하는 객체의 네이밍에 대한 고민** 

🔒 **문제점** <br>
소수점, 정수, operand, operator와 같이 비슷한 기능 및 역할을 하지만 조금씩은 다른 특징을 가지는 객체에 대한 네이밍을 정하는데 있어서 많은 어려움이 있었습니다. 따라서 이러한 것들이 쌓이다보니 나중에는 해당 객체가 어떤 역할을 하는지 한번 더 생각해야하는 고민이 늘게 되었습니다.

🔑 **해결방법** <br>
우선 해당 객체의 네이밍의 범위를 해치지 않는 선에서 통합할 수 있는 기능 및 역할들을 통합했습니다. 또한 분명하게 구분지어져야하는 property 및 method에 대해서는 네이밍이 조금은 더 길어지더라도 분명하게 역할이 나누어질 수 있도록 키워드를 추가하여 작성했습니다. Swift Language Guide에서도 언급하고 있듯이 간결함 보다는 명료함에 초점을 맞춘 네이밍을 가져가고자 했습니다.

그 결과, 계산기의 기능 및 동작을 하는데 있어서 역할의 분명함 뿐만 아니라, 역할에 따라 나누다 보니 했던 개체들의 기능분리를 통해 프로그램의 전체적인 가독성의 상승과 유지보수성이 좋아지겠되었습니다.

</br>

## 📚 참고 링크
- [🍎Apple Docs: reversed() ](https://developer.apple.com/documentation/swift/array/reversed())
- [🍎Apple Docs: reversedcollection](https://developer.apple.com/documentation/swift/reversedcollection)
- [🍎Apple Docs: bidirectionalcollection](https://developer.apple.com/documentation/swift/bidirectionalcollection)
- [📘stackoverflow: Array Indexing performance ](https://stackoverflow.com/questions/68332664/is-swift-array-reversedn-efficient-or-not)
</br>
