TTLiveAgentWidget
=======

Live agent widget for iOS written in swift.

This widget is not just an email type of support widget. The TTLiveAgentWidget shows knowledgebase articles to users, so they can quickly find a solution for their issue. It works with any live agent server with API version 1. 

For better performance and security we recommend to use a proxy server.

<img src="docs/screen1.PNG" width="240px">
<img src="docs/screen2.PNG" width="240px">

Usage
----------

Before you start using widget you have to configure it. At least you have to set API URL, live agent folder ID where the knowledgebase articles will be obtained, knwledgebase topics and support email. The basic configuration looks like:

```
let liveAgentWidget = TTLiveAgentWidget.getInstance()

liveAgentWidget.apiURL = "http://liveagent.server"
liveAgentWidget.apiKey = "123456"
liveAgentWidget.folderId = "10"
liveAgentWidget.supportEmail = "support@something.com"

// Set topics
supportWidget.topics = [
	SupportTopic(key: "ios-general", title: "General issue"),
	SupportTopic(key: "ios-problem", title: "Something is not working")
]

``` 

Best place to config widget is AppDelegate's `didFinishLaunchingWithOptions`. There you should also load new articles from server. So it looks like:

```
let liveAgentWidget = TTLiveAgentWidget.getInstance()

liveAgentWidget.apiURL = "http://liveagent.server"
liveAgentWidget.apiKey = "123456"
liveAgentWidget.folderId = "10"
liveAgentWidget.supportEmail = "support@something.com"

// Set topics
supportWidget.topics = [
	SupportTopic(key: "ios-general", title: "General issue"),
	SupportTopic(key: "ios-problem", title: "Something is not working")
]

liveAgentWidget.updateArticles(nil, onError: nil)
```

Then usage of the widget is simple as:

```
// Get Support widget instance
var supportWidget = TTLiveAgentWidget.getInstance()

// Open widget
supportWidget.open(fromController: self, style: .Push)
```

Configuration
----------

On TTLiveAgentWidget you can edit following attributes:

- `topics` - topics of knowledgebase articles
- `maxArticlesCount` - max articles in topic
- `supportEmail` - support email address
- `supportEmailSubject` - subject for support email
- `supportEmailFooter` - Dictionary of parameters for email footer
- `apiURL` - live agent server url
- `apiKey` - live agent api key (you should use proxy server to hide your api key)
- `folderId` - live agent folder id with knowledgebase articles

If you use `.Present` style (not recommended for `.Push`), you can also configure navigation bar look by these attributes:

- `tintColor` - navigation bar tint color
- `navigationBarCollor` - navigation bar background color
- `titleColor` - navigation bar title color
- `statusBarStyle` - status bar style (UIBarStyle)

API
----------

##### open(fromController controller: UIViewController, style: TTLiveAgentWidgetStyle)

Open widget from `controller` with style. Style can be either `.Present` (widget will be presented) or `.Push` (widget will be pushed in navigation controller). If `controller` is not embedded in `UINavigationController` you should use `.Present`. If widget has no articles, then widget open email window directly.

##### open(fromController controller: UIViewController, keyword: String, style: TTLiveAgentWidgetStyle)

Open knowledgebase articles directly. If `keyword` is not contained in widget's topics then widget will be opened same way as with `open(fromController controller: UIViewController, style: TTLiveAgentWidgetStyle)`.

##### updateArticles(onSuccess: (()->Void)?, onError: (()->Void)?)

Asynchronously download articles from live agent. You can handle success or error states.

##### openEmailComposer(fromController controller: UIViewController, topic: SupportTopic?)

Opens widget's email composer. Topic is added to email's footer.
