# Shaky

`Shaky` is an open source iOS library that makes it easy for users to send feedback by shaking their device. It provides a customizable feedback form that allows users to enter a feedback description, select a feedback category, attach an image, and mark something on the picture using the editing tool.

## Features

- Easy to integrate with any iOS app.
- Customizable feedback form.
- Shake detection with customizable threshold.
- Send feedback data to your analytics platform like Firebase.

## Installation

### Swift Package Manager

You can use Swift Package Manager to install `Shaky` by adding it to your Xcode project:

1. In Xcode, go to File > Swift Packages > Add Package Dependency.
2. Enter the URL of the `Shaky` repository: `https://github.com/example/Shaky.git`.
3. Select the version or branch you want to use.
4. Click "Next" and "Finish".

### Manually

You can also install `Shaky` manually by copying the source files into your Xcode project.

1. Download the latest version of `Shaky` from the repository.
2. Copy the `Shaky` folder into your Xcode project.

## Usage

1. Import the `Shaky` module into your app:

```swift
import Shaky
```

2. Set the ShakyDelegate to receive feedback events:

```swift
class ViewController: UIViewController, ShakyDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Shaky.sharedInstance.delegate = self
        Shaky.sharedInstance.start()
    }
    
    func shakyDidSubmit(_ feedback: ShakyFeedback) {
        // Handle feedback submission
    }
    
    func shakyDidCancel() {
        // Handle feedback cancellation
    }
}
```

3. (Optional) Example of Firbase using Shaky.analytics closure to handle sending feedback events to your analytics platform:

```swift
    func shakyDidSubmit(_ feedback: ShakyFeedback) {
        Shaky.analytics = { feedback in
            Analytics.logEvent("feedback_submitted", parameters: [
                "description": feedback.description,
                "category": feedback.category ?? "",
                "has_image": feedback.image != nil
            ])
        }
    }
```

4. (Optional) Customize the shake threshold by passing a value to the start() method:

```swift
Shaky.sharedInstance.start(shakeThreshold: 3)
```

## License
Shaky is available under the MIT license. See the [LICENSE](LICENSE) file for more information.


