//
//  ViewController.swift
//  PlugAndChugChart
//
//  Created by Kyohei-Sakai on 12/11/2016.
//  Copyright (c) 2016 Kyohei-Sakai. All rights reserved.
//

import UIKit
import PlugAndChugChart

class ViewController: UIViewController {
    
    @IBOutlet weak var firstChartView: PlugAndChugChart!
    @IBOutlet weak var secondChartView: PlugAndChugChart!
    @IBOutlet weak var thirdChartView: PlugAndChugChart!
    
    
    let chartData: [CGFloat] = [30, 50, 19, 22, 46, 10, 1, 66, 35, 49, 38, 17]
    var dataLabels: [String] {
        var labels: [String] = []
        for index in 0..<chartData.count {
            labels.append("Dec \(index + 1)")
        }
        return labels
    }
    var minimumDate: Date { return Date() }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstChartOption()
        firstChartView.loadChart()
        
        setSecondChartOption()
        secondChartView.loadChart()
        
        setThirdChartOption()
        thirdChartView.loadChart()
        
    }
    
    private func setFirstChartOption() {
        // most setting
        firstChartView.chartValues = chartData
        firstChartView.xAxisLabels = dataLabels
//        firstChartView.minimumDate = minimumDate
//        firstChartView.dataLabelType = .date
        
        // optional setting
        firstChartView.style = .bar
        firstChartView.dateStyle = .hour
        firstChartView.dateInterval = 2
        
        firstChartView.setBarWidth(rate: 0.9)
        firstChartView.setBarAreaHeight(rate: 0.9)
        firstChartView.setMaxChartValue(rate: 0.6)
        firstChartView.setComponentArea(width: 100)
        
        firstChartView.comparisonValue = 50
        firstChartView.setComparisonValueLine(color: .green)
        firstChartView.setComparisonValueLabel(backgroundColor: UIColor.yellow.withAlphaComponent(0.7))
        
    }
    
    private func setSecondChartOption() {
        // most setting
        secondChartView.chartValues = chartData
        secondChartView.minimumDate = minimumDate
        secondChartView.dataLabelType = .date
        
        // optional setting
        secondChartView.style = .round
        secondChartView.dateStyle = .minute
        secondChartView.dateInterval = 30
        secondChartView.contentOffsetControll = .maximizeDate
        
        secondChartView.setRoundSize(rate: 0.1)
        secondChartView.setBarAreaHeight(rate: 0.6)
        secondChartView.setMaxChartValue(rate: 0.8)
        secondChartView.setComponentArea(width: 80)
//        secondChartView.setRoundIsHidden(bool: true)
        
        secondChartView.comparisonValue = 35
        secondChartView.setComparisonValueLine(color: UIColor.init(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0))
        secondChartView.setComparisonValueLabel(backgroundColor: UIColor.init(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.9))
        
    }
    
    private func setThirdChartOption() {
        // most setting
        thirdChartView.chartValues = chartData
        thirdChartView.minimumDate = minimumDate
        thirdChartView.dataLabelType = .date
        
        // optional setting
        thirdChartView.style = .jaggy
        thirdChartView.dateStyle = .second
        thirdChartView.dateInterval = 20
        thirdChartView.dataType = .yen
        
        thirdChartView.setBarWidth(rate: 0.95)
        thirdChartView.setBarAreaHeight(rate: 0.9)
        thirdChartView.setMaxChartValue(rate: 1.0)
        thirdChartView.setComponentArea(width: 50)
//        thirdChartView.setValueLabelIsHidden(bool: true)
        
        thirdChartView.comparisonValue = 10
        thirdChartView.setComparisonValueLine(color: UIColor.init(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0))
        thirdChartView.setComparisonValueLabel(backgroundColor: UIColor.init(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9))
        
    }
    
}

