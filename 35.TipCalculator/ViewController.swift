//
//  ViewController.swift
//  9-2_CalTip
//
//  Created by 張睿哲 on 2019/3/22.
//  Copyright © 2019 張睿哲. All rights reserved.
//

import UIKit
import Foundation
import SwiftHEXColors

extension UIButton {
    private func drawBorder(rect:CGRect,color:UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    public func rightBorder(width:CGFloat,deviceRect:CGRect,borderColor:UIColor){
        let rect = CGRect(x: 0, y: deviceRect.width, width: width, height: deviceRect.height * 0.4 / 4)
        drawBorder(rect: rect, color: borderColor)
    }

    public func leftBorder(width:CGFloat,deviceRect:CGRect,borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: width, height: deviceRect.height * 0.4 / 4)
        drawBorder(rect: rect, color: borderColor)
    }
    
    public func topBorder(width:CGFloat,deviceRect:CGRect,borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: deviceRect.width / 4, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    public func buttomBorder(width:CGFloat,deviceRect:CGRect,borderColor:UIColor){
        let rect = CGRect(x: 0, y: deviceRect.height * 0.4 / 4, width: deviceRect.width / 4, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
}

class ViewController: UIViewController {
    var pressArray = [String]()
    var userEnter = ""
    var tipPercent = 15
    var bill:Float = 0.00
    var hotKeys = [5,10,15,20]
    var hotKeyIndex = 2
    var deviceRect = UIScreen.main.bounds
    
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var enterLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nowTipLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet var hotKey: [UIButton]!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet var keyboard: [UIButton]!
    @IBOutlet var tipAddMinus: [UIButton]!
    
    @IBAction func tipAdd(_ sender: UIButton) {
        if tipPercent < 30 {
            tipPercent += 1
            nowTipLabel.text = String(tipPercent) + "%"
            tipLabel.text = String(Float(tipPercent) / 100 * bill)
            tipSlider.value = Float(tipPercent)
            
            checkHotKey()
            calTip()
        }
    }
    
    @IBAction func tipMinus(_ sender: UIButton) {
        if tipPercent > 0 {
            tipPercent -= 1
            nowTipLabel.text = String(tipPercent) + "%"
            tipLabel.text = String(Float(tipPercent) / 100 * bill)
            tipSlider.value = Float(tipPercent)
            
            checkHotKey()
            calTip()
        }
    }
    
    @IBAction func setHotKeyPress(_ sender: UIButton) {
        hotKeys[hotKeyIndex] = Int(tipSlider.value)
        updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        hotKey[hotKeyIndex].setTitle(String(Int(tipSlider.value)) + "%", for: .normal)
        let userDefault = UserDefaults.standard
        userDefault.set(hotKeys, forKey: "hotKeys")
    }
    
    @IBAction func hotKeyPress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            hotKeyIndex = 0
            updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        case 1:
            hotKeyIndex = 1
            updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        case 2:
            hotKeyIndex = 2
            updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        case 3:
            hotKeyIndex = 3
            updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        default:
            break
        }
    }
    
    @IBAction func tipSlider(_ sender: UISlider) {
        sender.value.round()
        tipPercent = Int(sender.value)
        nowTipLabel.text = String(tipPercent) + "%"
        tipLabel.text = String(Float(tipPercent) / 100 * bill)
        
        checkHotKey()
        calTip()
    }
    
    @IBAction func keyboard(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            keyboardEnter(enter:"0")
        case 1:
            keyboardEnter(enter:"1")
        case 2:
            keyboardEnter(enter:"2")
        case 3:
            keyboardEnter(enter:"3")
        case 4:
            keyboardEnter(enter:"4")
        case 5:
            keyboardEnter(enter:"5")
        case 6:
            keyboardEnter(enter:"6")
        case 7:
            keyboardEnter(enter:"7")
        case 8:
            keyboardEnter(enter:"8")
        case 9:
            keyboardEnter(enter:"9")
        case 10:
            keyboardEnter(enter:"+")
        case 11:
            keyboardEnter(enter:"-")
        case 12:
            keyboardEnter(enter:"×")
        case 13:
            keyboardEnter(enter:"÷")
        case 14:
            keyboardEnter(enter:".")
        case 15:
            keyboardEnter(enter:"delete")
        default:
            break
        }
    }
    
    func checkHotKey() {
        for i in hotKeys {
            if i == tipPercent {
                setButton.tintColor = UIColor(hexString: "285DEF")
                break
            }else {
                setButton.tintColor = UIColor.lightGray
            }
        }
    }
    
    func updateHotKey(button:UIButton, index:Int) {
        for btn in hotKey {
            btn.layer.backgroundColor = UIColor(hexString: "000000",alpha: 0.05)?.cgColor
            btn.setTitleColor(UIColor(hexString: "285DEF"), for: .normal)
//            btn.layer.shadowColor = UIColor(hexString: "000000")?.cgColor
//            btn.layer.shadowOffset = CGSize(width: 0, height: 0)
//            btn.layer.shadowOpacity = 0.5
            btn.layer.cornerRadius = 10
        }
        
        button.layer.backgroundColor = UIColor(hexString: "285DEF")?.cgColor
        button.setTitleColor(.white, for: .normal)

        tipSlider.value = Float(hotKeys[index])
        nowTipLabel.text = String(hotKeys[index]) + "%"
        tipPercent = hotKeys[index]
        
        let userDefaultHotKeyIndex = UserDefaults.standard
        userDefaultHotKeyIndex.set(index, forKey: "hotKeyIndex")
        
        checkHotKey()
        calTip()
    }
    
    func keyboardEnter(enter:String){
        switch enter {
        case "1","2","3","4","5","6","7","8","9","0":
            if userEnter == ""{
                userEnter = enter
                pressArray.append(enter)
            //忽略連續輸入兩個0
            }else if Int(pressArray[pressArray.count-1]) == 0{
            }else{
                //若皆是數字則寫入同一個陣列index中
                userEnter = pressArray[pressArray.count-1] + enter
                pressArray[pressArray.count-1] = pressArray[pressArray.count-1] + enter
            }
        case "×","÷","+","-":
            //忽略第一個就輸入運算符號
            if pressArray.isEmpty {
            }else if pressArray[pressArray.count-1] == "×" || pressArray[pressArray.count-1] == "÷" || pressArray[pressArray.count-1] == "+" || pressArray[pressArray.count-1] == "-" {
            }else if pressArray[pressArray.count-1].hasSuffix(".") {
                //如果最後一個index為小數點則補0
                pressArray[pressArray.count-1] = pressArray[pressArray.count-1] + "0"
                pressArray.append(enter)
            }else{
                pressArray.append(enter)
                //清空userEnter
                userEnter = ""
            }
        case ".":
            if pressArray[pressArray.count-1].contains("."){
            }else if pressArray.isEmpty{
                //如果直接輸入小數點，自動補0
                pressArray.append("0.")
            }
            else{
                //小數點維持前一個index
                userEnter = pressArray[pressArray.count-1] + enter
                pressArray[pressArray.count-1] = pressArray[pressArray.count-1] + enter
            }
        case "delete":
            if pressArray.isEmpty{
            }else{
                userEnter = String(pressArray[pressArray.count-1].dropLast())
                pressArray[pressArray.count-1] = String(pressArray[pressArray.count-1].dropLast())
                if pressArray[pressArray.count-1] == ""{
                    pressArray.remove(at: pressArray.count-1)
                }
            }
        default:
            break
        }
        
        //把輸入內容Print出來
        if pressArray.count > 0 {
            enterLabel.text = pressArray.joined(separator:"")
        } else {
            enterLabel.text = "You can use the keyboard!"
        }
        
        calTip()
    }
    
    func calTip() {
        if pressArray.last != "×", pressArray.last != "÷", pressArray.last != "+", pressArray.last != "-"{
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .currency
            //先排除最後輸入為運算子
            //已經清到無內容
            if pressArray.isEmpty{
                bill = 0.0
                
                billLabel.text = formatter.string(from: NSNumber(value: bill))
                tipLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill))
                totalLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill + bill))
            }else{
                bill = calTotal()
                
                billLabel.text = formatter.string(from: NSNumber(value: bill))
                tipLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill))
                totalLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill + bill))
            }
        }
    }
    
    func calTotal() -> Float{
        var calArray = pressArray
        while calArray.joined(separator:",").contains(",×,") {
            for i in 0..<calArray.count - 1 {
                if calArray[i] == "×" && !calArray[i + 1].isEmpty{
                    if let numberA = Float(calArray[i - 1]) , let numberB = Float(calArray[i + 1]){
                        calArray[i - 1] = String(numberA * numberB)
                        calArray.remove(at: i + 1)
                        calArray.remove(at: i)
                        break
                    }
                }
            }
        }
        while calArray.joined(separator:",").contains(",÷,") {
            for i in 0..<calArray.count - 1 {
                if calArray[i] == "÷" && !calArray[i + 1].isEmpty{
                    if let numberA = Float(calArray[i - 1]) , let numberB = Float(calArray[i + 1]){
                        calArray[i - 1] = String(numberA / numberB)
                        calArray.remove(at: i + 1)
                        calArray.remove(at: i)
                        break
                    }
                }
            }
        }
        while calArray.joined(separator:",").contains(",+,") {
            for i in 0..<calArray.count - 1 {
                if calArray[i] == "+" && !calArray[i + 1].isEmpty{
                    if let numberA = Float(calArray[i - 1]) , let numberB = Float(calArray[i + 1]){
                        calArray[i - 1] = String(numberA + numberB)
                        calArray.remove(at: i + 1)
                        calArray.remove(at: i)
                        break
                    }
                }
            }
        }
        //加,,是為了不要讓負數影響
        while calArray.joined(separator:",").contains(",-,") {
            for i in 0..<calArray.count - 1 {
                if calArray[i] == "-" && !calArray[i + 1].isEmpty{
                    if let numberA = Float(calArray[i - 1]) , let numberB = Float(calArray[i + 1]){
                        calArray[i - 1] = String(numberA - numberB)
                        calArray.remove(at: i + 1)
                        calArray.remove(at: i)
                    }
                }
            }
        }
        
        if Double(calArray[0]) != nil{
            return Float(calArray[0])!
        }else{
            return 0.00
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //讀userDefault hotKeys hotKeyIndex 並設定hotKeys
        let userDefaultHotKeys = UserDefaults.standard
        if let hotKeys = userDefaultHotKeys.array(forKey: "hotKeys") as? [Int]{
            self.hotKeys = hotKeys
        }
        let userDefaultHotKeyIndex = UserDefaults.standard
        if let hotKeyIndex = userDefaultHotKeyIndex.object(forKey: "hotKeyIndex") as? Int{
            self.hotKeyIndex = hotKeyIndex
        }
        updateHotKey(button: hotKey[hotKeyIndex], index: hotKeyIndex)
        var i = 0
        for btn in hotKey{
            btn.setTitle(String(hotKeys[i]) + "%", for: .normal)
            i += 1
        }
        
        //繪製鍵盤外框
        for btn in keyboard {
            btn.topBorder(width: 1,deviceRect: deviceRect, borderColor: UIColor(hexString: "000000", alpha: 0.1)!)
            if btn.tag == 0 || btn.tag == 13 || btn.tag == 14 || btn.tag == 15 {
                btn.buttomBorder(width: 1,deviceRect: deviceRect, borderColor: UIColor(hexString: "000000", alpha: 0.1)!)
            }
            if btn.tag != 1 || btn.tag != 4 || btn.tag != 7 || btn.tag != 14 {
                btn.leftBorder(width: 1, deviceRect: deviceRect, borderColor: UIColor(hexString: "000000", alpha: 0.1)!)
            }
        }
        
        let plusImg = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        let minusImg = UIImage(named: "minus")?.withRenderingMode(.alwaysTemplate)
        tipAddMinus[1].setImage(plusImg, for: .normal)
        tipAddMinus[1].tintColor = UIColor(hexString: "285DEF", alpha: 0.75)
        tipAddMinus[0].setImage(minusImg, for: .normal)
        tipAddMinus[0].tintColor = UIColor(hexString: "285DEF", alpha: 0.75)
        
        let hotKeyImg = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        setButton.setImage(hotKeyImg, for: .normal)
        setButton.tintColor = UIColor.lightGray
        checkHotKey()
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        
        billLabel.text = formatter.string(from: NSNumber(value: bill))
        tipLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill))
        totalLabel.text = formatter.string(from: NSNumber(value: Float(tipPercent) / 100 * bill + bill))
        
        keyboard[0].showsTouchWhenHighlighted = true
    }
}


