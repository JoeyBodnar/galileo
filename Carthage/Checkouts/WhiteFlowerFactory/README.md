WhiteFlowerFactory is a simple URLSession wrapper I use in private projects. It was built by me and for me, so while I will take bug issues on this library, I will not accept feature requests. 

### Why WhiteFlowerFactory?
"But, Alamofire already exists and URLSession is easy to use--so what is the point of this library?"

Several reasons:
1) This is a much smaller dependency, and it's my own code. 
2) It is limited in scope. Alamofire is a huge library packed full of features that not everyone needs. WhiteFlowerFactory supports basic HTTP requests and makes use of the Result type in Swift 5, as well as adopting Codable support. All in very little code (it is about 550 lines of code in total, and a lot of those are convenience functions)
3) WhiteFlowerFactory supports serial APIRequests out of the box with a very simple syntax

### Installation with Cocoapods

    pod 'WhiteFlowerFactory'
    
Don't forget to add 'use_frameworks!' to your Podfile.

### Usage

#### Get requests
To make a simple GET request:

    WhiteFlower.shared.get(urlString: "https://jsonplaceholder.typicode.com/todos/") { (response) in
        response.result.onSuccess({ data in
            // data iis of type Data?
        }).onError({ error in
            // error is of type NetworkError
        })
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
      
### Codable support
Suppose you have a model, Post, that conforms to Codable. If you want to get an array of posts from your api, just do the following:

    WhiteFlower.shared.get(urlString: "www.myapi.com/posts") { response in
        response.result.parse(type: [Post].self) { result in
            switch result {
            case .success(let posts): // posts is an array of Post objects
                print("posts are \(posts)")
            case .failure(let error):
                print("error is \(error)")
            }
        }
    }



    
