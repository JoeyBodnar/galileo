WhiteFlowerFactory is a simple URLSession wrapper with support for both concurrent and serial request queues.

### Installation with Cocoapods

    pod 'WhiteFlowerFactory'

### Usage
Right now all callbacks are completed on the main queue, though this is subject to change in the near future.

#### Get requests
To make a simple GET request:

    WhiteFlower.shared.get(urlString: "") { response in
        switch response.result {
        case .success(let data): // do something with data
        case .failure(let error): // do something with network error
        }
    }
    
#### Serialize response using Codable

If you have a type and want to serialize the response using Codable:

    WhiteFlower.shared.get(urlString: "") { response in
        switch response.serializeTo(type: MyClass.self) {
            case .success(let myClassInstance): // do something with myClassInstance
            case .failure(let error): // do something with network error  
        }
    }
   
#### Test if OK
sometimes you just want to make sure an object was created, and expect a response with an empty body. For that, use `isOK()`:

    WhiteFlower.shared.post(urlString: "https://www.facebook.com/postSomething", params: ["key": "value"], headers: nil, completion: { (response) in
        switch response.isOk() {
        case .success: // success
        case .failure(let error)
        }
    }

#### POST requests
A sample POST request:

    WhiteFlower.shared.post(urlString: "urlHere", params: ["testParam" : "param1"], headers: [HTTPHeader(field: HTTPHeaderField.authentication.rawValue, value: "Bearer xxxx")]) { (response) in
            
    }
    
### Providers - Type safe routing
To provide type-safe routing with WhiteFlowerFactory, it is recommended that you create an enum that adopts to the `Provider` protocol. Ideally, you will have 1 enum conform to the Provider protocol for each baseURL endpoint your app has. For example, suppose your app needs to connect to the Stripe API and the Facebook API. You would create an enum that conforms to the `Provider` protocol, like so:

    enum Facebook: Provider {
        case login
        case getFriends
        
        var path: String {
            switch self {
            case .login: return "\(baseURL)/login"
            case .getFriends: return "\(baseURL)/me/friends"
            }
        }

        var baseURL: String { return "https://facebook.com" }

        static var name: String { return String(describing: Facebook.self) // this returns "Facebook" }
    }
    
Then, likewise for Stripe:

    enum Stripe: Provider {
        case chargeCard
        
        var path: String {
            switch self {
            case .chargeCard: return "\(baseURL)/charge"         
            }
        }

        var baseURL: String { return "https://api.stripe.com" }

        static var name: String { return String(describing: Stripe.self)  }
    }
    
Now, you can make use of type safe routing:

    WhiteFlower.shared.post(endPoint: Stripe.chargeCard, params: ["":""], headers: []) { (response) in
            
    }
    
### Serial network operations
To make requests serially (one after another, waiting until the previous request is finshed before starting the next request), just create an array of `WhiteFlowerRequest` objects and create a `WhiteFlowerSerialQueue`:

      let requests = [WhiteFlowerRequest(method: .get, urlString: "https://facebook.com"), WhiteFlowerRequest(method: .get, urlString: "https://google.com"), WhiteFlowerRequest(method: .get, urlString: "https://reddit.com/r/iosprogramming")]
      
      let queue = WhiteFlowerSerialQueue(operationQueue: OperationQueue())
      
      queue.start(requests: requests, operationCompletion: { (response) in
          // this completion is called after every indiviudal request is finished
          // so in this examlple, it will be called 3 times
      }) { (allResponses) in
          // this is called at the very end and gives an array of APIResponse objects
      }
      
### Concurrent network operations
To make multiple requests concurrently and then receive a callback only once all requests have completed, use the `WhiteFlowerConcurrentQueue` class:

    let requests = [WhiteFlowerRequest(method: .get, urlString: "https://facebook.com"), WhiteFlowerRequest(method: .get, urlString: "https://google.com"), WhiteFlowerRequest(method: .get, urlString: "https://reddit.com/r/iosprogramming")]

    let queue = WhiteFlowerConcurrentQueue(requests: [], queue: DispatchQueue.main)
    queue.execute { responses in
        // `responses` is an array of APIResponse objects
    }
    
The `responses` array will return the responses in the same order that they were originally executed. So for the example above, the response object for the `https://facebook.com` request would be first, google would be second, and reddit.com/r/iosprogramming would be last

    
