//
//  Person.swift
//  DelcarationFinder
//
//  Created by Максим Петровский on 20.08.2018.
//  Copyright © 2018 Максим Петровский. All rights reserved.
//

import UIKit

class Person: Codable {
    let items: [Persons]
    init (items: [Persons]) {
        self.items = items
    }
    
}

    class Persons: Codable {
        let id: String!
        let firstname: String!
        let lastname: String!
        let placeOfWork: String!
        let position: String!
        let linkPDF: String!

        init (id: String, firstname: String, lastname: String, placeOfWork: String, position: String, linkPDF: String) {
            self.id = id
            self.firstname = firstname
            self.lastname = lastname
            self.placeOfWork = placeOfWork
            self.position = position
            self.linkPDF = linkPDF
        }

}
