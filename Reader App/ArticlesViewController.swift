//
//  ArticlesViewController.swift
//  Reader App
//
//  Created by Vedant Patle on 16/09/25.
//

import UIKit
import SafariServices

class ArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var articleTableView: UITableView!
    
    private var articles: [Article] = []
    private var filteredArticles: [Article] = []
    
    private var isSearchActive: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"

        setupTableView()
        fetchArticles()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search articles"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    
    private func setupTableView() {
        let nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        articleTableView.register(nib, forCellReuseIdentifier: "ArticleCell")
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        articleTableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        fetchArticles()
    }

    
    private func fetchArticles() {
        
        let cached = PersistenceManager.shared.fetchArticles()
        if !cached.isEmpty {
            self.articles = cached
            self.articleTableView.reloadData()
            print("Loaded from cache: \(cached.count) articles")
        }
        
        APIService.shared.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    print("Fetched articles count:", articles.count)
                    self?.articleTableView.reloadData()
                    
                    PersistenceManager.shared.saveArticles(articles)
                    
                case .failure(let error):
                    print("Error fetching articles:", error)
                }
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredArticles.count : articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as? ArticlesTableViewCell else {
            return UITableViewCell()
        }
        
        let article = isSearchActive ? filteredArticles[indexPath.row] : articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = isSearchActive ? filteredArticles[indexPath.row] : articles[indexPath.row]
        if let url = URL(string: article.url){
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }

}

extension ArticlesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        filterArticles(for: query)
    }
    
    private func filterArticles(for query: String) {
        if query.isEmpty {
            filteredArticles = []
        } else {
            filteredArticles = articles.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
        articleTableView.reloadData()
    }
}

