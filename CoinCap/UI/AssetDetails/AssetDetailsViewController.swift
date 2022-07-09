//
//  AssetDetailsViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import UIKit
import Charts

final class AssetDetailsViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceChangeLabel: UILabel!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var dataController: AssetDetailsDataController! {
        didSet {
            dataController.onGraphDataLoaded = { [weak self] data in
                self?.activityIndicator.stopAnimating()
                self?.chartView.isHidden = false
                self?.updateGraph(with: data)
            }
            dataController.onError = { [weak self] error in
                self?.activityIndicator.stopAnimating()
                self?.chartView.isHidden = false
                self?.alertMessage(error.localizedDescription)
            }
        }
    }
    
    weak var coordinator: AssetsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setDataController(_ dataController: AssetDetailsDataController) {
        self.dataController = dataController
    }
}

// MARK: - UI
private extension AssetDetailsViewController {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func setupNavigationBarUI() {
        guard
            let symbol = dataController.symbol,
            let name = dataController.name else {
            return
        }
        let string = "\(name) \(symbol)"
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ])
        attributedString.addAttribute(
            .foregroundColor,
            value: R.color.secondaryTextColor() as Any,
            range: (string as NSString).range(of: symbol)
        )
        let navigationItemLabel = UILabel()
        navigationItemLabel.attributedText = attributedString
        navigationItem.titleView = navigationItemLabel
    }
    
    func setupChartUI() {
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.minOffset = 0
        chartView.extraTopOffset = 20
        chartView.extraBottomOffset = 20
        
        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesBehindDataEnabled = false
    }
    
    func updateGraph(with data: [AssetHistoryData]) {
        var entries = [ChartDataEntry]()
        data.forEach { entries.append(.init(x: $0.time, y: $0.price)) }
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false
        dataSet.colors = [.black]
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = true
        dataSet.valueFont = .systemFont(ofSize: 13)
        dataSet.valueColors = [R.color.secondaryTextColor()!]
        let lineChartData = LineChartData(dataSet: dataSet)
        chartView.data = lineChartData
        
        if
            let min = data.max(by: { $0.price < $1.price }),
            let max = data.max(by: { $0.price > $1.price }) {
            chartView.renderer = ExtremumLabelsLineChartRenderer(
                view: chartView,
                minValue: min.price,
                maxValue: max.price,
                valueFormatter: Self.currencyFormatter
            )
        }
    }
}

// MARK: - Private
private extension AssetDetailsViewController {
    func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: dataController.isFavorite ? R.image.favoriteOn() : R.image.favoriteOff(),
            style: .plain,
            target: self,
            action: #selector(addFavorite)
        )
        tableView.dataSource = dataController
        priceLabel.text = dataController.price
        priceChangeLabel.text = dataController.priceChange
        priceChangeLabel.textColor = dataController.isGrowing ? R.color.positiveGreen() : R.color.negativeRed()
        setupNavigationBarUI()
        setupChartUI()
        
        dataController.reloadGraphData()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesUpdated),
            name: .favoritesUpdated,
            object: nil
        )
    }
    
    @objc func addFavorite() {
        dataController.isFavorite ? dataController.removeFavorite() : dataController.addFavorite()
        favoritesUpdated()
    }
    
    @objc func favoritesUpdated() {
        navigationItem.rightBarButtonItem?.image = dataController.isFavorite ? R.image.favoriteOn() : R.image.favoriteOff()
    }
}
