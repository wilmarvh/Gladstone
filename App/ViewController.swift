import UIKit
import HealthKit
import Gladstone

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        auth()
    }
    
    func auth() {
        let types = HealthSampleTypes.fitness
        Gladstone.requestAuthorization(toShare: nil, read: types, completion: { complete, error in
            self.query()
        })
    }
    
    func query() {
        Gladstone.latest(.activeEnergyBurned).results({ sample in
            debugPrint("Latest sample for active energy burned: \(sample as Any)")
        })
        
        Gladstone.query(for: .heartRate)
            .sorted(with: [NSSortDescriptor.init(key: HKSampleSortIdentifierStartDate, ascending: false)])
            .limited(to: 10)
            .excludeSource(with: "com.apple")
            .results { results in
                debugPrint(results as Any)
        }
    }
    
}

