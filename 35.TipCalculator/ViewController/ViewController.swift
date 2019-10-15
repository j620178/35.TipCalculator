//
//  ViewController.swift
//  9-2_CalTip
//
//  Created by littlema on 2019/3/22.
//  Copyright © 2019 littlema. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UpdateValueDelegate {
    struct TipPercentBar {
        static let max = 30
        static let min = 0
    }
    
    var tipPercent: Int = 15
    var bill: Double = 0
    var tipShortcuts = [5, 10, 15, 20]
    var currentShortcutIndex = 2
    var currentThemeColor = UIColor.systemTintColor()
    
    @IBOutlet weak var billValueLabel: UILabel!
    @IBOutlet weak var enterHistoryLabel: UILabel!
    @IBOutlet weak var currentTipLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalBackgroundView: UIView!

    @IBOutlet weak var setButton: UIButton!
    @IBOutlet var shortcutButtons: [UIButton]!
    @IBOutlet var tipAdjustButton: [UIButton]!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var keyboardBelowView: UIView!
//    @IBOutlet weak var keyboardViewContainer: UIView!
    @IBOutlet weak var containerKeyboardStackView: UIStackView!
    @IBOutlet weak var row0KeyboradStackView: UIStackView!
    @IBOutlet weak var row1KeyboradStackView: UIStackView!
    @IBOutlet weak var row2KeyboradStackView: UIStackView!
    @IBOutlet weak var row3KeyboradStackView: UIStackView!
    
    var model = ControlModel()
    
    struct ViewData {
        var view: UIStackView
        var pressButtons: [PressType]
    }

    var row0Keyboard: [PressType] = [.seven, .eight, .nine, .addition]
    var row1Keyboard: [PressType] = [.four, .five, .six, .subtraction]
    var row2Keyboard: [PressType] = [.one, .two, .three, .multiplication]
    var row3Keyboard: [PressType] = [.point, .zero, .delete, .division]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateKeyboard()
        setupUI()
        
        model.delegate = self
    }
    
    
    @IBAction func tipAdjust(_ sender: UIButton) {
        if sender.tag == 1, tipPercent < TipPercentBar.max {
            tipPercent += 1
        } else if sender.tag == 2, tipPercent < TipPercentBar.max {
            tipPercent -= 1
        }
        tipSlider.value = Float(tipPercent)
        updateDisplayValue()
    }
    
    @IBAction func setShortcut(_ sender: UIButton) {
        let value = Int(tipSlider.value)
        tipShortcuts[currentShortcutIndex] = value
        shortcutButtons[currentShortcutIndex].setTitle("\(value)%", for: .normal)
        switchShortcut(currentIndex: currentShortcutIndex)

        let userDefaultShortcutList = UserDefaults.standard
        userDefaultShortcutList.set(tipShortcuts, forKey: "shortcutList")
    }
    
    @IBAction func shortcutButtonPress(_ sender: UIButton) {
        switch sender.tag {
        case 0: currentShortcutIndex = 0
        case 1: currentShortcutIndex = 1
        case 2: currentShortcutIndex = 2
        case 3: currentShortcutIndex = 3
        default: break
        }
        
        let userDefaultShortcutList = UserDefaults.standard
        userDefaultShortcutList.set(currentShortcutIndex, forKey: "currentShortcutIndex")
        switchShortcut(currentIndex: currentShortcutIndex)
    }
    
    @IBAction func tipSlider(_ sender: UISlider) {
        sender.value.round()
        tipPercent = Int(sender.value)
        isShortcut()
        updateDisplayValue()
    }
    
    
    func isShortcut() {
        for shortcut in tipShortcuts {
            if shortcut == Int(tipPercent) {
                setButton.tintColor = UIColor.systemTintColor()
                break
            }else {
                setButton.tintColor = UIColor.borderColor()
            }
        }
    }
    
    func switchShortcut(currentIndex index: Int) {
        var i = 0
        for btn in shortcutButtons {
            btn.layer.backgroundColor = UIColor.borderColor().cgColor
            btn.setTitleColor(currentThemeColor, for: .normal)
            btn.setTitle("\(tipShortcuts[i])%", for: .normal)
            btn.layer.cornerRadius = 10
            if btn.tag == index {
                shortcutButtons[index].layer.backgroundColor = currentThemeColor.cgColor
                shortcutButtons[index].setTitleColor(.white, for: .normal)
            }
            i += 1
        }
        
        tipSlider.value = Float(tipShortcuts[index])
        tipPercent = tipShortcuts[index]
        
        updateDisplayValue()
    }
    
    func updateDisplayValue() {
        let tipValue = bill * tipPercent.toDouble
        let total = tipValue + bill
        
        billValueLabel.text = "$\(bill.roundTo(places: 2).cleanZero)"
        currentTipLabel.text = "\(tipPercent)%"
        tipValueLabel.text = tipValue.roundTo(places: 2).cleanZero
        totalValueLabel.text = "$\(total.roundTo(places: 2).cleanZero)"
    }
    
    func updateInputHistory(inputHistory: String) {
        self.enterHistoryLabel.text = inputHistory
    }
    
    func updateBill(bill: Double) {
        self.bill = bill
        updateDisplayValue()
    }
}

extension ViewController {
    func setupUI() {
        //讀userDefault Shortcut currentShortcutIndex 並設定
        let userDefaultShortcut = UserDefaults.standard
        if let shortcutList = userDefaultShortcut.array(forKey: "shortcutList") as? [Int]{
            self.tipShortcuts = shortcutList
        }
        let userDefaultCurrentShortcutIndex = UserDefaults.standard
        if let currentShortcutIndex = userDefaultCurrentShortcutIndex.object(forKey: "currentShortcutIndex") as? Int{
            self.currentShortcutIndex = currentShortcutIndex
        }
        
        //shortcut
        let shortcutImg = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        setButton.setImage(shortcutImg, for: .normal)
        setButton.tintColor = currentThemeColor
        shortcutButtons = shortcutButtons.sorted(by: { $0.tag < $1.tag})
        switchShortcut(currentIndex: currentShortcutIndex)
        
        //tipSlider
        tipSlider.thumbTintColor = currentThemeColor
        tipSlider.minimumTrackTintColor = currentThemeColor
        
        //tipAdjustButton
        let plusImg = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        let minusImg = UIImage(named: "minus")?.withRenderingMode(.alwaysTemplate)
        tipAdjustButton[1].setImage(plusImg, for: .normal)
        tipAdjustButton[1].tintColor = currentThemeColor
        tipAdjustButton[0].setImage(minusImg, for: .normal)
        tipAdjustButton[0].tintColor = currentThemeColor
        
        //label
        tipTextLabel.textColor = currentThemeColor
        totalTextLabel.textColor = currentThemeColor
        tipValueLabel.textColor = currentThemeColor
        totalValueLabel.textColor = currentThemeColor
        totalBackgroundView.backgroundColor = currentThemeColor.withAlphaComponent(0.15)
        
        isShortcut()
        updateDisplayValue()
    }
    
    func generateKeyboard() {
        let viewDatas: [ViewData] = [
            ViewData(view: row0KeyboradStackView, pressButtons: row0Keyboard),
            ViewData(view: row1KeyboradStackView, pressButtons: row1Keyboard),
            ViewData(view: row2KeyboradStackView, pressButtons: row2Keyboard),
            ViewData(view: row3KeyboradStackView, pressButtons: row3Keyboard)]
        
        for aView in viewDatas {
            setupKeyboard(aView: aView)
        }
    }
    
    func setupKeyboard(aView: ViewData) {
        for aType in aView.pressButtons {
            let button = UIButton()
            button.setTitle(aType.name, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.keyboardColor
            button.addTarget(self, action: #selector(tap(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
            aView.view.addArrangedSubview(button)
        }
        keyboardBelowView.backgroundColor = UIColor.keyboardColor
    }
    
    @objc func tap(_ button:UIButton) {
        button.backgroundColor = UIColor.keyboardClickColor
    }
    
    @objc func didTap(_ button:UIButton) {
        guard let text = button.title(for: .normal),let aPressType: PressType = PressType(rawValue: text) else { return }
        model.userTap(press: aPressType)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.backgroundColor = UIColor.keyboardColor
    }
    
}
