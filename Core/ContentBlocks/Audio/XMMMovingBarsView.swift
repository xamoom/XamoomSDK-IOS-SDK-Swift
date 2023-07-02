//
//  XMMMediaFile.swift
//  Pods-XamoomSDK_Example
//
//  Created by Ivan Magda on 11.05.2023.
//

import Foundation
import UIKit

class XMMMovingBarsView: UIView, CAAnimationDelegate {
    
    var running: Bool = false
    var lineWidth: Double = 0.0
    var startHeight: Double = 0.0
    var spacing: Double = 0.0
    var maxHeight: Double = 0.0
    var positions: [CGFloat] = []
    var layers: [CAShapeLayer] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineWidth = 6
        startHeight = 3
        spacing = 4
        maxHeight = bounds.size.height
        let width = bounds.size.width
        tintColor = UIColor.black
        
        let position1 = NSNumber(value: Float(width - lineWidth / 2))
        var positionDiff = Int(position1.intValue) - Int(lineWidth / 2) - Int(spacing)
        let position2 = NSNumber(value: positionDiff)
        positionDiff = Int(position2.intValue) - Int(lineWidth / 2) - Int(spacing)
        let position3 = NSNumber(value: positionDiff)
        
        positions = [CGFloat(position1.floatValue), CGFloat(position2.floatValue), CGFloat(position3.floatValue)]
        
        setupLayers()
    }
    
    private func setupLayers() {
        
        for startPosition in positions {
            let layer = CAShapeLayer()
            layer.position = CGPoint(x: 0, y: 0)
            layer.strokeColor = tintColor.cgColor
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: startPosition, y: maxHeight))
            linePath.addLine(to: CGPoint(x: startPosition, y: 0))
            layer.path = linePath.cgPath
            layer.lineWidth = lineWidth
            
            layers.append(layer)
            self.layer.addSublayer(layer)
            layer.strokeEnd = startHeight / maxHeight
            layer.strokeStart = 0
        }
    }
    
    func start() {
        running = true
        startAnimation()
    }
    
    func stop() {
        running = false
        stopAnimation()
    }
    
    override func layoutSubviews() {
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        maxHeight = bounds.size.height
        setupLayers()
    }
    
    private func startAnimation() {
        CATransaction.begin()
        for layer in layers {
            let toValue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            let animation = strokeAnimation(from: Float(layer.strokeEnd), to: Float(toValue))
            layer.add(animation, forKey: "strokeEnd")
        }
        CATransaction.commit()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        var currentLayer: CALayer?
        for layer in layers {
            if anim == layer.animation(forKey: "strokeEnd") {
                currentLayer = layer
            }
        }
        currentLayer?.removeAllAnimations()
        
        let oldAnimation = anim as! CABasicAnimation
        let fromValue = oldAnimation.toValue
        let toValue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let newAnimation = strokeAnimation(from: fromValue as! Float, to: Float(toValue))
        currentLayer?.add(newAnimation, forKey: "strokeEnd")
    }
    
    private func strokeAnimation(from: Float, to: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = from
        animation.toValue = to
        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func stopAnimation() {
        for layer in layers {
            let animation = layer.animation(forKey: "strokeEnd") as! CABasicAnimation
            let endAnimation = strokeAnimation(from: animation.toValue as! Float, to: Float(startHeight / maxHeight))
            layer.removeAnimation(forKey: "strokeEnd")
            layer.add(endAnimation, forKey: "end")
        }
    }
    
}
