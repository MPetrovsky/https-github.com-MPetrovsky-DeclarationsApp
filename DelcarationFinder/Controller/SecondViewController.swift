//
//  SecondViewController.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 20.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PersonCellDelegate, NetworkManagerDelegate, AlertManagerDelegate, CoreDataManagerDelegateForViewCotroller {
   
    @IBAction func goBackButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToViewController", sender: (Any).self)
    }
    @IBOutlet weak var tableView: UITableView!
   
    weak var context = CoreDataManager.sharedDataManager.persistentContainer.viewContext
    var textPassedOver: String?
    var textField = UITextField()
    var favouriteIndex: Int = 0
    var linkToPdf: URL?
    var info = [Persons]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return info.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonCell
        cell.nameLbl.text = info[indexPath.row].firstname
        cell.placeOfWorkLabel.text = info[indexPath.row].placeOfWork
        cell.positionLabel.text = info[indexPath.row].position
        cell.lastNameLabel.text = info[indexPath.row].lastname
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    func didTapGoToWeb(index: Int) {
        linkToPdf = URL(string: info[index].linkPDF)!
        UIApplication.shared.open(linkToPdf!, options: [ : ], completionHandler: nil)
    }
    
    func didTapMarkAsFavourite(index: Int) {
        favouriteIndex = index
        CoreDataManager.sharedDataManager.updateWhenUnfavourite(id: info[index].id, controller: self)
    }
    
    func updateTextField(text: UITextField) {
        textField = text
    }
    func updateInStorage() {
        AlertManager.sharedAlertManager.alertFavourite(controller: self)
    }
    
    func performAdding() {
        let newItem = PersonsInfoStored(context: context!)
        newItem.firstname = self.info[favouriteIndex].firstname
        newItem.id = self.info[favouriteIndex].id
        newItem.lastname = self.info[favouriteIndex].lastname
        newItem.linkPDF = self.info[favouriteIndex].linkPDF
        newItem.placeOfWork = self.info[favouriteIndex].placeOfWork
        newItem.position = self.info[favouriteIndex].position
        newItem.note = textField.text
        CoreDataManager.sharedDataManager.saveContext()
        AlertManager.sharedAlertManager.alertOk(message: "", title: "Додано", controller: self)
    }
    
    func internetError(sender: NetworkManager) {
        AlertManager.sharedAlertManager.alertBack(message: "Проблеми з'єднання", title: "Перевірте доступ до інтернету", controller: self)
    }
    
    func needReload(sender: NetworkManager) {
        self.tableView.reloadData()
    }
    
    func noInfoFound(sender: NetworkManager) {
        AlertManager.sharedAlertManager.alertBack(message: "Перевірте правильність запиту", title: "За Вашим запитом не знайдено записів", controller: self)
    }
    
    func sendData(infoDelegate: Any) {
        info = infoDelegate as! [Persons]
        ActivityIndicatorManager.sharedActivityIndicatorManager.stopActivityIndicator()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func goToInitButton() {
        performSegue(withIdentifier: "unwindToViewController", sender: (Any).self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.sharedNetworkManager.networkManagerDelegate = self
        AlertManager.sharedAlertManager.alertManagerDelegate = self
        CoreDataManager.sharedDataManager.coreDataManagerDelegateForVC = self
        
        view.addSubview(ActivityIndicatorManager.sharedActivityIndicatorManager.activityIndicator)
        ActivityIndicatorManager.sharedActivityIndicatorManager.activityIndicator.frame = view.bounds
        
        NetworkManager.sharedNetworkManager.loadData(textPass: textPassedOver!)
        
    }
}
