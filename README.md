Galileo is a Reddit browser for macOS. It is built with Swift and AppKit using Xcode 11.4.

#### Features

Features currently supported:

- Sign in with your reddit account
- Browse posts and upvote/downvote posts
- View your subreddit subscriptions
- View trending subreddits
- Search all reddit or search a specific subreddit
- View posts and comments. 
- upvote/downvote  on comments
- Respond to comments
- View your mailbox, and respond to comments in your mailbox
- Sort posts
- View Reddit hosted videos and image, imgur hosted gifs and images, and youtube videos
- Save and unsave posts
- Tabbed windows

Features Planning to support:
- Save comments
- autofill subreddit suggestions when typing in "go to subreddit" box
- add links to Post detail view for link posts
- better support for window resizing
- Change "All" icon on sidebar to be different from that of thhe Home button
- CMD+T for opening a new window
- handle callbacks for errors when commenting
- sorting comments

Features I am not planning to support (but would welcome a pull request on):
- create a post
- view user's profiles

#### Tech

- I use my own networking library, [WhiteFlowerFactory](https://github.com/JoeyBodnar/WhiteFlowerFactory) for HTTP routing
- I use [CocoaMarkdown](https://github.com/indragiek/CocoaMarkdown) to support markdown. This is the only 3rd party library used in the app.
- I use all native AppKit components for rendering all views. Markdown is rendered on an NSTextView using NSAttributedString, not a webview.
- I use MVVM for the architecture
