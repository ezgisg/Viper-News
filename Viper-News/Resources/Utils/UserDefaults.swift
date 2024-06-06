//
//  UserDefaults.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

class savedNews {
    private let userDefaults = UserDefaults.standard
    private let savedNewsKey = "savedNews"
    
    func getNewsToSavedList(completion: (_ list: [String]) -> ())  {
        let list = userDefaults.stringArray(forKey: savedNewsKey) ?? []
        completion(list)
    }
    
    func addNewsToSaveList(_ newsUrlString: String) {
            getNewsToSavedList { list in
                var updatedList = list
                if !updatedList.contains(newsUrlString) {
                    updatedList.append(newsUrlString)
                    userDefaults.set(updatedList, forKey: savedNewsKey)
                }
            }
        }
        
        func removeNewsFromSavedList(_ newsUrlString: String) {
            getNewsToSavedList { list in
                var updatedList = list
                if let index = updatedList.firstIndex(of: newsUrlString) {
                    updatedList.remove(at: index)
                    userDefaults.set(updatedList, forKey: savedNewsKey)
                }
            }
        }
}
