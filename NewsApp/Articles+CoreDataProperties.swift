//
//  Articles+CoreDataProperties.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//
//

import Foundation
import CoreData


extension Articles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Articles> {
        return NSFetchRequest<Articles>(entityName: "Articles")
    }

    @NSManaged public var id: String?
    @NSManaged public var sourceId: String?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var content: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var name: String?

}

extension Articles : Identifiable {

}
 
