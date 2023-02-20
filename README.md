# Roadmap
Publish your roadmap inside your app and allow users to vote for upcoming features

## Example
<img width="1206" alt="IMG_8113" src="https://user-images.githubusercontent.com/170948/220112677-fdd0b374-7112-47ce-8f20-0eb015e2529c.png">

## Setting up Roadmap
### Create a Roadmap JSON
Roadmap works with a remote JSON configuration listing all features and their statuses. We recommend hosting it at [simplejsoncms.com](https://simplejsoncms.com/).

An example JSON looks as follows:

```json
[
    {
        "id": "1",
        "title": "Combine sentences",
        "status": "planned"
    },
    {
        "id": "2",
        "title": "Open with Finder support",
        "status": "planned"
    }
]
```

The keys `id`, `title` and `status` are mandatory and all have to be strings. You can use any value for `status`.

### Add Roadmap using Swift Package Manager

Add `https://github.com/AvdLee/Roadmap.git` within Xcode's package manager.

### Create a Roadmap Configuration instance

Create a new Roadmap configuration following the documentation:

```swift
let configuration = RoadmapConfiguration(
    roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!
)
```

### Use the configuration to construct the view
And use the configuration inside the `RoadmapView`:

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```

### Styling
By initializing the `RoadmapConfiguration` with a `RoadmapStyle` you can create your own styling or use one of the four ready-to-use `RoadmapTemplate`.  

Example

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!,
        namespace: "roadmaptest",
        style: RoadmapTemplate.playful.style, // You can also create your own RoadmapStyle
        tine: Color.teal
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```


## FAQ
### How does Roadmap store votes?
We make use of the [Free Counting API](https://countapi.xyz/)

### Can I help contributing?
Yes, please! We would love to invite you to pick up any of the open issues. We'll review your Pull Requests accordingly.

## Projects using Roadmap
- [MacWhisper](https://www.macwhisper.com)
- [RocketSim](https://www.rocketsim.app)
- [NowPlaying](https://apps.apple.com/us/app/nowplaying-record-display/id1596487035?l=en)

## Authors
This library is created in collaboration between [Jordi Bruin](https://twitter.com/jordibruin), [Hidde van der Ploeg](https://twitter.com/hiddevdploeg), and [Antoine van der Lee](https://www.twitter.com/twannl)

## License

Roadmap is available under the MIT license. See the LICENSE file for more info.

