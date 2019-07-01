//
//  CircleMenu.swift
//  Shapes
//
//  Created by Zhanna Sargsyan on 30/06/2019.
//  Copyright © 2019 Zhanna Sargsyan. All rights reserved.
//

import Foundation
import UIKit

enum MenuItem {
    case triangle
    case circle
    case star
}

protocol CircleMenuDelegate {
    func didPress(on menuItem: MenuItem)
}

class CircleMenu: DraggableView {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
   
    
    var isExpanded: Bool = false
    var delegate: CircleMenuDelegate?
    
    // MARK: - Actions
    @IBAction func menuButtonAction(_ sender: Any) {
        isExpanded = !isExpanded
        changeMenuIcon(sender)
        let numberOfItems = 3
        let points = self.pointsOnCircle(with: self.bounds.size.width / 2 - 10, numberOfItems: numberOfItems)
        if isExpanded {
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.circleButton.isHidden = !self.isExpanded
                self.triangleButton.isHidden = !self.isExpanded
                self.starButton.isHidden = !self.isExpanded
                            
                self.circleButton.layer.position = CGPoint(x: points[0].x, y: points[0].y)
                self.triangleButton.layer.position = CGPoint(x: points[1].x, y: points[1].y)
                self.starButton.layer.position = CGPoint(x: points[2].x, y: points[2].y)

            })
            
            return
        }
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        let center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)

                        self.circleButton.layer.position = center
                        self.triangleButton.layer.position = center
                        self.starButton.layer.position = center
                        self.menuButton.setImage(UIImage(named: "menuIcon"), for: .normal)

                        
        }, completion: { _ in
            self.circleButton.isHidden = !self.isExpanded
            self.triangleButton.isHidden = !self.isExpanded
            self.starButton.isHidden = !self.isExpanded
        })
    }
    
    func changeMenuIcon(_ sender: Any) {
        var iconName = "menuIcon"
        var animationOption = AnimationOptions.transitionFlipFromRight
        if isExpanded {
            iconName = "closeIcon"
            animationOption = AnimationOptions.transitionFlipFromLeft
        }
        UIView.transition(with: sender as! UIView, duration: 1.0, options: animationOption, animations: {
            (sender as! UIButton).setImage(UIImage(named: iconName), for: .normal)
            })
    }
    
    @IBAction func circleButtonAction(_ sender: Any) {
        delegate?.didPress(on: .circle)
    }
    
    @IBAction func starButtonAction(_ sender: Any) {
        delegate?.didPress(on: .star)
    }
    
    @IBAction func triangleButtonAction(_ sender: Any) {
        delegate?.didPress(on: .triangle)
    }
    

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        circleButton.show(as: .circle)
        triangleButton.show(as: .triangle)
        starButton.show(as: .star)
        menuButton.show(as: .circle)
        
        let edgeInset = menuButton.bounds.size.height / 4
        menuButton.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CircleMenu", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

