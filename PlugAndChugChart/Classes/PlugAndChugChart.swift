//
//  PlugAndChugChart.swift
//  Pods
//
//  Created by 酒井恭平 on 2016/12/11.
//
//

import UIKit

// MARK: - Enumeration

public enum PlugAndChugChartStyle {
    case bar, round, jaggy
}

public enum PlugAndChugChartDateStyle {
    case year, month, day, hour, minute, second
}

public enum PlugAndChugChartDataType {
    case normal, yen
}

public enum PlugAndChugChartContetOffset {
    case minimumDate, maximizeDate
}

public enum PlugAndChugChartDataLabelType {
    case `default`, date
}


// MARK: - PlugAndChugChart Class

public class PlugAndChugChart: UIScrollView {
    
    // MARK: - Private properties
    
    private let roundPathView = UIView()
    
    // MARK: Setting ComparisonValue
    private let comparisonValueLabel = UILabel()
    private let comparisonValueLineView = UIView()
    private let comparisonValueX: CGFloat = 0
    private var comparisonValueY: CGFloat?
    
    // MARK: Setting Average Value
    private let averageLabel = UILabel()
    private let averageLineView = UIView()
    private let averageValueX: CGFloat = 0
    private var averageValueY: CGFloat?
    
    
    // MARK: - Public properties
    
    public var components: [PlugAndChugChartComponent] = []
    
    public var chartValues: [CGFloat] = []
    public var xAxisLabels: [String] = []
    public var minimumDate: Date?
    
    public var style: PlugAndChugChartStyle = .bar
    public var dateStyle: PlugAndChugChartDateStyle = .month
    public var dataType: PlugAndChugChartDataType = .normal
    public var contentOffsetControll: PlugAndChugChartContetOffset = .minimumDate
    public var dataLabelType: PlugAndChugChartDataLabelType = .default
    
    public var componentLayout = ComponentLayoutOptions()
    public var layout = LayoutOptions()
    
    public var maxChartValue: CGFloat? { return chartValues.max() }
    
    public var dateInterval: Int = 1 {
        willSet {
            if newValue < 1 { return }
        }
    }
    
    
    // MARK: Setting ComparisonValue
    
    @IBInspectable public var comparisonValue: CGFloat = 0
    
    @IBInspectable public var comparisonValueIsHidden: Bool = false {
        didSet {
            comparisonValueLabel.isHidden = comparisonValueIsHidden
            comparisonValueLineView.isHidden = comparisonValueIsHidden
        }
    }
    
    // MARK: Setting Average Value
    public var averageValue: CGFloat? {
        return chartValues.reduce(0, +) / CGFloat(chartValues.count)
    }
    
    @IBInspectable public var averageValueIsHidden: Bool = false {
        didSet {
            averageLabel.isHidden = averageValueIsHidden
            averageLineView.isHidden = averageValueIsHidden
        }
    }
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect, chartValues: [CGFloat], minimumDate: Date, style: PlugAndChugChartStyle = .bar) {
        self.init(frame: frame)
        self.chartValues = chartValues
        self.minimumDate = minimumDate
        self.style = style
        loadChart()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Override
    
    override public var contentOffset: CGPoint {
        didSet {
            if !comparisonValueIsHidden {
                comparisonValueLabel.frame.origin.x = contentOffset.x
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func dateToMinimumDate(addComponentValue index: Int) -> DateComponents {
        let componentValue = index * dateInterval
        switch dateStyle {
        case .year: return DateComponents(year: componentValue)
        case .month: return DateComponents(month: componentValue)
        case .day: return DateComponents(day: componentValue)
        case .hour: return DateComponents(hour: componentValue)
        case .minute: return DateComponents(minute: componentValue)
        case .second: return DateComponents(second: componentValue)
        }
    }
    
    // MARK: Drawing
    
    // MARK: Comparison Value
    
    private func drawComparisonValue() {
        guard let comparisonValueY = comparisonValueY else { return }
        
        drawComparisonValueLine(from: CGPoint(x: comparisonValueX, y: comparisonValueY), to: CGPoint(x: contentSize.width, y: comparisonValueY))
        
        drawComparisonValueLabel(frame: CGRect(x: comparisonValueX, y: comparisonValueY, width: 50, height: 20), text: overTextFormatter(from: comparisonValue))
    }
    
    private func drawComparisonValueLine(from statPoint: CGPoint, to endPoint: CGPoint) {
        comparisonValueLineView.frame = CGRect(origin: .zero, size: contentSize)
        comparisonValueLineView.backgroundColor = UIColor.clear
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        let linePath = UIBezierPath()
        linePath.lineCapStyle = .round
        linePath.move(to: statPoint)
        linePath.addLine(to: endPoint)
        linePath.lineWidth = layout.comparisonLineWidth
        layout.comparisonLineColor.setStroke()
        linePath.stroke()
        comparisonValueLineView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        addSubview(comparisonValueLineView)
    }
    
    private func drawComparisonValueLabel(frame: CGRect, text: String) {
        comparisonValueLabel.frame = frame
        comparisonValueLabel.text = text
        comparisonValueLabel.textAlignment = .center
        comparisonValueLabel.font = comparisonValueLabel.font.withSize(10)
        comparisonValueLabel.backgroundColor = layout.comparisonLabelBackgroundColor
        addSubview(comparisonValueLabel)
    }
    
    private func overTextFormatter(from value: CGFloat) -> String {
        switch dataType {
        case .normal: return String(describing: value)
        case .yen: return String("\(Int(value)) 円")
        }
    }
    
    // MARK: Round Path
    
    func drawPathToRound() {
        if style != .round { return }
        
        guard let firstComponent = components.first, let startPoint = firstComponent.endPoint else { return }
        
        roundPathView.frame = CGRect(origin: .zero, size: contentSize)
        roundPathView.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        for index in 1..<components.count {
            if let endPoint = components[index].endPoint {
                path.addLine(to: CGPoint(x: endPoint.x + CGFloat(index) * componentLayout.componentAreaWidth, y: endPoint.y))
            }
        }
        path.lineWidth = layout.roundPathWidth
        componentLayout.roundColor.setStroke()
        path.stroke()
        roundPathView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        addSubview(roundPathView)
    }
    
    // MARK: Average Value
    
    private func drawAverageValue() {
        guard let averageValueY = averageValueY, let averageValue = averageValue else { return }
        
        drawAverageValueLine(from: CGPoint(x: averageValueX, y: averageValueY), to: CGPoint(x: contentSize.width, y: averageValueY))
        
        drawAverageValueLabel(frame: CGRect(x: averageValueX, y: averageValueY, width: 50, height: 20), text: overTextFormatter(from: averageValue))
    }
    
    private func drawAverageValueLine(from statPoint: CGPoint, to endPoint: CGPoint) {
        averageLineView.frame = CGRect(origin: .zero, size: contentSize)
        averageLineView.backgroundColor = UIColor.clear
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        let linePath = UIBezierPath()
        linePath.lineCapStyle = .round
        linePath.move(to: statPoint)
        linePath.addLine(to: endPoint)
        linePath.lineWidth = layout.averageLineWidth
        layout.averageLineColor.setStroke()
        linePath.stroke()
        averageLineView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        addSubview(averageLineView)
    }
    
    private func drawAverageValueLabel(frame: CGRect, text: String) {
        averageLabel.frame = frame
        averageLabel.text = text
        averageLabel.textAlignment = .center
        averageLabel.font = comparisonValueLabel.font.withSize(10)
        averageLabel.backgroundColor = layout.comparisonLabelBackgroundColor
        addSubview(averageLabel)
    }
    
    
    // MARK: - Public methods
    
    public func loadChart() {
        
        switch dataLabelType {
        case .default: drawComponentsOfTextLabel()
        case .date: drawComponentsOfDateLabel()
        }
        
        drawPathToRound()
        drawComparisonValue()
        drawAverageValue()
        
        contentOffset.x = {
            switch contentOffsetControll {
            case .minimumDate: return 0
            case .maximizeDate: return contentSize.width - frame.width
            }
        }()
        
    }
    
    private func drawComponentsOfTextLabel() {
        contentSize.height = frame.height
        
        for index in 0..<chartValues.count {
            contentSize.width += componentLayout.componentAreaWidth
            let rect = CGRect(origin: CGPoint(x: CGFloat(index) * componentLayout.componentAreaWidth, y: 0), size: CGSize(width: componentLayout.componentAreaWidth, height: frame.height))
            
            let component = PlugAndChugChartComponent(frame: rect, chartValue: chartValues[index], labelText: xAxisLabels[index], comparisonValue: comparisonValue, target: self)
            
            addSubview(component)
            
            self.comparisonValueY = component.comparisonValueY
            self.averageValueY = component.getEndPointForStartPoint(value: averageValue)
        }
    }
    
    private func drawComponentsOfDateLabel() {
        let calendar = Calendar(identifier: .gregorian)
        contentSize.height = frame.height
        
        for index in 0..<chartValues.count {
            contentSize.width += componentLayout.componentAreaWidth
            
            if let minimumDate = minimumDate, let date = calendar.date(byAdding: dateToMinimumDate(addComponentValue: index), to: minimumDate) {
                
                let rect = CGRect(origin: CGPoint(x: CGFloat(index) * componentLayout.componentAreaWidth, y: 0), size: CGSize(width: componentLayout.componentAreaWidth, height: frame.height))
                
                let component = PlugAndChugChartComponent(frame: rect, chartValue: chartValues[index], date: date, comparisonValue: comparisonValue, target: self)
                
                addSubview(component)
                
                self.comparisonValueY = component.comparisonValueY
                self.averageValueY = component.getEndPointForStartPoint(value: averageValue)
            }
        }
    }
    
    public func reloadChart() {
        subviews.forEach { $0.removeFromSuperview() }
        contentSize = .zero
        
        loadChart()
    }
    
    // MARK: Set Chart Customize Options
    
    public func setComparisonValueLabel(backgroundColor: UIColor) {
        layout.comparisonLabelBackgroundColor = backgroundColor
    }
    
    public func setComparisonValueLine(color: UIColor) {
        layout.comparisonLineColor = color
    }
    
    public func setComponentArea(width: CGFloat) {
        componentLayout.componentAreaWidth = width
    }
    
    public func setBarAreaHeight(rate: CGFloat) {
        componentLayout.barAreaHeightRate = rate
    }
    
    public func setMaxChartValue(rate: CGFloat) {
        componentLayout.maxChartValueRate = rate
    }
    
    public func setBarWidth(rate: CGFloat) {
        componentLayout.barWidthRate = rate
    }
    
    public func setBar(color: UIColor) {
        componentLayout.barColor = color
    }
    
    public func setLabel(backgroundcolor: UIColor) {
        componentLayout.labelBackgroundColor = backgroundcolor
    }
    
    public func setChart(backgroundcolor: UIColor) {
        componentLayout.ChartBackgroundColor = backgroundcolor
    }
    
    public func setRoundSize(rate: CGFloat) {
        componentLayout.roundSizeRate = rate
    }
    
    public func setRound(color: UIColor) {
        componentLayout.roundColor = color
    }
    
    public func setRoundIsHidden(bool: Bool) {
        componentLayout.onlyPathLine = bool
    }
    
    public func setValueLabelIsHidden(bool: Bool) {
        componentLayout.valueLabelIsHidden = bool
    }
    
    
    // MARK: - Struct
    
    public struct ComponentLayoutOptions {
        // MARK: Shared
        
        var ChartBackgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        // componentAreaHeight / frame.height
        var barAreaHeightRate: CGFloat = 0.8
        // maxChartValue / maxBarAreaHeight
        var maxChartValueRate: CGFloat = 0.8
        // component width
        var componentAreaWidth: CGFloat = 50
        // if over label is hidden
        var valueLabelIsHidden: Bool = false
        
        // MARK: Only Bar
        
        // bar.width / rect.width
        var barWidthRate: CGFloat = 0.5
        var barColor = UIColor.init(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0)
        var labelBackgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        
        // MARK: Only Round
        
        // round size / componentAreaWidth
        var roundSizeRate: CGFloat = 0.1
        var roundColor = UIColor.init(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
        // if round is hidden
        var onlyPathLine: Bool = false
        
        // MARK: Only Jaggy
        
        // jaggy color
        var jaggyColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.6, alpha: 1.0)
        
        
    }
    
    public struct LayoutOptions {
        // MARK: Comparison Value
        
        var comparisonLabelBackgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        var comparisonLineColor = UIColor.red
        var comparisonLineWidth: CGFloat = 1
        
        // MARK: Round Path
        
        var roundPathWidth: CGFloat = 2
        
        // MARK: Average Value
        var avarageLabelBackgroundColor = UIColor.init(red: 0.8, green: 0.7, blue: 1, alpha: 0.7)
        var averageLineColor = UIColor.init(red: 0.7, green: 0.6, blue: 0.9, alpha: 1)
        var averageLineWidth: CGFloat = 1
        
        
    }
    
}
