//
//  BookmarksViewController.swift
//  Reader App
//
//  Created by Vedant Patle on 16/09/25.
//

import UIKit
import SafariServices

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bookmarkTableView: UITableView!
    private var bookmarks: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"

        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        bookmarkTableView.register(nib, forCellReuseIdentifier: "ArticleCell")
            
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }
    
    private func loadBookmarks() {
        bookmarks = PersistenceManager.shared.fetchBookmarkedArticles()
        bookmarkTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bookmarks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticlesTableViewCell else {
                return UITableViewCell()
            }
            
            let article = bookmarks[indexPath.row]
            
            // Check bookmark state
            let isBookmarked = PersistenceManager.shared.isBookmarked(article)
            cell.configure(with: article, isBookmarked: isBookmarked)
            
            // Handle unbookmarking directly from here
            cell.onBookmarkTapped = { [weak self] in
                PersistenceManager.shared.toggleBookmark(for: article)
                self?.loadBookmarks() // reload list so removed ones disappear
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let article = bookmarks[indexPath.row]
            if let url = URL(string: article.url) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
        }


}
