//
//  WordsViewModel.swift
//  OufMime iOS
//
//  Created by Antoine Purnelle on 07/03/2022.
//

import Foundation
import UIKit

typealias PlayedWord = (word: Word, found: Bool)

struct WordsViewModel {
  
  static let instance = WordsViewModel()
  
  private var repo: WordRepository!
  
  public private(set) var currentTeam = -1
  public private(set) var currentRound = 0
  private var currentRoundFinished = true
  private var words = [Word] ()
  private var teamWords: [[[Word]]] = [
    [[Word](), [Word](), [Word]()],
    [[Word](), [Word](), [Word]()],
  ]
  
  private var wordsToPlay = [Word]()
  private var wordsMissedInRound = [Word]()
  public private(set) var wordsPlayedInTurn: [PlayedWord] = []
  
  public private(set) var currentWord: Word? = nil
  
  public private(set) var timerTotalTime: Double = 40
  public var timerCurrentTime: Double = 40
  public private(set) var wordsCount = 40
  public var categories = Dictionary(uniqueKeysWithValues: Category.allCases.map { ($0.rawValue, true) })
  private var selectedCategories: [String] {
    mutating get {
      categories.filter { (_, isSelected) in
        isSelected
      }.map { (category, _) in
        category
      }
    }
  }
  
  init() {
    repo = WordRepositoryImpl()
    insertWords()
  }
}

// Getters/Setters Extension
extension WordsViewModel {
  
  var hasMoreWords: Bool {
    get { wordsToPlay.count > 0 }
  }
  
  var hasMoreRounds: Bool {
    get { currentRound < 2 }
  }
  
  func getScore(inRound round: Int, forTeam team: Int) -> Int {
    return currentRound < round ? -1 : teamWords[team][round].count
  }
  
  func getCurrentRoundScore(forTeam team: Int) -> Int {
    return getScore(inRound: currentRound, forTeam: team)
  }
  
  func getTotalScore(forTeam team: Int) -> Int {
    return teamWords[team].reduce(0) { count, words in
      count + words.count
    }
  }
  
  var wordsFoundInTurnCount: Int {
    get { wordsPlayedInTurn.filter { (_, found) in found }.count }
  }
  
  var wordsMissedInTurnCount: Int {
    get { wordsPlayedInTurn.filter { (_, found) in !found }.count }
  }
  
  mutating func editGamesSettings(withWordsCount wordsCount: Int, turnDuration seconds: Double) {
    self.wordsCount = wordsCount
    self.timerTotalTime = seconds
  }
  
  mutating func changeValueInPlayedWords(atRow index: Int) {
    wordsPlayedInTurn[index].found.toggle()
  }
  
  var shouldInvertColors: Bool {
    get { currentTeam == 0 }
  }
  
  var currentTeamName: String {
    get { currentTeam == 0 ? "team_blue"~ : "team_orange"~ }
  }
  
  func getColor(forteam team: Int) -> UIColor {
    switch (team) {
    case 0: return #colorLiteral(red: 0, green: 0, blue: 0.3882352941, alpha: 1)
    case 1: return #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 1)
    default: return UIColor.white
    }
  }
  
  func getTransparentColor(forteam team: Int) -> UIColor {
    switch (team) {
    case 0: return #colorLiteral(red: 0, green: 0, blue: 0.3882352941, alpha: 0.67)
    case 1: return #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.67)
    default: return UIColor.white
    }
  }
  
  var primaryColor: UIColor {
    get { getColor(forteam: currentTeam) }
  }
  
  var secondaryColor: UIColor {
    get { getColor(forteam: currentTeam == 0 ? 1 : 0) }
  }
  
  var primaryTransparentColor: UIColor {
    get { getTransparentColor(forteam: currentTeam) }
  }
  
  var secondaryTransparentColor: UIColor {
    get { getTransparentColor(forteam: currentTeam == 0 ? 1 : 0) }
  }
  
  var appIconName: String {
    get { shouldInvertColors ? "ic_launcher_inverted" : "ic_launcher" }
  }
  
}

// Game LifeCycle Extensions
extension WordsViewModel {
  
  mutating func initGame(onCompleted: @escaping (() -> Void)) {
    
    repo.fetchRandomWords(inCategories: selectedCategories, withCount: wordsCount, inLanguage: Locale.current.languageCode!) { words in
      self.words = words
      print("Selected Words: \(words)")
      
      currentRound = 0
      currentTeam = 0
      
      teamWords = [
        [[Word](), [Word](), [Word]()],
        [[Word](), [Word](), [Word]()],
      ]
      
      DispatchQueue.main.async {
        onCompleted()
      }
      
    } onError: { message in
      debugPrint(message)
    }
  }
  
  mutating func initRound() {
    currentRoundFinished = false
    wordsToPlay.removeAll()
    wordsToPlay.append(contentsOf: words.shuffled())
    wordsMissedInRound.removeAll()
    
    print("Starting round \(currentRound) - Words to Play (\(wordsToPlay.count)): \(wordsToPlay)")
  }
  
  mutating func initTurn() {
    wordsPlayedInTurn.removeAll()
    currentWord = wordsToPlay.first
    timerCurrentTime = timerTotalTime
  }
  
  mutating func playWord(wasFound: Bool, timerEnded: Bool = false) {
    if hasMoreWords {
      wordsPlayedInTurn.append((wordsToPlay.removeFirst(), wasFound))
      
      debugPrint("Played word \(wordsPlayedInTurn.last!)")
      
      if !timerEnded {
        currentWord = wordsToPlay.first
      }
    }
  }
  
  mutating func finishTurn() {
    let wordsFoundInTurn = wordsPlayedInTurn.filter { (word, found) in found }.map { (word, _) in word }
    teamWords[currentTeam][currentRound].append(contentsOf: wordsFoundInTurn)
    
    let wordsMissedInTurn = wordsPlayedInTurn.filter { (word, found) in !found }.map { (word, _) in word }
    wordsToPlay.append(contentsOf: wordsMissedInTurn)
    
    currentTeam = currentTeam == 0 ? 1 : 0
    
    debugPrint("Turn finished and saved")
  }
  
  mutating func finishRound() {
    currentRound += 1
    initRound()
  }
}

// DB Extensions
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
      
      insertLanguageWords(language: "en", words: words.en)
      insertLanguageWords(language: "fr", words: words.fr)
      
      wordsListVersion = words.version
      
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  func insertLanguageWords(language: String, words: TranslatedWords) {
    insert(words: words.actions, in: .actions, language: language)
    insert(words: words.activities, in: .activities, language: language)
    insert(words: words.anatomy, in: .anatomy, language: language)
    insert(words: words.animals, in: .animals, language: language)
    insert(words: words.celebrities, in: .celebrities, language: language)
    insert(words: words.clothes, in: .clothes, language: language)
    insert(words: words.events, in: .events, language: language)
    insert(words: words.fictional, in: .fictional, language: language)
    insert(words: words.food, in: .food, language: language)
    insert(words: words.geek, in: .geek, language: language)
    insert(words: words.locations, in: .locations, language: language)
    insert(words: words.jobs, in: .jobs, language: language)
    insert(words: words.mythology, in: .mythology, language: language)
    insert(words: words.nature, in: .nature, language: language)
    insert(words: words.objects, in: .objects, language: language)
    insert(words: words.vehicles, in: .vehicles, language: language)
  }
  
  func insert(words: [String], in category: Category, language: String) {
    
    let wordEntities = words.map { word in
      Word(word: word, category: category, language: language)
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
