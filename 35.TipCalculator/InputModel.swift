//
//  InputModel.swift
//  35.TipCalculator
//
//  Created by littlema on 2019/6/29.
//  Copyright © 2019 張睿哲. All rights reserved.
//

import Foundation

protocol UpdateValueDelegate {
    func updateInputHistory(inputHistory: String) -> Void
    func updateBill(bill: Double) -> Void
}

struct PressData {
    var inputHistory = [String]()
    var inputCount: Int {
        var count = 0
        for word in inputHistory {
            count += word.count
        }
        return count
    }
    var status = [InputState.null]
}

class ControlModel {
    private var pressData = PressData()
    
    var delegate: UpdateValueDelegate?
    
    func userTap(press: PressType) {
        if pressData.inputCount < 10 || press == .delete {
            press.state.pressKeyboard(press: press, data: &pressData)
            delegate?.updateInputHistory(inputHistory: dataToText(displays: pressData.inputHistory))
            delegate?.updateBill(bill: calculator(inputHistory: pressData.inputHistory))
        }
    }
    
    func dataToText(displays: [String]) -> String {
        var temp = String()
        for aDisplays in displays {
            temp += aDisplays
        }
        return temp
    }
}


protocol OperationState {
    func pressKeyboard(press: PressType, data: inout PressData)
}

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

class NumberPress: NumberOperationState {}



protocol PointOperationState: OperationState {}

extension PointOperationState {
    func pressKeyboard(press: PressType, data: inout PressData) {
        if data.status.last == .null {
            data.inputHistory.append("0.")
            data.status.append(.zero)
            data.status.append(.number)
        } else if data.status.last == .number || data.status.last == .zero {
            let index = data.inputHistory.count - 1
            guard !data.inputHistory[index].isContainPoint else { return }
            data.inputHistory[index] += press.name
            data.status.append(.number)
        }
    }
}

class PointPress: PointOperationState {}



protocol CommandOperationState: OperationState {}

extension CommandOperationState {
    func pressKeyboard(press: PressType, data: inout PressData) {
        if data.status.last != .null, data.inputHistory.count > 0 {
            data.inputHistory.append(press.name)
            data.status.append(.null)
        }
    }
}

class CommandPress: CommandOperationState {}



protocol DeleteOperationState: OperationState {}

extension DeleteOperationState {
    func pressKeyboard(press: PressType, data: inout PressData) {
        if data.inputHistory.count > 0 {
            let index = data.inputHistory.count - 1
            
            if data.inputHistory[index].count == 1, data.inputHistory.count == 1 {
                data.inputHistory.remove(at: index)
                data.status = [.null]
            } else if data.inputHistory[index].count == 1 {
                data.inputHistory.remove(at: index)
                
                let i = data.status.count - 1
                data.status.remove(at: i)
            } else {
                var word = data.inputHistory[index]
                word.remove(at: word.index(before: word.endIndex))
                data.inputHistory[index] = word
                
                let i = data.status.count - 1
                data.status.remove(at: i)
            }
        }
    }
}

class DeletePress: DeleteOperationState {}
