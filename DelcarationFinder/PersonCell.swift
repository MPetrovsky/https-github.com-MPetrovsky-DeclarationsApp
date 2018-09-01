//
//  Person.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 20.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit

protocol PersonCellDelegate {
    func didTapGoToWeb(index: Int)
    func didTapMarkAsFavourite(index: Int)
}

class PersonCell: UITableViewCell {

    var cellDelegate: PersonCellDelegate?
    var index: IndexPath?
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var placeOfWorkLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBAction func markAsFavouriteButton(_ sender: Any) {
        cellDelegate?.didTapMarkAsFavourite(index: (index?.row)!)
    }
    @IBAction func goToWebButton(_ sender: Any) {
        cellDelegate?.didTapGoToWeb(index: (index?.row)!)
    }
    
}
