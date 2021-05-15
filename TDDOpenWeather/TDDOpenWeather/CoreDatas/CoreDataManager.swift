import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    var container: NSPersistentContainer!
    
    private init() {
        container = NSPersistentContainer(name: "FavoriteCity")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
