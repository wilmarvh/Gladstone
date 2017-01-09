import Foundation
import HealthKit

@discardableResult
public func latest(_ identifier: HKQuantityTypeIdentifier) -> HealthQuery {
    return HealthStoreManager.default.initiateQuery(withIdentifier: identifier)
        .sorted(withSortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)])
        .limited(numberOfSamples: 1)
}

@discardableResult
public func query(for identifier: HKQuantityTypeIdentifier) -> HealthQuery {
    return HealthStoreManager.default.initiateQuery(withIdentifier: identifier)
}


extension HealthStoreManager {
    
    @discardableResult
    public func initiateQuery(withIdentifier identifier: HKQuantityTypeIdentifier) -> HealthQuery {
        let query = HealthQuery(withIdentifier: identifier)
        return query
    }
    
}

extension HealthQuery {
    
    public convenience init(withIdentifier identifier: HKQuantityTypeIdentifier) {
        self.init()
        self.typeIdentifier = identifier
    }
    
    func newSampleQuery(withIdentifier identifier: HKQuantityTypeIdentifier) -> HKSampleQuery? {
        if let sampleType = HKSampleType.quantityType(forIdentifier: identifier) {
            return HKSampleQuery.init(sampleType: sampleType, predicate: self.predicate, limit: self.limit, sortDescriptors: self.sortDescriptors, resultsHandler: { (query, results, error) in
                self.completion(results)
            })
        }
        return nil
    }
    
    @discardableResult
    public func results(_ completion: @escaping HealthQueryCompletion) -> HealthQuery {
        var healthKitQuery: HKSampleQuery?
        
        if let quantityTypeIdentifier = self.typeIdentifier {
            healthKitQuery = newSampleQuery(withIdentifier: quantityTypeIdentifier as! HKQuantityTypeIdentifier)
        }
        
        guard healthKitQuery != nil else {
            debugPrint("No HealthKit query to execute")
            return self
        }
        
        self.completion = completion
        HealthStoreManager.default.store.execute(healthKitQuery!)
        return self
    }
    
}

