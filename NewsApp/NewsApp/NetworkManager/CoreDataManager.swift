//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import Foundation
import CoreData
class CoreDataManager {
    
   static var shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
     
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:  is article bookmarled
    func isArticleBookMarked(article: Any) -> Bool {
        var isArticleBookMarked = false
        do {
            let bookMarked = try CoreDataManager.shared.context.fetch(Articles.fetchRequest()) as [Articles]
            
            if let article = article as? Article {
                for savedArticle in bookMarked {
                    if savedArticle.id == article.source?.id ?? "" && savedArticle.title == article.title ?? "" {
                        isArticleBookMarked = true
                        break
                    }
                }
            } else if let article = article as? Articles {
                for savedArticle in bookMarked {
                    if savedArticle.id == article.id && savedArticle.title == article.title {
                        isArticleBookMarked = true
                        break
                    }
                }
            }
            
        } catch {
            
        }
        return isArticleBookMarked
    }
    
    //MARK: Remove data from Core Data
    func removeBookmarked(article: Any) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Articles> = Articles.fetchRequest()
        if let article = article as? Article {
            fetchRequest.predicate = NSPredicate(format: "id == %@ AND title == %@", article.source?.id ?? "", article.title ?? "")
        } else if let article = article as? Articles {
            fetchRequest.predicate = NSPredicate(format: "id == %@ AND title == %@", article.id ?? "", article.title ?? "")
        }
        
        do {
     
            let results = try context.fetch(fetchRequest)
            
            if let articleToDelete = results.first {
                context.delete(articleToDelete)
                try context.save()
                print("Article removed from bookmarks.")
            } else {
                print("Article not found in bookmarks.")
            }
        } catch {
            print("Error removing article: \(error)")
        }
    }
}
