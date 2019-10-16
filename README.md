# TipCalculator

一個簡單快速的小費計算工具 App

[<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160">](https://apps.apple.com/tw/app/simplecaltip/id1472924509)

### Features
* 計算資訊
    - 輸入內容
    - 小費金額
    - 總計結果
* 小費比例
    - Slider bar 快速調整
    - 按鈕微調
    - 選取 / 加入 常用比例
* 客製化鍵盤
    - 支援四則運算
    - 支援小數點

### Key Skills Gained
將各個鍵盤按鈕以 `PressType` enum 管理
``` swift
enum PressType: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case addition = "+"
    case subtraction = "-"
    case multiplication = "×"
    case division = "÷"
    case point = "."
    case delete = "⌫"
}
```

擴充 `PressType` 功能，透過 `operation` 可知按鈕運算類型，`state` 運算方式
``` swift
extension PressType {
    var name: String {
        return rawValue
    }
    
    var operation: OperationType {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return .number
        case .addition, .subtraction, .multiplication, .division:
            return .command
        case .delete:
            return .delete
        case .point:
            return .point
        }
    }
    
    var state: OperationState {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return NumberPress()
        case .addition, .subtraction, .multiplication, .division:
            return CommandPress()
        case .delete:
            return DeletePress()
        case .point:
            return PointPress()
        }
    }
}
```
實作 `pressKeyboard` 函式，完成實際運算功能
``` swift
protocol NumberOperationState: OperationState {}

extension NumberOperationState {
    func pressKeyboard(press: PressType, data: inout PressData) {
        if data.status.last == .null {
            data.inputHistory.append(press.name)
            if press == .zero {
                data.status.append(.zero)
            } else {
                data.status.append(.number)
            }
        } else if data.status.last == .zero, press != .zero {
            let index = data.inputHistory.count - 1
            data.inputHistory[index] = press.name
            data.status.removeLast()
            data.status.append(.number)
        } else if data.status.last == .number {
            let index = data.inputHistory.count - 1
            data.inputHistory[index] += press.name
            data.status.append(.number)
        }
    }
}
```
### Requirements
* iOS 12
* Xcode 10

### Contact
litlema0404@gmail.com