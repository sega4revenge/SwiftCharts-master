//
//  AreasExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class AreasExample: UIViewController, ChartDelegate {
    
    fileprivate var chart: Chart? // arc
    
    fileprivate var popups: [UIView] = []
    var labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
    override func viewDidLoad() {
        super.viewDidLoad()
        generateChart()
    }
    
    func generateChart() {
        self.chart?.view.removeFromSuperview()
        
        labelSettings.fontColor = UIColor.clear
        
        let chartPoints: [ChartPoint] = generate()
        
        let xValues = chartPoints.map{$0.x}
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabels: [])
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabels: [])
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let c1 = UIColor.init(hexString: "E7F9FF")
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.init(hexString: "08BAF0"), lineWidth: 3, animDuration: 1, animDelay: 0)
        
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, areaColors: [c1], animDuration: 3, animDelay: 0, addContainerPoints: true, pathGenerator: chartPointsLineLayer.pathGenerator)
        
        
        let circleViewGenerator = {[weak self] (chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in guard self != nil else {return nil}
            
            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
            
            let v = ChartPointTextCircleView(chartPoint: chartPoint, center: screenLoc, diameter: Env.iPad ? 50 : 30, cornerRadius: Env.iPad ? 24: 15, borderWidth: Env.iPad ? 2 : 1, font: ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 14))
            
            
            let w: CGFloat = v.frame.size.width
            let h: CGFloat = v.frame.size.height
            let frame = CGRect(x: screenLoc.x - (w/2), y: screenLoc.y - (h/2), width: w, height: h)
            v.frame = frame
            
            return v
        }
        
        let itemsDelay: Float = 0
        
        // To not have circles clipped by the chart bounds, pass clipViews: false (and ChartSettings.customClipRect in case you want to clip them by other bounds)
        let chartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: itemsDelay, mode: .translate)
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                guidelinesLayer,
                chartPointsLayer1,
                chartPointsLineLayer,
                chartPointsCircleLayer,
            ]
        )
        
        chart.delegate = self
        
        view.addSubview(chart.view)
        self.chart = chart
        
    }
    
    fileprivate func removePopups() {
        for popup in popups {
            popup.removeFromSuperview()
        }
    }
    
    // MARK: - ChartDelegate
    
    func onZoom(scaleX: CGFloat, scaleY: CGFloat, deltaX: CGFloat, deltaY: CGFloat, centerX: CGFloat, centerY: CGFloat, isGesture: Bool) {
        removePopups()
    }
    
    func onPan(transX: CGFloat, transY: CGFloat, deltaX: CGFloat, deltaY: CGFloat, isGesture: Bool, isDeceleration: Bool) {
        removePopups()
    }
    
    func onTap(_ models: [TappedChartPointLayerModels<ChartPoint>]) {
        generateChart()
    }
    
    func generate() -> [ChartPoint] {
        let data = [13500, 25000, 16000, 38000]
        var points: [ChartPoint] = []
        for i in 0...data.count - 1 {
            let point = ChartPoint(x: ChartAxisValueDouble(i + 1, labelSettings: labelSettings), y: ChartAxisValueDouble(data[i]))
            points.append(point)
        }
        return points
    }
}
