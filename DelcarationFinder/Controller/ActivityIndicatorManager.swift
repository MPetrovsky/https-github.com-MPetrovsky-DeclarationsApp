//
//  ActivityIndicator.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 02.09.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorManager {
    static let sharedActivityIndicatorManager = ActivityIndicatorManager()
    private init() { }
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.color = UIColor.black
            self.activityIndicator.startAnimating()
        }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
