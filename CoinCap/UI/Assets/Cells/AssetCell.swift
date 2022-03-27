//
//  AssetCell.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

final class AssetCell: UITableViewCell {
    @IBOutlet private weak var coinImageView: UIImageView!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var priceChangeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinImageView.image = nil
    }
    
    func configure(with item: Asset) {
        coinImageView.setImage(withUrl: item.logoURL, placeholder: R.image.logoPlaceholder())
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        priceLabel.text = item.readablePrice
        priceChangeLabel.text = item.readablePriceChange
        priceChangeLabel.textColor = item.isGrowing ? R.color.positiveGreen() : R.color.negativeRed()
    }
}
