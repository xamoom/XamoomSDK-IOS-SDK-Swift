//
//  XMMProgressBar.swift
//  Pods
//
//  Created by Иван Магда on 12.05.2023.
//

import Foundation
import UIKit


@IBDesignable class XMMProgressBar: UIView {
    
    private var drawingFrameSize: CGSize = .zero
    
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var backgroundLineColor: UIColor = .lightGray
    @IBInspectable var foregroundLineColor: UIColor = .green
    @IBInspectable var lineProgress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawingFrameSize = self.bounds.size
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //background of progress
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(backgroundLineColor.cgColor)
        context.move(to: CGPoint(x: 0, y: drawingFrameSize.height - lineWidth / 2))
        context.addLine(to: CGPoint(x: drawingFrameSize.width, y: drawingFrameSize.height - lineWidth / 2))
        context.strokePath()
        
        // progress
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(foregroundLineColor.cgColor)
        context.move(to: CGPoint(x: 0, y: drawingFrameSize.height - lineWidth / 2))
        context.addLine(to: CGPoint(x: drawingFrameSize.width * lineProgress, y: drawingFrameSize.height - lineWidth / 2))
        context.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setLineProgress(_ lineProgress: CGFloat) {
        self.lineProgress = lineProgress
        setNeedsDisplay()
    }
}
