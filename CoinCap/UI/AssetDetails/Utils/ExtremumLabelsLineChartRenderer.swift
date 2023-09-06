//
//  ExtremumLabelsLineChartRenderer.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import DGCharts

final class ExtremumLabelsLineChartRenderer: LineChartRenderer {
    private var _xBounds = XBounds()
    private let view: LineChartView
    private let minValue: Double
    private let maxValue: Double
    private let valueFormatter: NumberFormatter

    init(view: LineChartView, minValue: Double, maxValue: Double, valueFormatter: NumberFormatter) {
        self.view = view
        self.minValue = minValue
        self.maxValue = maxValue
        self.valueFormatter = valueFormatter

        super.init(dataProvider: view, animator: view.chartAnimator, viewPortHandler: view.viewPortHandler)
    }

    override func drawValues(context: CGContext) {
        guard
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData
            else { return }

        let dataSets = lineData.dataSets
        var point = CGPoint()

        for i in 0 ..< dataSets.count {
            guard let dataSet = dataSets[i] as? LineChartDataSet else {
                continue
            }

            let valueFont = dataSet.valueFont
            let transformer = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = transformer.valueToPixelMatrix

            _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)

            let lineHeight = valueFont.lineHeight
            let yOffset: CGFloat = lineHeight + 5.0

            for j in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1) {
                let entry = dataSet[j]
                guard entry.y == maxValue || entry.y == minValue || dataSet.isDrawValuesEnabled else {
                    continue
                }

                point.x = CGFloat(entry.x)
                if entry.y == minValue || entry.y == maxValue {
                    point.y = entry.y
                }
                point = point.applying(valueToPixelMatrix)

                var textValue: String?
                var align: NSTextAlignment = .center
                if entry.y == minValue {
                    point.y -= yOffset
                    textValue = valueFormatter.string(from: .init(value: minValue))
                } else if entry.y == maxValue {
                    point.y += yOffset / 5
                    textValue = valueFormatter.string(from: .init(value: maxValue))
                }
                let attributes: [NSAttributedString.Key : Any] = [.font: valueFont, .foregroundColor: dataSet.valueTextColorAt(j)]
                if let textValue = textValue {
                    let halfTextWidth = (textValue as NSString).size(withAttributes: attributes).width / 2
                    if point.x - halfTextWidth < view.frame.minX {
                        align = .left
                    }
                    if point.x + halfTextWidth > view.frame.maxX {
                        align = .right
                    }
                    context.drawText(textValue, at: point, align: align, attributes: attributes)
                }
            }
        }
    }
}
