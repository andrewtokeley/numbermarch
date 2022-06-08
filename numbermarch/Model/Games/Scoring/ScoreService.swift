//
//  Score.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 6/06/22.
//

import Foundation

protocol ScoreServiceInterface {
    func getHighscore(gameName: String, completion: ((Int, Error?) -> Void)?)
    func saveHighscore(gameName: String, score: Int, completion: ((Error?) -> Void)?)
}

class ScoreService: ScoreServiceInterface {
    
    private func getKey(_ gameName: String) -> String {
        return "SCORE_\(gameName)"
    }
    
    func getHighscore(gameName: String, completion: ((Int, Error?) -> Void)?) {
        let defaults = UserDefaults.standard
        let score = defaults.integer(forKey: getKey(gameName))
        completion?(score, nil)
    }
    
    func saveHighscore(gameName: String, score: Int, completion: ((Error?) -> Void)?) {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: getKey(gameName))
        completion?(nil)
    }
    
}
