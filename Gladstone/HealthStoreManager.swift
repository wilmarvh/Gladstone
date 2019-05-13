import Foundation
import HealthKit

class HealthStoreManager {
    
    let store: HKHealthStore = HKHealthStore()
    
    static let `default` = {
        return HealthStoreManager()
    }()
    
}


extension HealthStoreManager {
    
    @discardableResult
    func initiateQuery(with identifier: HKQuantityTypeIdentifier) -> HealthQuery {
        let query = HealthQuery(with: identifier)
        return query
    }
    
}
