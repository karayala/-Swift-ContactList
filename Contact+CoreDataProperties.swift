//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Kartik Ayala on 3/2/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var birthday: String?
    @NSManaged var company: String?
    @NSManaged var detailsurl: String?
    @NSManaged var employeeid: NSNumber?
    @NSManaged var isjson: NSNumber?
    @NSManaged var name: String?
    @NSManaged var oncalllist: NSNumber?
    @NSManaged var onfavorite: NSNumber?
    @NSManaged var phonehome: String?
    @NSManaged var phonemobile: String?
    @NSManaged var phonework: String?
    @NSManaged var smallimageurl: String?

}
