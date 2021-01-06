//
//  MyChartView.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class MyChartView: UIView {
    var brownC: CGFloat = 5.0
        var lightBlueC: CGFloat = 5.0
        var orangeC: CGFloat = 10.0
        var blueC: CGFloat = 80.0
        
    override func draw(_ rect: CGRect) {
        let rad: CGFloat = 88.0
        let brown = UIBezierPath()
        let lightBlue = UIBezierPath()
        let orange = UIBezierPath()
        let blue = UIBezierPath()
        brown.lineWidth = 35.0
        lightBlue.lineWidth = 35.0
        orange.lineWidth = 35.0
        blue.lineWidth = 35.0
        brown.addArc(withCenter: CGPoint(x: self.bounds.width/CGFloat(2.0), y: self.bounds.height/CGFloat(2.4)), radius: rad, startAngle: 0, endAngle: 2*CGFloat.pi*brownC/100, clockwise: true)
        lightBlue.addArc(withCenter: CGPoint(x: self.bounds.width/CGFloat(2.0), y: self.bounds.height/CGFloat(2.4)), radius: rad, startAngle: 2*CGFloat.pi*brownC/100, endAngle: 2*CGFloat.pi*(brownC+lightBlueC)/100, clockwise: true)
        orange.addArc(withCenter: CGPoint(x: self.bounds.width/CGFloat(2.0), y: self.bounds.height/CGFloat(2.4)), radius: rad, startAngle: 2*CGFloat.pi*(brownC+lightBlueC)/100, endAngle: 2*CGFloat.pi*(brownC+lightBlueC+orangeC)/100, clockwise: true)
        blue.addArc(withCenter: CGPoint(x: self.bounds.width/CGFloat(2.0), y: self.bounds.height/CGFloat(2.4)), radius: rad, startAngle: 2*CGFloat.pi*(brownC+lightBlueC+orangeC)/100, endAngle: 2*CGFloat.pi*(brownC+lightBlueC+orangeC+blueC)/100, clockwise: true)
        UIColor.brown.setStroke()
        brown.stroke()
        UIColor.systemBlue.setStroke()
        lightBlue.stroke()
        UIColor.orange.setStroke()
        orange.stroke()
        UIColor.blue.setStroke()
        blue.stroke()
    }
}
