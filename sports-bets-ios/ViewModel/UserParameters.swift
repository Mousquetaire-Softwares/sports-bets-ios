//
//  UserParameters.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 03/09/2024.
//

import Foundation

class UserParameters : ObservableObject {
    @Published var parametersModel : ParametersModel {
        didSet {
            if oldValue.backendApiUrl != parametersModel.backendApiUrl {
                BackendApi.baseUrl = parametersModel.backendApiUrl
            }
            autosave()
        }
    }
    
    init(parametersModel: ParametersModel) {
        self.parametersModel = parametersModel
    }
    init() {
        self.parametersModel = Self.initParametersModel()
        autoload()
    }
    
    private static func initParametersModel() -> ParametersModel {
        ParametersModel(backendApiUrl: BackendApi.baseUrl)
    }
    
    private func autosave() {
        save(instance: dataAutosaveInstanceName)
    }
    private func autoload() {
        load(instance: dataAutosaveInstanceName)
    }
    func save(instance:String) {
        do {
            let data = try parametersModel.json()
            try data.write(to: dataURL(instanceName: instance))
        } catch let error {
            print("\(Self.self): error while saving \(error.localizedDescription)")
        }
    }
    func load(instance:String) {
        let url = dataURL(instanceName: instance)
        if let data = try? Data(contentsOf: url) {
            do {
                self.parametersModel = try ParametersModel(from: data)
            } catch {
                print("\(Self.self): error while reading data from \(url) : \(error.localizedDescription)")
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let dataBaseKey = "UserParameters"
    private let dataAutosaveInstanceName = "autosave"
    private func dataURL(instanceName:String) -> URL { URL.documentsDirectory.appendingPathComponent(dataBaseKey + "_" + instanceName) }
}

extension UserParameters {
    struct DefaultValues {
        static let backendApiUrl = URL(string: "http://localhost:7700/api/v1")!
    }
}



extension String {
    var isValidURL: Bool {
        if let url = URL(string: self), url.scheme == "http" || url.scheme == "https" {
            return true
        } else {
            return false
        }
    }
}
