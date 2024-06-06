//
//  NewsSourcesResponse.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation

//MARK: - NewsSourcesResponse
struct NewsSourcesResponse: Decodable {
    let status: String?
    let sources: [Source]?
}

//MARK: - Source

struct Source: Decodable {
    let id, name, description, url, language, country, category: String?
}

