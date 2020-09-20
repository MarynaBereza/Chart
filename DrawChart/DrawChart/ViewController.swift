//
//  ViewController.swift
//  DrawChart
//
//  Created by Maryna Bereza on 9/20/20.
//  Copyright © 2020 Maryna Bereza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var chart: ChartView?
    var chartsModel: ChartsModel!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        chart = ChartView.init(frame: view.frame)
        
        guard let chartView = chart else {
            return
        }
        
        view.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        chartView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        chartView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        view.layoutIfNeeded()
        
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap(_:)))
        
        view.addGestureRecognizer(tapGesture)
        
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        
        createChartsModel()
        
        chartView.drawChart(fromChartsModel: chartsModel, withAnimation: true)
    }
    
    //MARK: - Create models
    
    func createColumnModel() -> ColumnModel {
        
        let color = UIColor.randomColor()
        
        let x = CGFloat(arc4random_uniform(100))
        let y = CGFloat(arc4random_uniform(100))
        let column = ColumnModel(color: color, value: CGPoint(x: x, y: y))
        
        return column
    }
    
    
    func createChartModel() -> ChartModel {
        
        var columnsArray = [ColumnModel]()
        let numb = Int(arc4random_uniform(10) + 5)
        
        for _ in (0..<numb) {
            let columnModel = self.createColumnModel()
            columnsArray.append(columnModel)
        }
        
        let chartModel = ChartModel(columnsArray: columnsArray)
        
        return chartModel
    }
    
    
    func createChartsModel() {
        
        var modelsArray = [ChartModel]()
        
        let numb = Int(arc4random_uniform(5) + 2)
        
        for _ in (0..<numb) {
            let chartModel = self.createChartModel()
            modelsArray.append(chartModel)
        }
        chartsModel = ChartsModel(modelsArray: modelsArray)
    }
    
    
    //MARK: - Methods
    
    @objc func deviceOrientationDidChange() {
        
        guard let chartView = chart else {
            return
        }
        guard let chartsModel = chartsModel else {
            return
        }
        
        chartView.drawChart(fromChartsModel:chartsModel , withAnimation: false)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if (timer.isValid) {
            self.timer.invalidate()
        }
        
        timer = nil
        
        guard let chartView = chart else {
            return
        }
        
        self.defineNextChartModelIndex()
        
        chartView.drawChart(fromChartsModel: chartsModel, withAnimation: true)
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func handleTimer() {
        
        guard let chartView = chart else {
            return
        }
        
        self.defineNextChartModelIndex()
        
        chartView.drawChart(fromChartsModel: chartsModel, withAnimation: true)
    }
    
    
    func defineNextChartModelIndex()  {
        
        if chartsModel.indexModel >=  chartsModel.modelsArray.count {
            chartsModel.indexModel = 0
        }
        chartsModel.indexModel = chartsModel.indexModel + 1
    }
}

//MARK: - Extension
extension UIColor {
    static func randomColor() -> UIColor {
        
        let r = (CGFloat)(arc4random() % 256) / 255;
        let g = (CGFloat)(arc4random() % 256) / 255;
        let b = (CGFloat)(arc4random() % 256) / 255;
        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        return color
    }
}
