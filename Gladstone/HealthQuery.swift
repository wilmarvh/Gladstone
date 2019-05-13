import HealthKit

public class HealthQuery {
    
    public typealias HealthQueryCompletion = (_: [Any]?) -> Void
    
    var completion: HealthQueryCompletion = { results in
        debugPrint(results as Any)
    }
    
    var typeIdentifier: Any?
    var query: HKQuery?
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor]?
    var sourceQuery: HKSourceQuery?
    var limit: Int = HKObjectQueryNoLimit
    
    @discardableResult
    public func sorted(with sortDescriptors: [NSSortDescriptor]) -> HealthQuery {
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    @discardableResult
    public func limited(to limit: Int) -> HealthQuery {
        self.limit = limit
        return self
    }
    
    @discardableResult
    public func excludeSource(with bundleIdentifier: String) -> HealthQuery {
        debugPrint("Not implemented")
        return self
    }
    
    @discardableResult
    func exclude(source: [HKSource]) -> HealthQuery {
        debugPrint("Not implemented")
        return self
    }
    
    @discardableResult
    func limitedToSource(withBundleIdentifier identifier: String) -> HealthQuery {
        debugPrint("Not implemented")
        return self
    }
    
    @discardableResult
    func limitedToSources(_ sources: [HKSource]) -> HealthQuery {
        debugPrint("Not implemented")
        return self
    }
    
    @discardableResult
    func results() -> HealthQuery {
        debugPrint("Empty implementation")
        return self
    }
    
    func sampleType() -> HKSampleType? {
        if let identifier = self.typeIdentifier as? HKQuantityTypeIdentifier {
            return HKSampleType.quantityType(forIdentifier: identifier)
        }
        
        return nil
    }
    
}

extension HealthQuery {
    
    convenience init(with identifier: HKQuantityTypeIdentifier) {
        self.init()
        self.typeIdentifier = identifier
    }
    
    func newSampleQuery(with identifier: HKQuantityTypeIdentifier) -> HKSampleQuery? {
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
            healthKitQuery = newSampleQuery(with: quantityTypeIdentifier as! HKQuantityTypeIdentifier)
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

