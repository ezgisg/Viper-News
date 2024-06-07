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
    
//    func getNewsToSavedList(completion: (_ list: [String]) -> ())  {
//        let list = userDefaults.stringArray(forKey: savedNewsKey) ?? []
//        completion(list)
//    }
//    
//    func addNewsToSaveList(_ newsUrlString: String) {
//        getNewsToSavedList { list in
//            var updatedList = list
//            if !updatedList.contains(newsUrlString) {
//                updatedList.append(newsUrlString)
//                userDefaults.set(updatedList, forKey: savedNewsKey)
//            }
//        }
//    }
//    
//    func removeNewsFromSavedList(_ newsUrlString: String) {
//        getNewsToSavedList { list in
//            var updatedList = list
//            if let index = updatedList.firstIndex(of: newsUrlString) {
//                updatedList.remove(at: index)
//                userDefaults.set(updatedList, forKey: savedNewsKey)
//            }
//        }
//    }
    
    func getNewsToSavedList(completion: (_ list: [ReadingListNews]) -> ())  {
        let list = userDefaults.read([ReadingListNews].self, with: savedNewsKey) ?? []
        completion(list)
    }
    
    func addNewsToSaveList(_ news: ReadingListNews) {
        getNewsToSavedList { list in
            var updatedList = list
            updatedList.append(news)
            userDefaults.save(item: updatedList, forKey: savedNewsKey)
        }
    }
    
    func removeNewsFromSavedList(_ news: ReadingListNews) {
        getNewsToSavedList { list in
            guard let index = list.firstIndex(where: { $0 == news }) else { return }
            var updatedList = list
            updatedList.remove(at: index)
            userDefaults.save(item: updatedList, forKey: savedNewsKey)
        }
    }
}
