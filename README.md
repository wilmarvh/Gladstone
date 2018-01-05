# Gladstone
An experiment to see if the HealthKit querying api can be simplified into something that resembles Alamofire

```swift
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
```
