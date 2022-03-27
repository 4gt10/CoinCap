//
//  DetailCell.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import UIKit

struct DetailItem {
    let title: String
    let value: String
}

final class DetailCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func configure(with item: DetailItem, isChecked: Bool = false) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        accessoryType = isChecked ? .checkmark : .none
    }
}
