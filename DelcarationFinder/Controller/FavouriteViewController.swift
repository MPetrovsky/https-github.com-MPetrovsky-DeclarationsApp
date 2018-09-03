//
//  FavouriteViewController.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 26.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritePersonCellDelegate, CoreDataManagerDelegateForFavourite {
    
    @IBOutlet weak var tableView: UITableView!
    
    var linkToPdf: URL?
    var favouriteInfoArray = [PersonsInfoStored]()
    weak var context = CoreDataManager.sharedDataManager.persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favouriteCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as! FavouritePersonCell
        favouriteCell.nameLbl.text = favouriteInfoArray[indexPath.row].firstname
        favouriteCell.lastNameLabel.text = favouriteInfoArray[indexPath.row].lastname
        favouriteCell.placeOfWorkLabel.text = favouriteInfoArray[indexPath.row].placeOfWork
        favouriteCell.positionLabel.text = favouriteInfoArray[indexPath.row].position
        favouriteCell.noteTextField.text = favouriteInfoArray[indexPath.row].note
        favouriteCell.favouriteCellDelegate = self
        favouriteCell.index = indexPath
        return favouriteCell
    }
    
    func didTapDeleteButton(index: Int) {
        CoreDataManager.sharedDataManager.deleteFromCoreData(targetArray: favouriteInfoArray, targetIndex: index)
        favouriteInfoArray.remove(at: index)
        tableView.reloadData()
    }
    
    func didTapGoToWebButton(index: Int) {
        print (favouriteInfoArray[index].note!)
        linkToPdf = URL(string: favouriteInfoArray[index].linkPDF!)!
        UIApplication.shared.open(linkToPdf!, options: [ : ], completionHandler: nil)
    }
    
    func didTapSaveNoteButton(index: Int) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Зммінити коментар", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Змінити", style: .default) { (action) in
            
            self.favouriteInfoArray[index].note = textField.text
            CoreDataManager.sharedDataManager.saveContext()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Новий коментар"
            alertTextField.text = self.favouriteInfoArray[index].note
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func sendFavouriteData(data: [PersonsInfoStored]) {
        favouriteInfoArray = data
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CoreDataManager.sharedDataManager.loadCoreData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.sharedDataManager.coreDataManagerDelegateForFVC = self
        CoreDataManager.sharedDataManager.loadCoreData()
        
    }
}
