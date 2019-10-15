//
//  Model.swift
//  35.TipCalculator
//
//  Created by littlema on 2019/6/6.
//  Copyright © 2019 張睿哲. All rights reserved.
//

import Foundation


func calculator(inputHistory: [String]) -> Double {
    var calArray = removeLastOperator(origin: inputHistory)
    var total: Double = 0
    let lists = ["×","÷","-"]

    for list in lists {
        while calArray.contains(list) {
            for i in 0..<calArray.count {
                if calArray[i] == list, i <= (calArray.count - 2) {
                    if let numberA = Double(calArray[i - 1]) , let numberB = Double(calArray[i + 1]){
                        calArray[i - 1] = check(numberA: numberA, numberB: numberB, operatorString: list)
                        calArray.remove(at: i + 1)
                        calArray.remove(at: i)
                        break
                    }
                }
            }
        }
    }
    
    for i in 0..<calArray.count {
        if calArray[i] != "+" {
            if let number = Double(calArray[i]) {
                total += number
            }
        }
    }
    
    return total
}

func removeLastOperator(origin: [String]) -> [String] {
    if origin.count > 0 {
        let index = origin.count - 1
        var rr = origin
        if let temp = PressType(rawValue: origin[index]), temp.operation == .command {
            rr.remove(at: index)
            return rr
        }
    }
    return origin
}

func check(numberA: Double, numberB: Double, operatorString: String) -> String {
    switch operatorString {
    case "×": return String(numberA * numberB)
    case "÷": return String(numberA / numberB)
    case "-": return String(numberA - numberB)
    default: return ""
    }
}
