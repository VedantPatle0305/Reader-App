//
//  ArticlesTableViewCell.swift
//  Reader App
//
//  Created by Vedant Patle on 16/09/25.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
        
    var onBookmarkTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbNailImageView.contentMode = .scaleAspectFill
        thumbNailImageView.clipsToBounds = true
        
        bookmarkImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(bookmarkTapped))
        bookmarkImageView.addGestureRecognizer(tap)
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()

        thumbNailImageView.image = UIImage(systemName: "photo")
        titleLabel.text = nil
        authorLabel.text = nil
        bookmarkImageView.image = UIImage(systemName: "bookmark")
    }

        
    func configure(with article: Article, isBookmarked: Bool) {
        titleLabel.text = article.title
        authorLabel.text = article.author ?? "Unknown"
            
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            thumbNailImageView.image = UIImage(systemName: "photo")
        }
        
        bookmarkImageView.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")

    }
    
    @objc private func bookmarkTapped() {
        onBookmarkTapped?()
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.thumbNailImageView.image = image
                }
            }
        }.resume()
    }

        
}
