//
//  UIViewController+Extensions.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import UIKit

extension UIViewController {
    func alert(title: String? = nil, message: String? = nil, actions: [UIAlertAction] = [], animated: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        actions.forEach(alert.addAction)
        present(alert, animated: animated, completion: completion)
    }
    
    func alertMessage(_ message: String) {
        alert(message: message, actions: [.init(title: R.string.localizable.commonAlertActionOk(), style: .cancel)])
    }
}
