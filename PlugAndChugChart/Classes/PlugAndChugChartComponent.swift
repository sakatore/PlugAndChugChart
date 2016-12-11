//
//  PlugAndChugChartComponent.swift
//  Pods
//
//  Created by 酒井恭平 on 2016/12/11.
//
//

import UIKit

// MARK: - GraghViewComponent Class

class GraghViewComponent: UIView {
    // MARK: - Pablic properties
    
    var endPoint: CGPoint? {
        guard let toY = toY else { return nil }
        return CGPoint(x: x, y: toY)
    }
    
    var comparisonValueY: CGFloat? {
        guard let comparisonValueHeight = comparisonValueHeight, let y = y else { return nil }
        return y - comparisonValueHeight
    }
    
    // MARK: - Private properties
    
    // MARK: Shared
    
    private var graghView: GraghView?
    private var style: GraghStyle?
    private var dateStyle: GraghViewDateStyle?
    private var dataType: GraghViewDataType?
    
    private let layout: GraghView.ComponentLayoutOptions?
    
    private var graghValue: CGFloat
    private var maxGraghValue: CGFloat? { return graghView?.maxGraghValue }
    
    private var labelText: String?
    private var date: Date?
    private var comparisonValue: CGFloat?
    
    private var maxBarAreaHeight: CGFloat? {
        guard let maxGraghValue = maxGraghValue, let layout = layout else { return nil }
        return maxGraghValue / layout.maxGraghValueRate
    }
    
    private var barAreaHeight: CGFloat? {
        guard let layout = layout else { return nil }
        return frame.height * layout.barAreaHeightRate
    }
    
    private var barHeigth: CGFloat? {
        guard let maxBarAreaHeight = maxBarAreaHeight, let barAreaHeight = barAreaHeight else { return nil }
        return barAreaHeight * graghValue / maxBarAreaHeight
    }
    
    // barの終点のY座標・roundのposition
    private var toY: CGFloat? {
        guard let barHeigth = barHeigth, let y = y else { return nil }
        return y - barHeigth
    }
    
    private var labelHeight: CGFloat? {
        guard let barAreaHeight = barAreaHeight, let isHidden = layout?.valueLabelIsHidden else { return nil }
        
        if isHidden {
            return frame.height - barAreaHeight
        } else {
            return (frame.height - barAreaHeight) / 2
        }
    }
    
    private var comparisonValueHeight: CGFloat? {
        guard let maxBarAreaHeight = maxBarAreaHeight, let comparisonValue = comparisonValue, let barAreaHeight = barAreaHeight else { return nil }
        return barAreaHeight * comparisonValue / maxBarAreaHeight
    }
    
    // MARK: Only Bar
    
    private var barWidth: CGFloat? {
        guard let layout = layout else { return nil }
        return frame.width * layout.barWidthRate
    }
    
    // barの始点のX座標（＝終点のX座標）
    private var x: CGFloat { return frame.width / 2 }
    // barの始点のY座標
    private var y: CGFloat? {
        guard let barAreaHeight = barAreaHeight, let labelHeight = labelHeight, let isHidden = layout?.valueLabelIsHidden else { return nil }
        
        if isHidden {
            return barAreaHeight
        } else {
            return barAreaHeight + labelHeight
        }
        
    }
    
    // MARK: Only Round
    
    private var roundSize: CGFloat? {
        guard let roundSizeRate = layout?.roundSizeRate else { return nil }
        return roundSizeRate * frame.width
    }
    
    // MARK: - Initializers
    
    // date label
    init(frame: CGRect, graghValue: CGFloat, date: Date, comparisonValue: CGFloat, target graghView: GraghView? = nil) {
        self.graghView = graghView
        self.style = graghView?.style
        self.dateStyle = graghView?.dateStyle
        self.dataType = graghView?.dataType
        self.layout = graghView?.componentLayout
        
        self.graghValue = graghValue
        self.date = date
        self.comparisonValue = comparisonValue
        
        super.init(frame: frame)
        self.backgroundColor = layout?.GraghBackgroundColor
        self.graghView?.components.append(self)
    }
    
    // string label (default init)
    init(frame: CGRect, graghValue: CGFloat, labelText: String, comparisonValue: CGFloat, target graghView: GraghView? = nil) {
        self.graghView = graghView
        self.style = graghView?.style
        self.dateStyle = graghView?.dateStyle
        self.dataType = graghView?.dataType
        self.layout = graghView?.componentLayout
        
        self.graghValue = graghValue
        self.labelText = labelText
        self.comparisonValue = comparisonValue
        
        super.init(frame: frame)
        self.backgroundColor = layout?.GraghBackgroundColor
        self.graghView?.components.append(self)
    }
    
    // storyboardで生成する時
    required init?(coder aDecoder: NSCoder) {
        self.graghValue = 0
        self.layout = nil
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    
    override func draw(_ rect: CGRect) {
        guard let style = style else { return }
        
        if let y = y, let endPoint = endPoint {
            // Graghを描画
            switch style {
            case .bar: drawBar(from: CGPoint(x: x, y: y), to: endPoint)
            case .round: drawRound(point: endPoint)
            case .jaggy: drawJaggy(point: endPoint, otherPoint1: CGPoint(x: 0, y: y), otherPoint2: CGPoint(x: frame.width, y: y))
            }
        }
        
        drawOverLabel()
        drawUnderLabel()
        
    }
    
    
    // MARK: - Public methods
    
    // return draw point.y
    func getEndPointForStartPoint(value: CGFloat?) -> CGFloat? {
        guard let value = value, let maxBarAreaHeight = maxBarAreaHeight, let barAreaHeight = barAreaHeight, let y = y else { return nil }
        
        let averageValueHeight = barAreaHeight * value / maxBarAreaHeight
        return y - averageValueHeight
    }
    
    // MARK: - Private methods
    
    // MARK: Under Label's text format
    
    private func underTextFormatter(from date: Date) -> String {
        guard let dateStyle = dateStyle else { return "" }
        
        let dateFormatter = DateFormatter()
        
        switch dateStyle {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "yyyy/MM"
        case .day: dateFormatter.dateFormat = "MM/dd"
        case .hour: dateFormatter.dateFormat = "dd/HH:mm"
        case .minute: dateFormatter.dateFormat = "HH:mm"
        case .second: dateFormatter.dateFormat = "HH:mm.ss"
        }
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: Over Label's text format
    
    private func overTextFormatter(from value: CGFloat) -> String {
        guard let dataType = dataType else {
            return ""
        }
        
        switch dataType {
        case .normal: return String("\(value)")
        case .yen: return String("\(Int(value)) 円")
        }
        
    }
    
    // MARK: Drawing
    
    private func drawBar(from startPoint: CGPoint, to endPoint: CGPoint) {
        let origin = CGPoint(x: startPoint.x - (barWidth ?? 0) / 2, y: endPoint.y)
        let size = CGSize(width: barWidth ?? 0, height: barHeigth ?? 0)
        
        let barPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: size), byRoundingCorners: .init(rawValue: 3), cornerRadii: CGSize(width: 20, height: 20))
        layout?.barColor.setFill()
        barPath.fill()
    }
    
    private func drawRound(point: CGPoint) {
        guard let layout = layout, let roundSize = roundSize, !layout.onlyPathLine else { return }
        
        let origin = CGPoint(x: point.x - roundSize / 2, y: point.y - roundSize / 2)
        let size = CGSize(width: roundSize, height: roundSize)
        let round = UIBezierPath(ovalIn: CGRect(origin: origin, size: size))
        layout.roundColor.setFill()
        round.fill()
    }
    
    private func drawJaggy(point: CGPoint, otherPoint1: CGPoint, otherPoint2: CGPoint) {
        let jaggyPath = UIBezierPath()
        // add path from left point
        jaggyPath.move(to: otherPoint1)
        jaggyPath.addLine(to: point)
        jaggyPath.addLine(to: otherPoint2)
        jaggyPath.close()
        layout?.jaggyColor.setFill()
        jaggyPath.fill()
        
    }
    
    private func drawOverLabel() {
        guard let layout = layout, let labelHeight = labelHeight else { return }
        
        let overLabel: UILabel = UILabel()
        overLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: labelHeight)
        overLabel.center = CGPoint(x: x, y: labelHeight / 2)
        overLabel.text = overTextFormatter(from: graghValue)
        overLabel.textAlignment = .center
        overLabel.font = overLabel.font.withSize(10)
        overLabel.backgroundColor = layout.labelBackgroundColor
        overLabel.isHidden = layout.valueLabelIsHidden
        addSubview(overLabel)
    }
    
    private func drawUnderLabel() {
        guard let labelHeight = labelHeight, let graghView = graghView else { return }
        
        let underLabel: UILabel = UILabel()
        underLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: labelHeight)
        underLabel.center = CGPoint(x: x, y: frame.height - labelHeight / 2)
        
        switch graghView.dataLabelType {
        case .default:
            underLabel.text = labelText
        case .date:
            if let date = date { underLabel.text = underTextFormatter(from: date) }
        }
        
        underLabel.textAlignment = .center
        underLabel.font = underLabel.font.withSize(10)
        underLabel.backgroundColor = layout?.labelBackgroundColor
        addSubview(underLabel)
    }
    
}

