![RoadmapHeader Copy@1x](https://user-images.githubusercontent.com/5016984/220204032-55fada28-ca90-4dc9-a931-65242bb6060c.png)

# Roadmap
Publish your roadmap inside your app and allow users to vote for upcoming features, without having to create a backend!


## Example
![RoadmapHeader@1x](https://user-images.githubusercontent.com/5016984/220204046-edec7519-5b1e-4764-9243-5fa6d768b69d.png)

## Setting up Roadmap
### Create a Roadmap JSON
Roadmap works with a remote JSON configuration listing all features and their statuses. We recommend hosting it on GitHub Pages or [simplejsoncms.com](https://simplejsoncms.com/).

An example JSON looks as follows:

```json
[
    {
        "id": "1",
        "title": "Combine sentences",
        "status": "planned",
        "description" : "You can add a little bit of extra context here."
    },
    {
        "id": "2",
        "title": "Open with Finder support",
        "status": "planned"
    },
    {
        "id": "3",
        "title": "Initial Launch",
        "status": "finished",
        "description" : "Release v1 to the public.",
        "isFinished": true
    }
]
```

The keys `id`, `title` are mandatory and all have to be strings. You can use any value for `status` or `description`.

#### Support For Localization 
If you are looking to support localization, then you need to add extra optional parameters in your JSON `localizedTitle`, `localizedDescription` and `localizedStatus` like:
```json
[
  {
    "id": "0",
    "title": "Adding a map",
    "localizedTitle": [
      {
        "language": "ar",
        "value": "اضافة خارطة"
      },
      {
        "language": "en",
        "value": "Adding a map"
      }
    ],
    "status": "planned",
    "localizedStatus": [
      {
        "language": "ar",
        "value": "مجدولة"
      },
      {
        "language": "en",
        "value": "Planned"
      }
    ],
    "description": "some description",
    "localizedDescription": [
      {
        "language": "ar",
        "value": "اضافة خارطة لمعرفة الاماكن القريبة"
      },
      {
        "language": "en",
        "value": "Adding a map to view nearby places"
      }
    ]
  }
]
```

#### Keep a list of finished features
If you add `isFinished` as `true` to a feature in your JSON, the voting view will be hidden for the users & no API call will be made to fetch votes. This is an optional value and it's default value is `false`.

### Add Roadmap using Swift Package Manager

Add `https://github.com/AvdLee/Roadmap.git` within Xcode's package manager.

### Create a Roadmap Configuration instance

Create a new Roadmap configuration following the documentation:

```swift
let configuration = RoadmapConfiguration(
    roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!
)
```

### Use the configuration to construct the view
And use the configuration inside the `RoadmapView`:

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
        nameSpace: "yourappname" // Defaults to your apps bundle id
        allowVoting: true, // Present the roadmap in read-only mode by setting this to false
        allowSearching: false // Allow users to filter the features list by adding a searchbar
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```


![Post Portrait@1x](https://user-images.githubusercontent.com/5016984/220203876-48e5d745-f0cf-4f2a-a4a2-2b801f1407e9.png)
## Styling
By initializing the `RoadmapConfiguration` with a `RoadmapStyle` you can create your own styling.


```swift
public struct RoadmapStyle {
    /// The image used for the upvote button
    let upvoteIcon : Image
    
    /// The font used for the feature
    let titleFont : Font
    
    /// The font used for the count label
    let numberFont : Font
    
    /// The font used for the status views
    let statusFont : Font
    
    /// The tint color of the status view
    let statusTintColor: (String) -> Color
    
    /// The corner radius for the upvote button
    let radius : CGFloat
    
    /// The backgroundColor of each cell
    let cellColor : Color
    
    /// The color of the text and icon when voted
    let selectedForegroundColor : Color
    
    /// The main tintColor for the roadmap views.
    let tintColor : Color
    
    public init(icon: Image,
                titleFont: Font,
                numberFont: Font,
                statusFont: Font,
                statusTintColor: @escaping (String) -> Color = { _ in Color.primary },
                cornerRadius: CGFloat,
                cellColor: Color = Color.defaultCellColor,
                selectedColor: Color = .white,
                tint: Color = .accentColor) {
        
        self.upvoteIcon = icon
        self.titleFont = titleFont
        self.numberFont = numberFont
        self.statusFont = statusFont
        self.statusTintColor = statusTintColor
        self.radius = cornerRadius
        self.cellColor = cellColor
        self.selectedForegroundColor = selectedColor
        self.tintColor = tint
        
    }
}

```
![Post Portrait Copy@1x](https://user-images.githubusercontent.com/5016984/220203716-2e4a90ad-dd80-4acb-a240-ad26adfca2ef.png)

### Templates
If you don't wan't to configure your own style you can also use one of the templates. You have the option between `Standard`, `Playful`, `Classy` and `Technical` so pick whichever works best for your app. 


Example

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
        namespace: "roadmap",
        style: RoadmapTemplate.playful.style, // You can also create your own RoadmapStyle
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```

## Persisting Votes
By default, Roadmap will utilise the [Free Counting API](https://countapi.xyz/) to store votes, you can check out their website for more information. A namespace is provided for you, utilising your application's bundle identifier, but you can override this when initalising the `RoadmapConfiguration`.

```swift
let configuration = RoadmapConfiguration(
    roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
    namespace: "my-custom-namespace"
)
```

### Defining Custom Voter Service
If you'd rather use your own API, you may create a new struct conforming to `FeatureVoter`. This has two required functions in order to retrieve the current vote count and to cast a new vote.

```swift
struct CustomFeatureVoter: FeatureVoter {
    var count = 0

    func fetch(for feature: RoadmapFeature) async -> Int {
        // query data from your API here
        return count
    }
    
    func vote(for feature: RoadmapFeature) async -> Int? {
        // push data to your API here
        count += 1
        return count
    }
}
```

You may then pass an instance of this struct to the `RoadmapConfiguration`.

```swift
let configuration = RoadmapConfiguration(
    roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
    voter: CustomFeatureVoter()
)
```

## FAQ
### Does Roadmap prevent users from voting multiple times?
Yes, if a user has voted on a feature they won't be able to vote again from within your app. Users can intercept your network traffic and replay the api call if they're really desperate to manipulate your votes.

### Can Roadmap be customized to fit the look and feel of my app?
Roadmap comes with four different preconfigured styles to match most apps. You can change the tintColor, upvote image and more.

### What OS versions are supported?
To keep development of Roadmap easy and fun, we've decided to support iOS 15 & above and macOS Monterey & Ventura for now.

### Can I sort my roadmap by most voted?
Right now the list of features is loaded in random order. Our thinking is that this will prevent bias for the top voted features. We'll look into ways to make this possible in the future but since the votes are retrieved after the view has been loaded we'll need to look into it.

### Do I need to make changes to my app privacy report if I use Roadmap?
Roadmap does not do any analytics or tracking. If a user voted on a feature it will increment a number on the count api. No identifiers are stored, not even anonymous ones.
### Is it possible for stupid people to manipulate my roadmap?
Yes, we wanted to keep Roadmap as simple as possible to setup. If you're worried about competitors (or a user that really wants a specific feature) messing with your priority list, maybe use something else.

### Can I help contribute?
Yes, please! We would love to invite you to pick up any of the open issues. We'll review your Pull Requests accordingly.

## Projects using Roadmap
- [MacWhisper](https://www.macwhisper.com)
- [RocketSim](https://www.rocketsim.app)
- [NowPlaying](https://apps.apple.com/us/app/nowplaying-record-display/id1596487035?l=en)
- [Stuny](https://apple.co/3HM88Pv)
- [Stock Analyzer](https://apps.apple.com/nl/app/stock-analyzer/id1614853142)
- [Super Coder](https://supercoder.lessimore.cn)
- [SF Symbols Game](https://apps.apple.com/in/app/sf-symbols-game/id1507692602)
- [Gola](https://apps.apple.com/us/app/gola-goal-tracking/id1661833753?l=en)
- [Rahhal | رحَّال](https://apps.apple.com/app/id1672846506)
- [Cronica](https://apps.apple.com/app/id1614950275)
- [Photo Club Waalre](https://apps.apple.com/nl/app/fotogroep-waalre/id1178324330)


If you've integrated Roadmap into your app and you want to add it to this list, please make a Pull Request.

## Authors
This library is created in collaboration between [Jordi Bruin](https://twitter.com/jordibruin), [Hidde van der Ploeg](https://twitter.com/hiddevdploeg), and [Antoine van der Lee](https://www.twitter.com/twannl)

## License

Roadmap is available under the MIT license. See the LICENSE file for more info.

