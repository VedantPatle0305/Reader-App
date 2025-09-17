# Reader App

An iOS application built with **UIKit** and **MVC architecture** that fetches and displays top business news of US.  

---

## Features
- Fetch articles using NewsAPI.
- Display articles with title, author, and thumbnail.
- Pull-to-refresh for latest news.
- Search articles by title or author.
- Bookmark/unbookmark articles with persistence using **Core Data**.
- Open articles inside the app using **SafariViewController**.

---

Please note that the project was developed and tested using Xcode 16.4.

---

Libraries:
1. SDWebImage -> Handles async image downloading and caching automatically.
    imageView.sd_setImage(with: URL(string: urlString))

2. Kingfisher -> Similar to SDWebImage, lightweight and Swift-friendly.
   imageView.kf.setImage(with: URL(string: urlString))

3. Alamofire -> A powerful networking library to simplify URLSession.


