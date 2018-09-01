//
//  SecondViewController.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 20.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PersonCellDelegate {

    @IBAction func goBackButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToViewController", sender: (Any).self)
    }
    @IBOutlet weak var tableView: UITableView!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var textPassedOver: String?
    
    var linkToPdf: URL?
    
    var results = [PersonsInfoStored]()
    
    private var info = [Persons]()
    
    
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
    
    func loadData() {
        
        activityIndicator.startAnimating()
        
        let baseUrl = "https://public-api.nazk.gov.ua/v1/declaration/?q="
        let urlAddition = textPassedOver!
        let resultUrl = baseUrl + urlAddition
        let url = URL(string: resultUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil
                else {
                    self.alertBack(message: "Проблеми з'єднання", title: "Перевірте доступ до інтернету")
                    print ("Проблема запроса")
                    return
            }
            print ("downloaded")
            do {
                let decoder = JSONDecoder()
                let dowloadedInfo = try decoder.decode(Person.self, from: data)
                self.info = dowloadedInfo.items
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            catch {
                print ("Проблема декодера")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                if self.info.count < 1 {
                    self.alertBack(message: "За Вашим запитом не знайдено інформації", title: "Перевірте правильність запиту")
                }
            }
        }.resume()
    }
    
    func didTapGoToWeb(index: Int) {
        linkToPdf = URL(string: info[index].linkPDF)!
        UIApplication.shared.open(linkToPdf!, options: [ : ], completionHandler: nil)
    }
    
    func didTapMarkAsFavourite(index: Int) {
        var textField = UITextField()
        let alertAddController = UIAlertController(title: "Додати до обраних", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Додати", style: .default) { (action) in
            let newItem = PersonsInfoStored(context: self.context)
            newItem.firstname = self.info[index].firstname
            newItem.id = self.info[index].id
            newItem.lastname = self.info[index].lastname
            newItem.linkPDF = self.info[index].linkPDF
            newItem.placeOfWork = self.info[index].placeOfWork
            newItem.position = self.info[index].position
            newItem.note = textField.text
            self.saveInfo()
            self.alertOk(message: "", title: "Додано")
        }
        
        alertAddController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Поле для коментарів"
            textField = alertTextField
        }
        alertAddController.addAction(action)
        let request :NSFetchRequest<PersonsInfoStored> = PersonsInfoStored.fetchRequest()
        request.predicate = NSPredicate(format: "id= %@", info[index].id)
        do {
            let resultsForRequest  = try context.fetch(request)
            if (resultsForRequest.count > 0) {
                print ("Exist")
                
            let resultsData = resultsForRequest
                for object in resultsData {
                    context.delete(object)
                }
                saveInfo()
                alertOk(message: "", title: "Видалено")
            }
            else {
                print("Not exist")
                present(alertAddController, animated: true, completion: nil)
            }
        } catch {
            print ("Error fetching data \(error)")
        }
        
    }
    
    func alertOk (message: String, title: String = "") {
        let alertOkController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertOkController.addAction(UIAlertAction(title: "Добре", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertOkController, animated: true, completion: nil)
    }
    
    func alertBack (message: String, title: String = "") {
        let alertBackController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Далі", style: .default) { (action) in
            self.goBackButton((Any).self)
            }
        alertBackController.addAction(action)
        self.present(alertBackController, animated: true, completion: nil)
    }
    
    func saveInfo() {
        do {
            try context.save()
            print ("saved")
        }
        catch {
            print ("error saving \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        
        loadData()
    }
}
