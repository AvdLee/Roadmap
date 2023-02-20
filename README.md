![RoadmapHeader Copy@1x](https://user-images.githubusercontent.com/5016984/220204032-55fada28-ca90-4dc9-a931-65242bb6060c.png)

# Roadmap
Publish your roadmap inside your app and allow users to vote for upcoming features, without having to create a backend!


## Example
![RoadmapHeader@1x](https://user-images.githubusercontent.com/5016984/220204046-edec7519-5b1e-4764-9243-5fa6d768b69d.png)

## Setting up Roadmap
### Create a Roadmap JSON
Roadmap works with a remote JSON configuration listing all features and their statuses. We recommend hosting it at [simplejsoncms.com](https://simplejsoncms.com/).

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
    }
]
```

The keys `id`, `title` are mandatory and all have to be strings. You can use any value for `status` or `description`.

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
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```

## Styling
By initializing the `RoadmapConfiguration` with a `RoadmapStyle` you can create your own styling or use one of the four ready-to-use `RoadmapTemplate`.  

Example

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/k2f11wikc6")!,
        namespace: "roadmaptest",
        style: RoadmapTemplate.playful.style, // You can also create your own RoadmapStyle
        tint: Color.teal
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```

![Post Portrait Copy@1x](https://user-images.githubusercontent.com/5016984/220203716-2e4a90ad-dd80-4acb-a240-ad26adfca2ef.png)

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

![Post Portrait@1x](https://user-images.githubusercontent.com/5016984/220203876-48e5d745-f0cf-4f2a-a4a2-2b801f1407e9.png)

## License

Roadmap is available under the MIT license. See the LICENSE file for more info.

