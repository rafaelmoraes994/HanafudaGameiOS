//
//  Settings.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/6/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class Settings: NSObject, NSCoding {
    
    struct Keys {
        static let hints = "Hints"
        static let doublePoints = "DoublePoints"
        static let hinami = "Hinami"
        static let tsukimi = "Tsukimi"
        static let rounds = "Rounds"
    }
    
    
    var hints: Bool = true
    var doublePoints: Bool = true
    var hinami: Bool = true
    var tsukimi: Bool = true
    var rounds: Int = 3
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("userSettings").path
    }
    
    
    override init (){
        super.init()
        let settings = getUserSettings()
        if settings != nil {
            hints = (settings?.hints)!
            doublePoints = (settings?.doublePoints)!
            hinami = (settings?.hinami)!
            tsukimi = (settings?.tsukimi)!
            rounds = (settings?.rounds)!
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hints, forKey: Keys.hints)
        aCoder.encode(doublePoints, forKey: Keys.doublePoints)
        aCoder.encode(hinami, forKey: Keys.hinami)
        aCoder.encode(tsukimi, forKey: Keys.tsukimi)
        aCoder.encode(rounds, forKey: Keys.rounds)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        hints = aDecoder.decodeBool(forKey: Keys.hints)
        
        doublePoints = aDecoder.decodeBool(forKey: Keys.doublePoints)
            
        hinami = aDecoder.decodeBool(forKey: Keys.hinami)
            
        tsukimi = aDecoder.decodeBool(forKey: Keys.tsukimi)
            
        rounds = aDecoder.decodeInteger(forKey: Keys.rounds)
        
    }
    
    func saveUserSettings(_ userSettings: Settings) {
        NSKeyedArchiver.archiveRootObject(userSettings, toFile: filePath)
    }
    
    func getUserSettings() -> Settings? {
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Settings {
            return userSettings
        }
        return nil
    }
    
    func update(hints: Bool, doublePoints: Bool, hinami: Bool, tsukimi: Bool, rounds: Int){
        self.hints = hints
        self.doublePoints = doublePoints
        self.hinami = hinami
        self.tsukimi = tsukimi
        self.rounds = rounds
        saveUserSettings(self)
    }
}
