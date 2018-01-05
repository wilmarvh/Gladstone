import UIKit
import HealthKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        auth()
    }
    
    func auth() {
        let types = HealthSampleTypes.fitness()
        Gladstone.requestAuthorization(toShare: types, read: types, completion: { complete, error in
            self.query()
        })
    }
    
    func query() {
        Gladstone.latest(.activeEnergyBurned).results({ sample in
            debugPrint("Latest sample for active energy burned: \(sample as Any)")
        })
        
        Gladstone.query(for: .heartRate)
            .sorted(withSortDescriptors: [NSSortDescriptor.init(key: HKSampleSortIdentifierStartDate, ascending: false)])
            .limited(numberOfSamples: 10)
            .excludeSource(withBundleIdentifier: "com.apple")
            .results { results in
                debugPrint(results as Any)
        }
    }

}

