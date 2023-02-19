# Roadmap
Publish your roadmap inside your app and allow users to vote for upcoming features

## Example
<HIDDE_TO_SHOW_IMAGE>

## Setting up Roadmap
Create a new Roadmap configuration following the documentation:

```swift
public struct RoadmapConfiguration {
    /// The URL pointing to the JSON in the `Roadmap` format.
    public let roadmapJSONURL: URL

    /// A unique namespace to use matching your app.
    /// See `https://countapi.xyz/` for more information.
    /// Recommended: your bundle identifier.
    public let namespace: String

    public init(roadmapJSONURL: URL, namespace: String) {
        self.roadmapJSONURL = roadmapJSONURL
        self.namespace = namespace
    }
}
```

For example:

```swift
let configuration = RoadmapConfiguration(
    roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!,
    namespace: "roadmaptest"
)
```

And use the configuration inside the `RoadmapView`:

```swift
struct ContentView: View {
    let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!,
        namespace: "roadmaptest"
    )

    var body: some View {
        RoadmapView(configuration: configuration)
    }
}
```

## Projects using Roadmap
- [MacWhisper](https://goodsnooze.gumroad.com/l/macwhisper)
- [RocketSim](https://www.rocketsim.app)

## Installation
### Swift Package Manager

Add `https://github.com/AvdLee/Roadmap.git` within Xcode's package manager.

#### Manifest File

Add Roadmap as a package to your `Package.swift` file and then specify it as a dependency of the Target in which you wish to use it.

```swift
import PackageDescription

let package = Package(
    name: "MyProject",
    platforms: [
       .macOS(.v10_15)
       .iOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/AvdLee/Roadmap.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "MyProject",
            dependencies: ["Roadmap"]),
        .testTarget(
            name: "MyProjectTests",
            dependencies: ["MyProject"]),
    ]
)
```

## Authors
This library is created in collaboration between [Jordi Bruin](https://twitter.com/jordibruin), [Hidde van der Ploeg](https://twitter.com/hiddevdploeg), and [Antoine van der Lee](https://www.twitter.com/twannl)

## License

Roadmap is available under the MIT license. See the LICENSE file for more info.

