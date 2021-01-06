//
//  MyGraphView.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class MyGraphView: UIView {
    var dependence: ((Double) -> Double)? { didSet { setNeedsDisplay() } }
    var originSet: CGPoint? { didSet { setNeedsDisplay() } }
    private var origin: CGPoint {
        get {
            return originSet ?? CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        set {
            originSet = newValue
        }
    }
    
    private var axesDrawes = ShowXY()
    override func draw(_ rect: CGRect) {
        axesDrawes.contentScaleFactor = contentScaleFactor
        axesDrawes.color = UIColor.red
        axesDrawes.drawAxes(in: bounds, origin: origin, pointsPerUnit: 25.85)
        drawCurveInRect(bounds, origin: origin, scale: 25.85)
    }
    
    func drawCurveInRect(_ bounds: CGRect, origin: CGPoint, scale: CGFloat) {
        var xGraph, yGraph: CGFloat
        var x, y: Double
        var isFirstPoint = true
        
        let oldYGraph: CGFloat = 0.0
        var disContinuity: Bool {
            return abs(yGraph - oldYGraph) > max(bounds.width, bounds.height) * 1.5
        }
        
        if dependence != nil {
            UIColor.black.set()
            let path = UIBezierPath()
            path.lineWidth = 1.0
            
            var xArray: [Double] = []
            for i in -4...4 {
                xArray.append(Double(i))
                if i == 4 {
                    break
                }
                for _ in 0...4 {
                    xArray.append(Double(0))
                }
            }
            var i: Int = 0
            while i < xArray.count {
                if Int(xArray[i]) == 4 {
                    break
                }
                xArray[i + 1] = xArray[i] + 0.15
                xArray[i + 2] = xArray[i] + 0.3
                xArray[i + 3] = xArray[i] + 0.55
                xArray[i + 4] = xArray[i] + 0.75
                xArray[i + 5] = xArray[i] + 0.92
                i = i + 6
            }
            
            for i in xArray{
                x = Double(i)
                xGraph = CGFloat(x) * scale + origin.x
                y = (dependence)!(x)
                guard y.isFinite else {
                    continue
                }
                yGraph = origin.y - CGFloat(y) * scale
                if isFirstPoint {
                    path.move(to: CGPoint(x: xGraph, y: yGraph))
                    isFirstPoint = false
                } else {
                    if disContinuity {
                        isFirstPoint = true
                    } else {
                        path.addLine(to: CGPoint(x: xGraph, y: yGraph))
                    }
                }
            }
            path.stroke()
        }
    }
}
