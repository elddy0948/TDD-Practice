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
    
    func loadSavedData() -> [FavoriteCity]? {
        var favoriteCity: [FavoriteCity] = []
        let request = FavoriteCity.createFetchRequest()
        do {
            favoriteCity = try container.viewContext.fetch(request)
            return favoriteCity
        } catch {
            return nil
        }
    }
    
    func insertCity(city: String) {
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteCity", in: self.container.viewContext)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
            managedObject.setValue(city, forKey: "name")
            do {
                try self.container.viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func delete(object: NSManagedObject) {
        self.container.viewContext.delete(object)
        do {
            try self.container.viewContext.save()
        } catch {
            print(error)
        }
    }
}
