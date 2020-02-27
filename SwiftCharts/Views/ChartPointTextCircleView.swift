//
//  ChartPointTextCircleView.swift
//  swift_charts
//
//  Created by ischuetz on 14/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartPointTextCircleView: UILabel {
   
    fileprivate let targetCenter: CGPoint
    open var viewTapped: ((ChartPointTextCircleView) -> ())?
    
    open var selected: Bool = false {
        didSet {
            if selected {
                textColor = UIColor.white
                layer.borderColor = UIColor.white.cgColor
                layer.backgroundColor = UIColor.black.cgColor
                
            } else {
                textColor = UIColor.black
                layer.borderColor = UIColor.black.cgColor
                layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, cornerRadius: CGFloat, borderWidth: CGFloat, font: UIFont, backgroundColor: UIColor = .black, borderColor: UIColor = .black) {
        
        targetCenter = center
        
        super.init(frame: CGRect(x: 0, y: center.y - diameter / 2, width: chartPoint.description.size(font).width + 20, height: diameter))

        self.textColor = UIColor.white
        self.text = chartPoint.description
        self.font = font
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.textAlignment = NSTextAlignment.center
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = backgroundColor.cgColor
        
        isUserInteractionEnabled = true
        self.didMoveToWindow()
    }
   
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTapped?(self)
    }
}
