//
//  ViewController.swift
//  colorBlending
//
//  Created by danny santoso on 15/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewColorb: UIView!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var labelText: UILabel!
    var a:[CGFloat] = []
    var b:[CGFloat] = []
    var colora:UIColor?
    var colorb:UIColor?
    
    var colorPacket:[String] = ["#E5E4E2","#19191C","#00FFFF","#FF00FF","#CA1F7B","#FF0090","#00B7EB","#4682b4","#000000"]
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        colora = hexStringToUIColor(hex: "#E4E3DB")
        colorb = hexStringToUIColor(hex: "#18181A")
        
        let testColor = addColor(multiplyColor(colora!, by: 0.1009), with: multiplyColor(colorb!, by: 0.8991))
        
        
        print(rgbToHex(color: testColor))
        
        var a = getPercentage2(testColor)
        
        
        let colorfinal = addColor(multiplyColor(colora!, by: a[0]), with: multiplyColor(colorb!, by: a[1]))
        
//        viewColorb.backgroundColor = colorfinal
        viewColor.backgroundColor = testColor
        
        labelText.text = "C :\(a[0])  M:\(a[1])"
        
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let colora = hexStringToUIColor(hex: tf1.text!)
        let colorb = hexStringToUIColor(hex: tf3.text!)
        
        let percenta = Int(tf2.text!)
        let percentb = Int(tf4.text!)
        
        
        var fcolor = addColor(multiplyColor(colora, by: CGFloat(percenta ?? 0)/100), with: multiplyColor(colorb, by: CGFloat(percentb ?? 0)/100))
        if tf5.text?.isEmpty == false{
            let colorc = hexStringToUIColor(hex: tf5.text!)
            let percentc = Int(tf6.text!)
            fcolor = addColor(fcolor, with: multiplyColor(colorc, by: CGFloat(percentc ?? 0)/100))
        }
        
        viewColorb.backgroundColor = fcolor
        
    }
    
    func rgbToHex(color: UIColor) -> String {
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
    
    func getPercentage(_ testColor:UIColor, _ color1:UIColor, _ color2:UIColor)->[CGFloat]{

        let percentage1 = (testColor.greenValue - color2.greenValue) / (color1.greenValue - color2.greenValue)
        let percentage2 = 1 - percentage1
        //                    let percentage3:CGFloat = CGFloat(j) / 100
        let blendColor = addColor(multiplyColor(color1, by: percentage1), with: multiplyColor(color2, by: percentage2))
        print(percentage1)
        print(percentage2)
        if testColor == blendColor, percentage1 + percentage2 == 1{
            return [percentage1, percentage2]
        }
        
        return [0,0]
    }
    
    func getPercentage2(_ testColor:UIColor)->[CGFloat]{
        
        for i in 0...colorPacket.count - 1 {
            for y in 0...colorPacket.count - 1 {
                let color1 = hexStringToUIColor(hex: "\(colorPacket[i])")
                let color2 = hexStringToUIColor(hex: "\(colorPacket[y])")
                
                
                let percentage1 = (testColor.greenValue - color2.greenValue) / (color1.greenValue - color2.greenValue)
                let percentage2 = 1 - percentage1
                //                    let percentage3:CGFloat = CGFloat(j) / 100
                let blendColor = addColor(multiplyColor(color1, by: percentage1), with: multiplyColor(color2, by: percentage2))
                
                
                if testColor == blendColor, percentage1 + percentage2 == 1{
                    print(colorPacket[i])
                    print(colorPacket[y])
                    print(percentage1)
                    print(percentage2)
                    return [percentage1, percentage2]
                }
            }
        }
        return [0,0]
    }
    
    func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
    
    func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}




extension UIColor {
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    

    
    
}
