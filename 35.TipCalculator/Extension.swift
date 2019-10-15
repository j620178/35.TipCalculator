//
//  Extension.swift
//  35.TipCalculator
//
//  Created by littlema on 2019/5/22.
//  Copyright © 2019 張睿哲. All rights reserved.
//
import UIKit
import Foundation

extension UIColor {
    convenience init(hexString: String, alphaPercent: Double) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        let a  = CGFloat(alphaPercent) * 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}

extension UIColor {
    static func borderColor() -> UIColor {
        return UIColor(hexString: "#EEEEEE", alphaPercent: 1)
    }

    static func systemTintColor() -> UIColor {
        return UIColor(hexString: "#5352ed", alphaPercent: 1)
    }
    
    static var keyboardColor: UIColor = {
        return  UIColor(hexString: "#2f3542", alphaPercent: 1)
    }()
    
    static var keyboardClickColor: UIColor = {
        return  UIColor(hexString: "#57606f", alphaPercent: 1)
    }()
}

extension UIButton {    
    enum ButtonBorderDirection {
        case top
        case bottom
        case left
        case right
    }
    

    func drawButtonBorder(deviceRect: CGRect, borderWidth: CGFloat, borderColor: UIColor, direction: ButtonBorderDirection) {
        var rect: CGRect
        
        switch direction {
        case .top:
            rect = CGRect(x: 0, y: 0, width: deviceRect.width / 4, height: borderWidth)
        case .bottom:
            rect = CGRect(x: 0, y: deviceRect.height * 0.4 / 4, width: deviceRect.width / 4, height: borderWidth)
        case .left:
            rect = CGRect(x: 0, y: 0, width: borderWidth, height: deviceRect.height * 0.4 / 4)
        case .right:
            rect = CGRect(x: 0, y: deviceRect.width, width: borderWidth, height: deviceRect.height * 0.4 / 4)
        }

        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = borderColor.cgColor
        self.layer.addSublayer(lineShape)
    }
}

extension String {
    static let defaultValue = "0"
    
    var isContainPoint: Bool {
        return self.contains(".")
    }
    
    var withPoint: String {
        var value = self
        if value.last == "." {
            value.removeLast()
        }
        return value
    }
    
    var isDefaultVaule: Bool {
        return self == .defaultValue
    }
    
    var value: Double {
        return Double(withPoint) ?? 0.0
    }
}

extension Int {
    var toDouble: Double {
        let value = self
        return Double(value) / 100
    }
}

extension Double {
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
