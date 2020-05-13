Galileo is a Reddit browser for macOS. It is built with Swift and AppKit using Xcode 11.4.

<img src="https://ucarecdn.com/8850b166-168d-4321-ac45-7f7d0bd1e4c5/ScreenShot20200505at110423PM.png" style="width: 450px; height: 294px"></img>

#### Features

Features currently supported:

- Sign in with your reddit account
- Browse posts and upvote/downvote posts
- View your subreddit subscriptions
- View trending subreddits
- Search all reddit or search a specific subreddit
- View posts and comments. 
- upvote/downvot comments
- Respond to comments
- View your mailbox, and respond to comments in your mailbox
- Sort posts
- View Reddit hosted videos and image, imgur hosted gifs and images, and youtube videos
- Save and unsave posts
- Tabbed windows

Features Planning to support:
- Logout
- Save comments
- autofill subreddit suggestions when typing in "go to subreddit" box
- add links to Post detail view for link posts
- better support for window resizing
- Change "All" icon on sidebar to be different from that of the Home button
- CMD+T for opening a new window
- handle callbacks for errors when commenting
- sorting comments

Features I am not planning to support (but would welcome a pull request on):
- create a post
- view user's profiles

### Run the app locally

To run the app locally, you will need to create an app with the Reddit API (https://www.reddit.com/prefs/apps/) and then use your client ID (`REDDIT_CLIENT_ID` in this project). For `BEARER_AUTH_HEADER`, you will need to use Basic HTTP athenticatin, using your client ID as the username and an empty string as the password. So your `BEARER_AUTH_HEADER` value will be something like `Basic xxxxxxx`. `REDDIT_AUTH_URL_STATE` can be any random string you would like.

#### Tech

- I use my own networking library, [WhiteFlowerFactory](https://github.com/JoeyBodnar/WhiteFlowerFactory) for HTTP routing
- I use [CocoaMarkdown](https://github.com/indragiek/CocoaMarkdown) to support markdown. This is the only 3rd party library used in the app.
- I use all native AppKit components for rendering all views. Markdown is rendered on an NSTextView using NSAttributedString, not a webview.
- I use MVVM for the architecture