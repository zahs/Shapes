//
//  ViewController.swift
//  Shapes
//
//  Created by Zhanna Sargsyan on 25/06/2019.
//  Copyright © 2019 Zhanna Sargsyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleMenu: CircleMenu!
    @IBOutlet weak var triangleView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var circleImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.circleMenu.delegate = self
        self.triangleView.show(as: .triangle)
        self.starView.show(as: .star)
        self.circleImageView.show(as: .circle)
    }

}

extension ViewController: CircleMenuDelegate {
    func didPress(on menuItem: MenuItem) {
        switch circleMenu.position {
        case .topRight:
            zoomIn(menuItem: menuItem)
        case .topLeft:
            amimateAlpha(menuItem: menuItem)
        case .center:
            rotate(menuItem: menuItem)
            zoomIn(menuItem: menuItem)
        case .bottomRight:
            rotate(menuItem: menuItem)
        case .bottomLeft:
            rotate(menuItem: menuItem)
        }
    }

    
    func zoomIn(menuItem: MenuItem) {
        switch menuItem {
            case .circle:
                circleImageView.zoomIn()
            case .triangle:
                triangleView.zoomIn()
            case .star:
                starView.zoomIn()
        }
    }
    
    func amimateAlpha(menuItem: MenuItem) {
        switch menuItem {
        case .circle:
            circleImageView.animateAlpha()
        case .triangle:
            triangleView.animateAlpha()
        case .star:
            starView.animateAlpha()
        }
    }
    
    func rotate(menuItem: MenuItem) {
        switch menuItem {
        case .circle:
            circleImageView.rotate360Degrees()
        case .triangle:
            triangleView.rotate360Degrees()
        case .star:
            starView.rotate360Degrees()
        }
    }
    
}
