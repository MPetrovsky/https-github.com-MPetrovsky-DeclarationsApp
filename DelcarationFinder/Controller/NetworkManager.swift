//
//  NetworkManager.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 02.09.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import Foundation
import UIKit
protocol NetworkManagerDelegate: class {
    func internetError(sender: NetworkManager)
    func needReload(sender: NetworkManager)
    func noInfoFound(sender: NetworkManager)
    func sendData(infoDelegate: Any)
}

class NetworkManager {
    static let sharedNetworkManager = NetworkManager()
    private init() { }
    
    weak var networkManagerDelegate: NetworkManagerDelegate?
    private var dwnldInfo = [Persons]()
    func loadData(textPass: String) {
        
        let baseUrl = "https://public-api.nazk.gov.ua/v1/declaration/?q="
        let resultUrl = baseUrl + textPass
        let url = URL(string: resultUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil
                else {
                    ActivityIndicatorManager.sharedActivityIndicatorManager.stopActivityIndicator()
                    self.networkManagerDelegate?.internetError(sender: self)
                    return
            }
            print ("downloaded")
            do {
                let decoder = JSONDecoder()
                let dowloadedInfo = try decoder.decode(Person.self, from: data)
                self.dwnldInfo = dowloadedInfo.items
                print ("sending")
                self.networkManagerDelegate?.sendData(infoDelegate: self.dwnldInfo)
                
            }
            catch {
                ActivityIndicatorManager.sharedActivityIndicatorManager.stopActivityIndicator()
                print ("Проблема информации")
                if self.dwnldInfo.count < 1 {
                    print ("net info")
                    self.networkManagerDelegate?.noInfoFound(sender: self)
                }
            }
        }.resume()
    }
    
}
