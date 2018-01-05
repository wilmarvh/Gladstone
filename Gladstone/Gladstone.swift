import Foundation
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
    public func sorted(withSortDescriptors sortDescriptors: [NSSortDescriptor]) -> HealthQuery {
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    @discardableResult
    public func limited(numberOfSamples limit: Int) -> HealthQuery {
        self.limit = limit
        return self
    }
    
    @discardableResult
    public func excludeSource(withBundleIdentifier bundleIdentifier: String) -> HealthQuery {
        debugPrint("Not implemented yet")
        return self
    }
    
    @discardableResult
    public func excludeSources(_ source: [HKSource]) -> HealthQuery {
        debugPrint("Not implemented yet")
        return self
    }
    
    @discardableResult
    public func limitedToSource(withBundleIdentifier identifier: String) -> HealthQuery {
        debugPrint("Not implemented yet")
        return self
    }
    
    @discardableResult
    public func limitedToSources(_ sources: [HKSource]) -> HealthQuery {
        debugPrint("Not implemented yet")
        return self
    }
    
    @discardableResult
    public func results() -> HealthQuery {
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

public enum HealthSampleTypes {
    
    public static var fitness: Set<HKSampleType> {
        return Set(
            [
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKWorkoutType.workoutType()
            ])
    }
}

public class HealthStoreManager {
    
    public let store: HKHealthStore = HKHealthStore()
    
    open static let `default` = {
        return HealthStoreManager()
    }()
    
}

public func requestAuthorization(toShare: Set<HKSampleType>?, read: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
    HealthStoreManager.default.store.requestAuthorization(toShare: toShare, read: read, completion: completion)
}
