# Kukushka iOS SDK

**Kukushka SDK** makes it easy to give players survey tasks followed by a reward. The SDK can be installed and set up in minutes.

**Android SDK** can be found [here](https://github.com/kykyshkaDev/Kukushka_AndroidSDK)

**Unity SDK** can be found [here](https://github.com/kykyshkaDev/kukushka_UnitySDK)

## Usage

**Just create SurveyMaster:**
```swift
let master = SurveyMaster(
            userId: String,
            gameKey: String,
            debugMode: Bool
        )
```
Now you can call two main methods of Kykyshka SDK to preload and show Survey for user:
```swift
master.hasSurvey()    // To Check and Preload Available Survey for this user
master.showSurvey()  // To Show Survey for user
```
**SDK Callbacks:**<br/>
Kukushka SDK has a lot of different Callbacks for your game. Use this callbacks to detect Survey Complete or problems with loading.

| Callback             | Parameters                   | Usage                                                                  |
|----------------------|------------------------------|------------------------------------------------------------------------|
| **OnSurveyStart** | -                            | Called when user started survey                                        |
| **OnSurveyAvailable** | -                            | Called after preloading if surveys available                           |
| **OnSurveyUnavailable** | -                            | Called after preloading if surveys unavailable                         |
| **OnSurveySuccess** | **Bool** or **nil**          | Called when user complete survey. May contain additional data.         |
| **OnFail**    | **Any** or **nil** | Called when user got error in the survey. May contain additional data. |
| **OnLoadFail** | -                            | Called when Survey has loading error                                   |
| **OnError** | -                            | On General SDK Errors Callback   

**Callbacks Example:**
```swift
// Add Survey Callbacks
master?.onSurveyStart = { _ in
    print("[ViewController] onSurveyStart")
}
master?.onSurveySuccess = { [weak self] nq in
    guard let nq, nq else {
        self?.statusLabel.text = "Survey completed"
        return
    }
    self?.statusLabel.text = "User was screened out"
}
master?.onFail = { [weak self] _ in
    self?.statusLabel.text = "Survey not complete"
}
master?.onLoadFail = { [weak self] _ in
    self?.statusLabel.text = "Loading error"
}
            
// Add Preloading Callbacks
master?.onSurveyAvailable = { [weak self] data in
    self?.statusLabel.text = "An available survey found"
}
master?.onSurveyUnavailable = { [weak self] data in
    self?.statusLabel.text = "No available survey found"
    
}
```
**Screen Orientation:**

Please, note: Currently version of Kukushka SDK supports only Portrait orientation and your game orientation will be force changed to Portrait at Survey opening and returned to last orientation after Survey closed.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 13.0+
- Swift 5

## Installation

Kukushka_iOSSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Kukushka_iOSSDK'
```

## Author

Name, contacts

## License

Kukushka_iOSSDK is available under the MIT license. See the LICENSE file for more info.
