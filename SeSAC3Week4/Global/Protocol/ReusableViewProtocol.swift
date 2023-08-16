//
//  ReusableViewProtocol.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/11.
//

import UIKit

protocol ReusableViewProtocol {}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableViewProtocol {}

extension UITableViewCell: ReusableViewProtocol {}
