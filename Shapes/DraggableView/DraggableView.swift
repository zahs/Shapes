//
//  DraggableButton.swift
//  Shapes
//
//  Created by Zhanna Sargsyan on 26/06/2019.
//  Copyright © 2019 Zhanna Sargsyan. All rights reserved.
//

import Foundation
import UIKit

enum Position {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    case center
}

class DraggableView: UIView {
    
    private var lastLocation = CGPoint(x: 0, y: 0)
    
    var position: Position = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lastLocation = self.center
        if let center = superview?.center {
        if center.x < lastLocation.x {
            position = .bottomLeft
        }
        }
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        self.gestureRecognizers = [panRecognizer]

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        lastLocation = self.center
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        self.gestureRecognizers = [panRecognizer]
    }

    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self)
        
        if let viewToDrag = recognizer.view {
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x, y: viewToDrag.center.y + translation.y)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
        
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            lastLocation = self.center
            updatePosition()
        }
    }
    
    private func updatePosition() {
        guard let superViewCenter = self.superview?.center else {
            return
        }
        if lastLocation.y < superViewCenter.y {
            if lastLocation.x < superViewCenter.x {
                self.position = .topLeft
            } else {
                self.position = .topRight
            }
        } else if lastLocation.y > superViewCenter.y  {
            if lastLocation.x < superViewCenter.x {
                self.position = .bottomLeft
            } else {
                self.position = .bottomRight
            }
        } else if lastLocation.x == superViewCenter.x {
            self.position = .center
        }
    }

}
