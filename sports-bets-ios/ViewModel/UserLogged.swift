//
//  UserLogged.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 29/08/2024.
//

import Foundation

class UserLogged : ObservableObject {
    @Published private(set) var user : UserModel? {
        didSet {
            autosave()
        }
    }
    var token : String? { user?.token }
    var isSet : Bool { user != nil }
    
    init() {
        autoload()
    }
    
    private func autosave() {
        save(instance: dataAutosaveInstanceName)
    }
    private func autoload() {
        load(instance: dataAutosaveInstanceName)
    }
    func save(instance:String) {
        let key = dataKey(instance: instance)
        let contents = user?.contents()
        userDefaults.setValue(contents, forKey: key)
    }
    func load(instance:String) {
        let key = dataKey(instance: instance)
        if let loadedContents = userDefaults.userModelContents(forKey: key) {
            do {
                self.user = try UserModel(fromContents: loadedContents)
            } catch {
                print("\(Self.self): error while reading data from userDefaults \(key) : \(error.localizedDescription)")
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let dataBaseKey = "UserLogged"
    private let dataAutosaveInstanceName = "autosave"
    private func dataKey(instance:String) -> String { dataBaseKey + "_" + instance }
    
    func setUser(_ user: UserModel?) {
        self.user = user
    }
}


extension UserDefaults {
    func userModelContents(forKey key:String) -> UserModel.Contents? {
        return dictionary(forKey: key) as? UserModel.Contents
    }
}
