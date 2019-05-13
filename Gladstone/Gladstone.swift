import Foundation
import HealthKit

public struct Gladstone {
    
    public static func requestAuthorization(toShare: Set<HKSampleType>?, read: Set<HKObjectType>, completion: @escaping (Bool, Error?) -> Void) {
        HealthStoreManager.default.store.requestAuthorization(toShare: toShare, read: read, completion: completion)
    }
    
    @discardableResult
    public static func latest(_ identifier: HKQuantityTypeIdentifier) -> HealthQuery {
        return HealthStoreManager.default.initiateQuery(with: identifier)
            .sorted(with: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)])
            .limited(to: 1)
    }
    
    @discardableResult
    public static func query(for identifier: HKQuantityTypeIdentifier) -> HealthQuery {
        return HealthStoreManager.default.initiateQuery(with: identifier)
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
