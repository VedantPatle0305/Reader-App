//
//  PersistenceManager.swift
//  Reader App
//
//  Created by Vedant Patle on 16/09/25.
//

import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ReaderModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { container.viewContext }

    // Save new articles (replace old ones for now)
    func saveArticles(_ articles: [Article]) {
        // Clear old cache first
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(deleteRequest)

        // Insert new articles
        for article in articles {
            let entity = ArticleEntity(context: context)
            entity.title = article.title
            entity.author = article.author
            entity.url = article.url
            entity.urlToImage = article.urlToImage
        }

        do {
            try context.save()
        } catch {
            print("Failed to save articles: \(error)")
        }
    }

    // Load cached articles
    func fetchArticles() -> [Article] {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { Article(author: $0.author,
                                          title: $0.title ?? "",
                                          url: $0.url ?? "",
                                          urlToImage: $0.urlToImage) }
        } catch {
            print("Failed to fetch cached articles: \(error)")
            return []
        }
    }
}
