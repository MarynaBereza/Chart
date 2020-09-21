//
//  ChartView.swift
//  DrawChart
//
//  Created by Maryna Bereza on 9/20/20.
//  Copyright © 2020 Maryna Bereza. All rights reserved.
//

import UIKit

class ChartView: UIView {
    
    func drawChart(from chartModel: ChartModel, withAnimation animation: Bool) {

        
        self.layer.sublayers = nil

        
        for (index,column) in chartModel.columnsArray.enumerated() {
            
            let point = column.value
            
            let rectLayer = CAShapeLayer()
            
            let k = self.calculationCoefficientFor(chart: chartModel)
            
            let layerFrame = CGRect(x: CGFloat(index) * frame.width / CGFloat(chartModel.columnsArray.count), y:CGFloat(0), width: frame.width / CGFloat(chartModel.columnsArray.count), height: frame.height)
            
            rectLayer.frame = layerFrame.insetBy(dx: 3, dy: 3)
            
            rectLayer.lineWidth = frame.width / CGFloat(chartModel.columnsArray.count)
            
            self.layer.addSublayer(rectLayer)
            
            let linePath = UIBezierPath()
            
            let startPoint = CGPoint(x: rectLayer.bounds.width / 2, y: rectLayer.bounds.height)
            let endPoint = CGPoint(x: rectLayer.bounds.width / 2, y: rectLayer.bounds.height - (point.y * k))

            linePath.move(to: startPoint)
            linePath.addLine(to: endPoint)
            
            rectLayer.path = linePath.cgPath
            
            
            rectLayer.strokeColor = column.color.cgColor
            
            if animation {
                rectLayer.strokeStart = 0
                rectLayer.strokeEnd = 0
                
                let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
                pathAnimation.duration = 1
                pathAnimation.fromValue = 0
                pathAnimation.toValue = 1
                
                rectLayer.add(pathAnimation, forKey: "strokeEnd")
                
                rectLayer.strokeEnd = 1
            }
        }
    }
    
    
    func calculationCoefficientFor(chart: ChartModel) -> CGFloat {
        
        var yArray = [CGFloat]()
        let columnsArray = chart.columnsArray
        
        for column:ColumnModel  in columnsArray {
            let y = column.value.y
            yArray .append(y)
        }
        
        let maxY = yArray.max()!
        let k = frame.height / maxY
        
        return k
    }
}


