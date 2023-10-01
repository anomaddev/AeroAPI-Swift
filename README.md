# AeroAPI

A Swift library to integrate the FlightAware AeroAPI into you app. This library is currently a work in progress.

### In Progress
Since this library is still a work in progress. You can use the chart below to track which AeroAPI functions are supported in the library at current.

### Getting Started

#### Installing Library
[Swift Package Manager](https://swift.org/package-manager/) is Apple's dependency manager tool. It can be used alongside other tools like CocoaPods and Carthage as well.

To install the AeroAPI package into your packages, add a reference to AeroAPI and a targeting branch (versioning will coming in future releases) in the dependencies section in Package.swift file:
``` swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    products: [],
    dependencies: [
        .package(url: "https://github.com/anomaddev/AeroAPI-Swift.git", branch: "main")
    ]
)
```

To install the AeroAPI package via Xcode
- Go to File -> Swift Packages -> Add Package Dependency...
- Then search for https://github.com/anomaddev/AeroAPI-Swift.git
- And choose the version you want

#### Setting the API key
You will need to set your API key before you can use the library in your application. You can do this in your AppDelegate or in the initialization of your SwiftUI app.

``` swift
AeroAPI.manager.set(apiKey: "api-key-goes-here")
```

### Using the Library

Examples coming soon...

### Supported Endpoints - [FlightAware Docs](https://www.flightaware.com/aeroapi/portal/documentation)

##### Alerts
[ ❌ ] - GET /alerts<br>
[ ❌ ] - PUT /alerts<br>
[ ❌ ] - GET /alerts/{id}<br>
[ ❌ ] - PUT /alerts/{id}<br>
[ ❌ ] - DELETE /alerts/{id}<br>
[ ❌ ] - GET /alerts/endpoint<br>
[ ❌ ] - PUT /alerts/endpoint<br>
[ ❌ ] - DELETE /alerts/endpoint<br>

##### Flights
[ ❌ ] - GET /flights/{id}/map<br>
[ ❌ ] - GET /flights/{id}/position<br>
[ ✅ ] - GET /flights/{id}/route<br>
[ ✅ ] - GET /flights/{id}/track<br>
[ ✅ ] - GET /flights/{ident}<br>
[ ❌ ] - GET /flights/{ident}/canonical<br>
[ ❌ ] - POST /flights/{ident}/intents<br>
[ ❌ ] - GET /flights/search/<br>
[ ❌ ] - GET /flights/search/advanced<br>
[ ❌ ] - GET /flights/search/count<br>
[ ❌ ] - GET /flights/search/positions<br>

##### Foresight
[ ❌ ] - GET /foresight/flights/{id}/position<br>
[ ❌ ] - GET /foresight/flights/{ident}/<br>
[ ❌ ] - GET /foresight/flights/search/advanced<br>

##### Airports
[ ❌ ] - GET /airports<br>
[ ✅ ] - GET /airports/{id}<br>
[ ❌ ] - GET /airports/{id}/canonical<br>
[ ✅ ] - GET /airports/{id}/delays<br>
[ ✅ ] - GET /airports/{id}/flights<br>
[ ✅ ] - GET /airports/{id}/flights/arrivals<br>
[ ✅ ] - GET /airports/{id}/flights/counts<br>
[ ✅ ] - GET /airports/{id}/flights/departures<br>
[ ✅ ] - GET /airports/{id}/flights/scheduled_arrivals<br>
[ ✅ ] - GET /airports/{id}/flights/scheduled_departures<br>
[ ❌ ] - GET /airports/{id}/flights/to/{dest_id}<br>
[ ❌ ] - GET /airports/{id}/nearby<br>
[ ❌ ] - GET /airports/{id}/routes/{dest_id}<br>
[ ❌ ] - GET /airports/{id}/weather/forecast<br>
[ ❌ ] - GET /airports/{id}/observation<br>
[ ❌ ] - GET /airports/delays<br>
[ ❌ ] - GET /airports/nearby<br>

##### Operators
[ ❌ ] - GET /operators<br>
[ ✅ ] - GET /operators/{id}<br>
[ ❌ ] - GET /operators/{id}/canonical<br>
[ ❌ ] - GET /operators/{id}/flights<br>
[ ❌ ] - GET /operators/{id}/flights/arrivals<br>
[ ✅ ] - GET /operators/{id}/flights/counts<br>
[ ❌ ] - GET /operators/{id}/flights/enroute<br>
[ ❌ ] - GET /operators/{id}/flights/scheduled<br>

##### History
[ ❌ ] - GET /history/aircraft/{registration}/last_flight<br>
[ ❌ ] - GET /history/flights/{id}/map<br>
[ ✅ ] - GET /history/flights/{id}/route<br>
[ ✅ ] - GET /history/flights/{id}/track<br>
[ ✅ ] - GET /history/flights/{ident}<br>

##### Miscellaneous
[ ❌ ] - GET /aircraft/{ident}/blocked<br>
[ ❌ ] - GET /aircraft/{ident}/owner<br>
[ ✅ ] - GET /aircraft/types/{type}<br>
[ ❌ ] - GET /disruption_counts/{entity_type}<br>
[ ❌ ] - GET /disruption_counts/{entity_type}/{id}<br>
[ ❌ ] - GET /schedules/{date_start}/{date_end}<br>
