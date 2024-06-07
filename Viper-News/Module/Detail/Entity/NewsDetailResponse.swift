//
//  NewsDetailResponse.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation

//MARK - NewsDetailResponse
struct NewsDetailResponse: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Decodable {
    let source: ArticleSource
    let author, title, description, url, urlToImage, publishedAt, content: String?
    var isAddedReadingList: Bool = false
    
    enum CodingKeys: CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
        case readingListStatus
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.source = try container.decode(ArticleSource.self, forKey: .source)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.isAddedReadingList = false
    }
}

//MARK - ArticleSource
struct ArticleSource: Decodable {
    let id: String?
    let name: String?
}
