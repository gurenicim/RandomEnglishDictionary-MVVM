//
//  LaunchViewModel.swift
//  iDictionary
//
//  Created by Guren Icim on 22.05.2024.
//

import Foundation

let LIST_KEY = "WORD_LIST"
let LAUNCH_KEY = "IS_LAUNCHED_BEFORE"

class LaunchViewModel: ObservableObject {
    
    static let shared = LaunchViewModel()
    
    private init(){}
    
    func readWordsFromTextFile(fileName: String) async throws -> [String] {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") else {
                throw NSError(domain: "com.yourapp.error", code: 1, userInfo: ["message": "Could not find file \(fileName)"])
            }
            
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let words = content.components(separatedBy: .newlines)
            return words
    }
    
    func setTheWordList(words: [String]) {
        UserDefaults.standard.set(words, forKey: LIST_KEY)
        print("Words stored in SharedDefaults with key: \(LIST_KEY)")
    }
    
    func setLaunchedBefore() {
        UserDefaults.standard.set(true, forKey: LAUNCH_KEY)
    }
    
    func isLaunchedBefore() -> Bool {
        UserDefaults.standard.bool(forKey: LAUNCH_KEY)
    }
}
