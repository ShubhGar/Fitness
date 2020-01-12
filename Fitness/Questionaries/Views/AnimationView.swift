//
//  AnimationView.swift
//  Fitness
//
//  Created by Shubham Garg on 08/012/19.
//  Copyright © 2020 Shubham Garg. All rights reserved.
//
import Foundation
import UIKit

class Layer: CALayer {
    override func add(_ anim: CAAnimation, forKey key: String?) {
        super.add(anim, forKey: key)
        if let basicAnimation = anim as? CABasicAnimation {
            if basicAnimation.keyPath == NSStringFromSelector(#selector(getter: CALayer.position)) {
                if let delegate = delegate as? AnimationDelegate {
                    delegate.animationWillStart(basicAnimation)
                }
            }
        }
    }
}

protocol AnimationDelegate {
    func animationWillStart(_ anim: CABasicAnimation)
}

class AnimationView: UIView, AnimationDelegate {
    var damping: CGFloat = 0.3
    var initialSpringVelocity: CGFloat = 0.5
    var displayLink: CADisplayLink?
    var animationCount = 0
    let view = UIView()
    let shapeLayer = CAShapeLayer()
    
    var offset: UIOffset = UIOffset.zero {
        didSet {
            updatePath()
        }
    }
    
    var fillColor: UIColor = UIColor(red: 109/255, green: 217/255, blue: 142/255, alpha: 1) {
          didSet {
              updateColor()
          }
      }
    
    override open class var layerClass : AnyClass {
        return Layer.self
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        layer.insertSublayer(shapeLayer, at: 0)
        updatePath()
        updateColor()
        addSubview(view)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
        view.frame.origin = frame.origin
    }
    
    func animationWillStart(_ anim: CABasicAnimation) {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(tick(_:)))
            displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        }
        animationCount += 1
        let newPosition = layer.frame.origin
        UIView.animate(withDuration: anim.duration,
                       delay: anim.beginTime,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions],
                       animations: {
                        self.view.frame.origin = newPosition
        }, completion: { _ in
            self.animationCount -= 1
            if self.animationCount == 0 {
                self.displayLink!.invalidate()
                self.displayLink = nil
            }
        }
        )
    }
    
    func updatePath() {
        var bounds: CGRect
        if let presentationLayer = layer.presentation() {
            bounds = presentationLayer.bounds
        } else {
            bounds = self.bounds
        }
        
        let width = bounds.width
        let height = bounds.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: 0),
                          controlPoint:CGPoint(x: width / 2.0, y: 0 + offset.vertical))
        path.addQuadCurve(to: CGPoint(x: width, y: height),
                          controlPoint:CGPoint(x: width + offset.horizontal, y: height / 2.0))
        path.addQuadCurve(to: CGPoint(x: 0, y: height),
                          controlPoint: CGPoint(x: width / 2.0, y: height + offset.vertical))
        path.addQuadCurve(to: CGPoint(x: 0, y: 0),
                          controlPoint: CGPoint(x: offset.horizontal, y: height / 2.0))
        path.close()
        
        shapeLayer.path = path.cgPath
    }
    
    func updateColor() {
        shapeLayer.fillColor = fillColor.cgColor
    }
    
    @objc func tick(_ displayLink: CADisplayLink) {
        if let dummyViewPresentationLayer = view.layer.presentation() {
            if let presentationLayer = layer.presentation() {
                offset = UIOffset(horizontal: (dummyViewPresentationLayer.frame).minX - (presentationLayer.frame).minX,
                                          vertical: (dummyViewPresentationLayer.frame).minY - (presentationLayer.frame).minY)
            }
        }
    }
}
