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
        save(instanceName: dataAutosaveInstanceName)
    }
    private func autoload() {
        load(instanceName: dataAutosaveInstanceName)
    }
    private func save(instanceName:String) {
        userDefaults.setValue(parametersModel, forKey: dataKey(for: instanceName))
    }
    private func load(instanceName:String) {
        if let parametersModel = userDefaults.parametersModel(forKey: dataKey(for: instanceName)) {
            self.parametersModel = parametersModel
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let dataBaseKey = "UserParameters"
    private let dataAutosaveInstanceName = "autosave"
    private func dataKey(for instanceName:String) -> String { dataBaseKey + "_" + instanceName }
}

extension UserParameters {
    struct DefaultValues {
        static let backendApiUrl = URL(string: "http://localhost:7700/api/v1")!
    }
}

extension UserDefaults {
    func parametersModel(forKey key:String) -> ParametersModel? {
        return value(forKey: key) as? ParametersModel
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
