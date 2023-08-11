//
//  Alertable.swift
//  SeSAC3Week4
//
//  Created by JongHoon on 2023/08/10.
//

import UIKit

protocol AlertableProtocol {}

extension AlertableProtocol where Self: UIViewController {
    func presentSimpleAlert(
        title: String? = nil,
        message: String
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
}
