//
//  KeyboardType.swift
//  35.TipCalculator
//
//  Created by littlema on 2019/6/5.
//  Copyright © 2019 張睿哲. All rights reserved.
//

import Foundation

enum PressType:String {
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

enum OperationType {
    case number
    case command
    case delete
    case point
}

enum InputState {
    case null
    case number
    case zero
}

