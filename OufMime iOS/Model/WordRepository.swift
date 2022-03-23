//
//  WordRepository.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 04/03/2022.
//

import CoreData
import Foundation

typealias OnCompleted = () -> Void
typealias OnCompletedWord = (_ word: Word) -> Void
typealias OnCompletedWords = (_ words: [Word]) -> Void
typealias OnError = (_ message: String) -> Void

protocol WordRepository {
    func fetch(word: String, onCompleted: OnCompletedWord, onError: OnError)
    func fetchAllWords(onCompleted: OnCompletedWords, onError: OnError)
    func fetchRandomWords(inCategories categories: [String], withCount count: Int, onCompleted: OnCompletedWords, onError: OnError)

    func insert(word: Word, onCompleted: OnCompleted, onError: OnError)
    func insert(words: [Word], onCompleted: OnCompleted, onError: OnError)
}

struct WordRepositoryImpl: WordRepository {

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "OufMime_iOS")

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Cannot load Core Data: \(String(describing: error.localizedDescription))")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func fetch(word: String, onCompleted: OnCompletedWord, onError: OnError) {
        let request = WordEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "word = %@", word)

        do {
            onCompleted(getWord(fromEntity: try container.viewContext.fetch(request)[0]))
        } catch {
            onError(error.localizedDescription)
        }
    }

    func fetchAllWords(onCompleted: OnCompletedWords, onError: OnError) {
        let request = WordEntity.fetchRequest()

        do {
            onCompleted(try container.viewContext.fetch(request).map({ wordEntity in
                getWord(fromEntity: wordEntity)
            }))
        } catch {
            onError(error.localizedDescription)
        }
    }

    func fetchRandomWords(inCategories categories: [String], withCount count: Int, onCompleted: OnCompletedWords, onError: OnError) {

        let request = WordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category in %@", categories)

        do {
            var wordEntities = try container.viewContext.fetch(request)
            wordEntities.shuffle()

            let words = wordEntities.count > 0 ? wordEntities[0..<min(count, wordEntities.count)].map({ wordEntity in
                getWord(fromEntity: wordEntity)
            }) : []

            onCompleted(words)
        } catch {
            onError(error.localizedDescription)
        }
    }

    func insert(word: Word, onCompleted: OnCompleted, onError: OnError) {
        insert(words: [word], onCompleted: onCompleted, onError: onError)
    }

    func insert(words: [Word], onCompleted: OnCompleted, onError: OnError) {
        for word in words {
            createWordEntity(fromWord: word)
        }

        do {
            try container.viewContext.save()
            onCompleted()
        } catch {
            onError(error.localizedDescription)
        }
    }

    func getWord(fromEntity entity: WordEntity) -> Word {
        return Word(word: entity.word!, category: Category(rawValue: entity.category!)!)
    }

    func createWordEntity(fromWord word: Word) {
        let wordEntity = WordEntity(context: container.viewContext)
        wordEntity.word = word.word
        wordEntity.category = word.category.rawValue
    }
}
