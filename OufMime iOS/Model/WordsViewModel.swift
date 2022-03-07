//
//  WordsViewModel.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 07/03/2022.
//

import Foundation
import UIKit

struct WordsViewModel {
    
    static let instance = WordsViewModel()

    private var repo: WordRepository!

    private var currentTeam = -1
    private var currentRound = 0
    private var currentRoundFinished = true
    private var words = [Word] ()
    private var teamWords: [[[Word]]] = [
        [
            [Word](), [Word](), [Word]()
        ],
        [
            [Word](), [Word](), [Word]()
        ],
    ]

    private var wordsToPlay = [Word]()
    private var wordsMissedInRound = [Word]()
    private var wordsPlayedInTurn: [(String, Bool)] = []

    private var currentWord: Word? = nil

    private var timerTotalTime = 40
    private var timerCurrentTime = 40
    private var wordsCount = 40
    private var selectedCategories = Category.allCases.map {
        ($0.rawValue, true)
    }

    init() {
        repo = WordRepositoryImpl()
        insertWords()
    }

}


extension WordsViewModel {
    
    private var wordsListVersion: Int {
        get {
            UserDefaults.standard.integer(forKey: "wordsListVersion")
        }
        set {
            let ud = UserDefaults.standard
            ud.set(newValue, forKey: "wordsListVersion")
            ud.synchronize()
        }
    }

    mutating func insertWords() {
        guard let path = Bundle.main.path(forResource: "words", ofType: "json") else { return }
        do {
            let jsonData = try String(contentsOfFile: path).data(using: .utf8)
            let words = try JSONDecoder().decode(Words.self, from: jsonData!)
            
            if wordsListVersion == words.version {
                return
            }
            
            insert(words: words.actions, in: .actions)
            insert(words: words.activities, in: .activities)
            insert(words: words.anatomy, in: .anatomy)
            insert(words: words.animals, in: .animals)
            insert(words: words.celebrities, in: .celebrities)
            insert(words: words.clothes, in: .clothes)
            insert(words: words.events, in: .events)
            insert(words: words.fictional, in: .fictional)
            insert(words: words.food, in: .food)
            insert(words: words.geek, in: .geek)
            insert(words: words.locations, in: .locations)
            insert(words: words.jobs, in: .jobs)
            insert(words: words.mythology, in: .mythology)
            insert(words: words.nature, in: .nature)
            insert(words: words.objects, in: .objects)
            insert(words: words.vehicles, in: .vehicles)
            
            wordsListVersion = words.version
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func insert(words: [String], in category: Category) {
        
        let wordEntities = words.map { word in
            Word(word: word, category: category)
        }
        
        repo.insert(words: wordEntities, onCompleted: {
            repo.fetchAllWords { words in
                print(words)
            } onError: { message in
                debugPrint(message)
            }

        }) { message in
            debugPrint(message)
        }
    }

}
