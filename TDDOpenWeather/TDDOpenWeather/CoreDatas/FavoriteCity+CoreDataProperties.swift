import Foundation
import CoreData


extension FavoriteCity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<FavoriteCity> {
        return NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
    }

    @NSManaged public var name: String?

}

extension FavoriteCity : Identifiable {

}
