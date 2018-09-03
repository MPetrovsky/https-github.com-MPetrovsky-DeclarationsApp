//
//  ViewController.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 20.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var dataTextField: UITextField!
   
    @IBAction func searchButton(_ sender: Any) {
        if dataTextField.text == "" {
            AlertManager.sharedAlertManager.alertOk(message: "", title: "Введіть Ваш запит", controller: self)
        }
        performSegue(withIdentifier: "goToSecond", sender: self)
        ActivityIndicatorManager.sharedActivityIndicatorManager.startActivityIndicator()

    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecond" {
        let urlAddition = dataTextField.text!
        let destinationVC = segue.destination as! SecondViewController
        destinationVC.textPassedOver = urlAddition
        
        }
    }
    @IBAction func unwindToLaunchScreen(_ sender:UIStoryboardSegue) {
    }
    
}

