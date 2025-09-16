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
    @IBOutlet weak var authorLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbNailImageView.contentMode = .scaleAspectFill
        thumbNailImageView.clipsToBounds = true
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()

        thumbNailImageView.image = UIImage(systemName: "photo")
        titleLabel.text = nil
        authorLabel.text = nil
    }

        
    func configure(with article: Article) {
        titleLabel.text = article.title
        authorLabel.text = article.author ?? "Unknown"
            
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            thumbNailImageView.image = UIImage(systemName: "photo")
        }
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
