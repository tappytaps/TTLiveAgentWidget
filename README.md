TTLiveAgentWidget
=======

Live agent widget for iOS written in swift.

This widget is not just an email type of support widget. The TTLiveAgentWidget shows knowledgebase articles to users, so they can quickly find a solution for their issue. It works with any live agent server with API version 1. 

For better performance and security we recommend to use a proxy server. See our proxy server [TTLiveAgentWidget-ProxyServer](https://github.com/tappytaps/TTLiveAgentWidget-ProxyServer).

Instalation
----------

- Requires iOS 10.0+

#### Swift Package Manager

1. Open `MenuBar` → `File` → `Swift Packages` → `Add Package Dependency...`
2. Paste the package repository url `https://github.com/tappytaps/TTLiveAgentWidget.git` and hit Next.

#### Manually

Manually drop content of `Pod` folder in your project.

#### CocoaPods

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

pod 'TTLiveAgentWidget'
```

Usage
----------

First thing is to import the widget.

```
// Swift
import TTLiveAgentWidget 
```

Before you start using widget you have to configure it. At least you have to set API URL, live agent folder ID where the knowledgebase articles will be obtained, knwledgebase topics and support email. The basic configuration looks like:

```swift
let liveAgentWidget = TTLiveAgentWidget.shared

liveAgentWidget.apiURL = "http://liveagent.server"
liveAgentWidget.apiKey = "123456"
liveAgentWidget.apiFolderId = 10
liveAgentWidget.supportEmail = "support@something.com"

// Set topics
supportWidget.topics = [
    TTLiveAgentTopic(key: "ios-general", image: UIImage(named: "general"), title: "General issue"),
    TTLiveAgentTopic(key: "ios-problem", image: UIImage(named: "problem"), title: "Something is not working")
]

```

Best place to config widget is AppDelegate's `didFinishLaunchingWithOptions`. There you should also load new articles from server. So it looks like:

```swift
let liveAgentWidget = TTLiveAgentWidget.shared

liveAgentWidget.apiURL = "http://liveagent.server"
liveAgentWidget.apiKey = "123456"
liveAgentWidget.apiFolderId = 10
liveAgentWidget.supportEmail = "support@something.com"

// Set topics
supportWidget.topics = [
    TTLiveAgentTopic(key: "ios-general", image: UIImage(named: "general"), title: "General issue"),
    TTLiveAgentTopic(key: "ios-problem", image: UIImage(named: "problem"), title: "Something is not working")
]

liveAgentWidget.updateArticles(completion: nil)
```

Then usage of the widget is simple as:

```swift
// Get Support widget instance
let supportWidget = TTLiveAgentWidget.shared()

// Open widget
supportWidget.open(from: self)
```

Configuration
----------

On TTLiveAgentWidget you can edit following attributes:

- `topics` - topics of knowledgebase articles
- `supportEmail` - support email address
- `supportEmailSubject` - subject for support email
- `supportEmailFooter` - Dictionary of parameters for email footer
- `apiURL` - live agent server url
- `apiKey` - live agent api key (you should use proxy server to hide your api key)
- `apiFolderId` - live agent folder id with knowledgebase articles
- `apiLimitArticles` - limit articles from live agent api

API
----------

##### open(from controller: UIViewController, topicKey: String? = **nil**, transition: TransitionStyle = .present)

Opens widget from controller. 

##### updateArticles(completion: ((Result<Void, Error>) -> Void)?)

Asynchronously download articles from live agent. You can handle success or error states.

##### openMailComposer(from controller: UIViewController, topicTitle: String? = **nil**)

Opens widget's email composer. Topic is added to email's footer.
