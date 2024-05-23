//
//  DictionaryViewModel.swift
//  iDictionary
//
//  Created by Guren Icim on 3.01.2024.
//

import Foundation

class WordViewModel: ObservableObject {
    private let lvm: LaunchViewModel = LaunchViewModel.shared
    let oldKey = "OLD_KEY"
    let newKey = "NEW_KEY"
    @Published var tWord: String = ""
    @Published var defArray: [Definition] = []
    
    static let shared = WordViewModel()
    
    private init() {
    }
    
    func isStackPresented() -> Bool {
        return !self.defArray.isEmpty
    }
    
    
    @MainActor func callWordService() {
        
        self.tWord = getRandomWord(list: getWordList())
        let apiUrlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(tWord)"
        let apiUrl = URL(string: apiUrlString)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String:Any]] else {
                    return
                }
                guard let dict = json.first else { return }
                let meanings = dict["meanings"] as! Array<[String:Any]>
                for meaning in meanings {
                    let definitions = meaning["definitions"] as! Array<[String:Any]>
                    for definition in definitions {
                        let examp = definition["example"] as? String ?? ""
                        let def: Definition = Definition(definition: definition["definition"] as! String, example: examp)
                        self.defArray.append(def)
                        if self.defArray.count > 3 {break}
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        return
    }
    func getRandomWord(list: [String]) -> String {
        if let randomElement = list.randomElement() {
            return randomElement
        }
        return ""
    }
    
    func getWordList () -> [String] {
        return UserDefaults().stringArray(forKey: LIST_KEY) ?? []
    }
    
    func persistList(list: [String], key: String){
        UserDefaults().set(list, forKey: key)
    }
    
    func getSharedList(key: String) -> [String] {
        return UserDefaults().stringArray(forKey: key) ?? []
    }
    
    func addToOldWords(word: String) {
        var oldList = getSharedList(key: oldKey)
        oldList.append(word)
        persistList(list: oldList, key: oldKey)
    }
    
    func removeFromNewWords(word: String) {
        var newWords = getSharedList(key: newKey)
        newWords.removeFirst()
        persistList(list: newWords, key: newKey)
    }
    
    func jsonToList() -> [String] {
        var text:String = ""
        if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                text = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                // handle error
                print(error)
            }
        }
        return text.components(separatedBy: .newlines).shuffled()
    }
}


