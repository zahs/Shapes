//
//  Extensions.swift
//  Shapes
//
//  Created by Zhanna Sargsyan on 26/06/2019.
//  Copyright © 2019 Zhanna Sargsyan. All rights reserved.
//

import Foundation
import UIKit

enum Shape {
    case circle
    case triangle
    case star
}

extension UIView {
    
    func show(as shape: Shape) {
        let finalPath = UIBezierPath(rect: self.bounds)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        
        switch shape {
        case .circle:
            drawCircle()
        case . triangle:
            finalPath.append(drawTriangle())
        case .star:
            finalPath.append(drawStar())
        }
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.path = finalPath.cgPath
        self.layer.mask = maskLayer
    }
    
    private func drawCircle() {
        
        let width = self.frame.size.width
        self.layer.cornerRadius = width / 2
    }
    
    private func drawTriangle() -> UIBezierPath {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: self.frame.size.width/2, y: 0))
        trianglePath.addLine(to: CGPoint(x:0, y: self.frame.size.height))
        trianglePath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        trianglePath.close()
        shapeLayer.path = trianglePath.cgPath
        let path = UIBezierPath(rect: self.bounds)
        path.append(trianglePath)
        self.layer.addSublayer(shapeLayer)
        return path
    }
    
    private func drawStar() -> UIBezierPath {
       let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = nil
        
        let starPath = UIBezierPath()
        let center = shapeLayer.position
        
        let numberOfPoints = 5
        let numberOfLineSegments = numberOfPoints * 2
        let theta = .pi / CGFloat(numberOfPoints)
        
        let circumscribedRadius = center.x
        let outerRadius = circumscribedRadius * 1.039
        let excessRadius = outerRadius - circumscribedRadius
        let innerRadius = outerRadius * 0.382
        
        let leftEdgePointX = (center.x + cos(4.0 * theta) * outerRadius) + excessRadius
        let horizontalOffset = leftEdgePointX / 2.0
        
        let offsetCenter = CGPoint(x: center.x - horizontalOffset, y: center.y)
        
        for i in 0..<numberOfLineSegments {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            
            let pointX = offsetCenter.x + cos(CGFloat(i) * theta) * radius
            let pointY = offsetCenter.y + sin(CGFloat(i) * theta) * radius
            let point = CGPoint(x: pointX, y: pointY)
            
            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
        }
        
        var pathTransform  = CGAffineTransform.identity
        pathTransform = pathTransform.translatedBy(x: center.x, y: center.y)
        pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
        pathTransform = pathTransform.translatedBy(x: -center.x, y: -center.y)
        
       // starPath.apply(pathTransform)
        shapeLayer.path = starPath.cgPath
        let path = UIBezierPath(rect: self.bounds)
        path.append(starPath)
        self.layer.addSublayer(shapeLayer)
        return path
    }
    
    func drawStarBezier(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat)->UIBezierPath {
        let path = starPath(x: x, y: y, radius: radius, sides: sides, pointyness:pointyness)
        let bez = UIBezierPath(cgPath: path)
        return bez
    }
    
    
    func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> CGPath {
        let adjustment = 360/sides/2
        let path = CGMutablePath()
        let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius)
        let cpg = points[0]
        let points2 = polygonPointArray(sides: sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        path.move(to: CGPoint(x:cpg.x, y:cpg.y))
        for p in points {
            path.move(to: CGPoint(x:points2[i].x, y:points2[i].y))
            path.addLine(to: CGPoint(x: p.x, y: p.y))
            i += 1
        }
        path.closeSubpath()
        return path
    }
    
    func polygonPointArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat,  adjustment: CGFloat = 0)-> [CGPoint] {
        let angle = degree2radian(a: 360/CGFloat(sides))
        var points = [CGPoint]()
        var i = sides
        while points.count <= i {
            let xpo = x - radius * cos(angle * CGFloat(i)+degree2radian(a: adjustment))
            let ypo = y - radius * sin(angle * CGFloat(i)+degree2radian(a: adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = .pi * a/180
        return b
    }
    
    func pointsOnCircle(with radius: CGFloat, numberOfItems: Int) -> [CGPoint] {
        var points: [CGPoint] = []
        for i in 0..<numberOfItems {
            let angle   = 360/CGFloat(numberOfItems)  * CGFloat(i) * .pi / 180
            let x =  bounds.midX + cos(angle) * radius
            let y =  bounds.midY + sin(angle) * radius
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
       let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
            }
        self.layer.add(rotateAnimation, forKey: nil)
        }
    
    
    func zoomIn(duration : TimeInterval = 1.0, scaleX: CGFloat = 3.0, scaleY: CGFloat = 3.0) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
            self.transform = .identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }

    
    func zoomOut(duration : TimeInterval = 1.0) {
        self.transform = .identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }

    
    func animateAlpha (duration : TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.1
        }, completion: { _ in
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseIn, animations: {
                self.alpha = 1.0
            })
        })
    }

}
