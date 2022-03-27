//
//  UIImageView+Extensions.swift
//

import UIKit
import Kingfisher

extension UIImageView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    func setImage(withUrl url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
}
