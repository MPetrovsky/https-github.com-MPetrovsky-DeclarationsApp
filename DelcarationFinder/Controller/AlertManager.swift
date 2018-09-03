//
//  AlertManager.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 02.09.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import Foundation
import UIKit

protocol AlertManagerDelegate: class {
    func goToInitButton()
    func performAdding()
    func updateTextField(text: UITextField)
}
class AlertManager {
    static let sharedAlertManager = AlertManager()
    private init() {}
    weak var alertManagerDelegate: AlertManagerDelegate?

    func alertOk (message: String, title: String = "", controller: UIViewController) {
        let alertOkController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertOkController.addAction(UIAlertAction(title: "Добре", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alertOkController, animated: true, completion: nil)
    }
    
    func alertBack (message: String, title: String = "", controller: UIViewController) {
        let alertBackController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Далі", style: .default) { (action) in
        self.alertManagerDelegate?.goToInitButton()
        }
        alertBackController.addAction(action)
        controller.present(alertBackController, animated: true, completion: nil)
    } 
    
    func alertFavourite(controller: UIViewController) {
        let alertAddController = UIAlertController(title: "Додати до обраних", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Додати", style: .default) { (action) in
            self.alertManagerDelegate?.performAdding()
        }
        alertAddController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Поле для коментарів"
            self.alertManagerDelegate?.updateTextField(text: alertTextField)
        }
        alertAddController.addAction(action)
        controller.present(alertAddController, animated: true, completion: nil)
    }
}
