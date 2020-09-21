//
//  ViewController.swift
//  DrawChart
//
//  Created by Maryna Bereza on 9/20/20.
//  Copyright © 2020 Maryna Bereza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let chartView = ChartView()
    var chartsModel: ChartsModel!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        view.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        chartView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        chartView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true
        chartView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        view.layoutIfNeeded()
        
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap(_:)))
        
        view.addGestureRecognizer(tapGesture)
        
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        
        createChartsModel()
        
        let chartModel = chartsModel.modelsArray[0]
        
        chartView.drawChart(from: chartModel, withAnimation: true)
    }
    
    //MARK: - Create models
    
    func createColumnModel() -> ColumnModel {
        
        let color = UIColor.randomColor()
        
        let x = CGFloat.random(in: 20...100)
        let y = CGFloat.random(in: 20...100)
        let column = ColumnModel(color: color, value: CGPoint(x: x, y: y))
        
        return column
    }
    
    
    func createChartModel() -> ChartModel {
        
        var columnsArray = [ColumnModel]()
        let columnsCount = Int.random(in: 5...10)
        
        for _ in (0..<columnsCount) {
            let columnModel = self.createColumnModel()
            columnsArray.append(columnModel)
        }
        
        let chartModel = ChartModel(columnsArray: columnsArray)
        
        return chartModel
    }
    
    
    func createChartsModel() {
        
        var modelsArray = [ChartModel]()
        
        let modelsCount = Int.random(in: 3...5)
        
        for _ in (0..<modelsCount) {
            let chartModel = self.createChartModel()
            modelsArray.append(chartModel)
        }
        chartsModel = ChartsModel(modelsArray: modelsArray)
    }
    
    
    //MARK: - Methods
    
    @objc func deviceOrientationDidChange() {
        
        let chartModel = chartsModel.modelsArray[chartsModel.modelIndex]
        
        
        chartView.drawChart(from:chartModel, withAnimation: false)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if (timer.isValid) {
            self.timer.invalidate()
        }
        
        timer = nil
        
        self.increaseNextChartModelIndex()
        
        let chartModel = chartsModel.modelsArray[chartsModel.modelIndex]
        
        chartView.drawChart(from: chartModel, withAnimation: true)
        
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func handleTimer() {

        self.increaseNextChartModelIndex()
        
        let chartModel = chartsModel.modelsArray[chartsModel.modelIndex]
        
        chartView.drawChart(from: chartModel, withAnimation: true)
    }
    
    
    func increaseNextChartModelIndex()  {
        
        chartsModel.modelIndex += 1
        
        if chartsModel.modelIndex == chartsModel.modelsArray.count {
            chartsModel.modelIndex = 0
        }
    }
}
//MARK: - Extension
extension UIColor {
    static func randomColor() -> UIColor {
        
        let r = CGFloat.random(in: (0..<1))
        let g = CGFloat.random(in: (0..<1))
        let b = CGFloat.random(in: (0..<1))
        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        return color
    }
}
