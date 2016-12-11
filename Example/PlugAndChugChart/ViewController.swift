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
    
//    @IBOutlet weak var firstGraghView: GraghView!
//    @IBOutlet weak var secondGraghView: GraghView!
//    @IBOutlet weak var thirdGraghView: GraghView!
    
    @IBOutlet weak var firstGraghView: GraghView!
    @IBOutlet weak var secondGraghView: GraghView!
    @IBOutlet weak var thirdGraghView: GraghView!
    
    
    let graghData: [CGFloat] = [30, 50, 19, 22, 46, 10, 1, 66, 35, 49]
    var dataLabels: [String] {
        var labels: [String] = []
        for index in 0..<graghData.count {
            labels.append("DEC \(index + 1)")
        }
        return labels
    }
    var minimumDate: Date { return Date() }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstGraghOption()
        firstGraghView.loadGraghView()
        
        setSecondGraghOption()
        secondGraghView.loadGraghView()
        
        setThirdGraghOption()
        thirdGraghView.loadGraghView()
        
    }
    
    private func setFirstGraghOption() {
        // most setting
        firstGraghView.graghValues = graghData
        firstGraghView.xAxisLabels = dataLabels
        //        firstGraghView.minimumDate = minimumDate
        //        firstGraghView.dataLabelType = .date
        
        // optional setting
        firstGraghView.style = .bar
        firstGraghView.dateStyle = .hour
        firstGraghView.dateInterval = 2
        
        firstGraghView.setBarWidth(rate: 0.9)
        firstGraghView.setBarAreaHeight(rate: 0.9)
        firstGraghView.setMaxGraghValue(rate: 0.6)
        firstGraghView.setComponentArea(width: 100)
        
        firstGraghView.comparisonValue = 50
        firstGraghView.setComparisonValueLine(color: .green)
        firstGraghView.setComparisonValueLabel(backgroundColor: UIColor.yellow.withAlphaComponent(0.7))
        
    }
    
    private func setSecondGraghOption() {
        // most setting
        secondGraghView.graghValues = graghData
        secondGraghView.minimumDate = minimumDate
        secondGraghView.dataLabelType = .date
        
        // optional setting
        secondGraghView.style = .round
        secondGraghView.dateStyle = .minute
        secondGraghView.dateInterval = 30
        secondGraghView.contentOffsetControll = .maximizeDate
        
        secondGraghView.setRoundSize(rate: 0.1)
        secondGraghView.setBarAreaHeight(rate: 0.6)
        secondGraghView.setMaxGraghValue(rate: 0.8)
        secondGraghView.setComponentArea(width: 80)
        //        secondGraghView.setRoundIsHidden(bool: true)
        
        secondGraghView.comparisonValue = 35
        secondGraghView.setComparisonValueLine(color: UIColor.init(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0))
        secondGraghView.setComparisonValueLabel(backgroundColor: UIColor.init(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.9))
        
    }
    
    private func setThirdGraghOption() {
        // most setting
        thirdGraghView.graghValues = graghData
        thirdGraghView.minimumDate = minimumDate
        thirdGraghView.dataLabelType = .date
        
        // optional setting
        thirdGraghView.style = .jaggy
        thirdGraghView.dateStyle = .second
        thirdGraghView.dateInterval = 20
        thirdGraghView.dataType = .yen
        
        thirdGraghView.setBarWidth(rate: 0.95)
        thirdGraghView.setBarAreaHeight(rate: 0.9)
        thirdGraghView.setMaxGraghValue(rate: 1.0)
        thirdGraghView.setComponentArea(width: 50)
        //        thirdGraghView.setValueLabelIsHidden(bool: true)
        
        thirdGraghView.comparisonValue = 10
        thirdGraghView.setComparisonValueLine(color: UIColor.init(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0))
        thirdGraghView.setComparisonValueLabel(backgroundColor: UIColor.init(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9))
        
    }
    
}

