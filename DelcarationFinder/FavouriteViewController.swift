//
//  FavouriteViewController.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 26.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritePersonCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var linkToPdf: URL?
    var infoArray = [PersonsInfoStored]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favouriteCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as! FavouritePersonCell
        favouriteCell.nameLbl.text = infoArray[indexPath.row].firstname
        favouriteCell.lastNameLabel.text = infoArray[indexPath.row].lastname
        favouriteCell.placeOfWorkLabel.text = infoArray[indexPath.row].placeOfWork
        favouriteCell.positionLabel.text = infoArray[indexPath.row].position
        favouriteCell.noteTextField.text = infoArray[indexPath.row].note
        favouriteCell.cellDelegate = self
        favouriteCell.index = indexPath
        return favouriteCell
    }

    func loadItems() {
        let request :NSFetchRequest<PersonsInfoStored> = PersonsInfoStored.fetchRequest()
        do {
            infoArray = try context.fetch(request)
        } catch {
            print ("Error fetching data \(error)")
            
        }

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
    
    func didTapDeleteButton(index: Int) {
        
        context.delete(infoArray[index])
        infoArray.remove(at: index)
        saveInfo()
        tableView.reloadData()
    }
    
    func didTapGoToWebButton(index: Int) {
        print (infoArray[index].note!)
        linkToPdf = URL(string: infoArray[index].linkPDF!)!
        UIApplication.shared.open(linkToPdf!, options: [ : ], completionHandler: nil)
    }
    
    func didTapSaveNoteButton(index: Int) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Зммінити коментар", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Змінити", style: .default) { (action) in
            
            self.infoArray[index].note = textField.text
            self.saveInfo()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Новий коментар"
            alertTextField.text = self.infoArray[index].note
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
}
