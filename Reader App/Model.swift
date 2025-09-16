//
//  Model.swift
//  Reader App
//
//  Created by Vedant Patle on 15/09/25.
//


struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
}
