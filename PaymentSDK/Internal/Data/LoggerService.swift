//
//  LoggerService.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

class LoggerService {

    private let category: String
    private let storage: LogStorage
    private let logLevel: PSDKLogLevel

    init(logLevel: PSDKLogLevel, storage: LogStorage, category: String = "Payments") {
        self.logLevel = logLevel
        self.storage = storage
        self.category = category
    }

    func log(event: String, metadata: [String: String]? = nil) {
        guard logLevel != .none else { return }

        var additionalData: String?
        if let metadata {
            additionalData = "metadata: \(String(describing: metadata))"
        }

        let log = [event, additionalData]
            .compactMap { $0 }
            .joined(separator: ", ")

        let logMessage = "[PaymentSDK - \(category)]: \(log)"
        storage.write(logMessage)
    }

}
