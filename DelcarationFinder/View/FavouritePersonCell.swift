//
//  FavouritePersonCell.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 26.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit

protocol FavouritePersonCellDelegate: class {
    func didTapDeleteButton(index: Int)
    func didTapGoToWebButton(index: Int)
    func didTapSaveNoteButton(index: Int)
}

class FavouritePersonCell: UITableViewCell {

    weak var favouriteCellDelegate: FavouritePersonCellDelegate?
    var index: IndexPath?
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var placeOfWorkLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBAction func deleteButton(_ sender: Any) {
        favouriteCellDelegate?.didTapDeleteButton(index: (index?.row)!)
    }
    @IBAction func goToWebButton(_ sender: Any) {
        favouriteCellDelegate?.didTapGoToWebButton(index: (index?.row)!)
    }
    @IBAction func saveNoteButton(_ sender: Any) {
        favouriteCellDelegate?.didTapSaveNoteButton(index: (index?.row)!)
    }
}
