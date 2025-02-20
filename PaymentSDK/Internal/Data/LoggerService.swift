//
//  LoggerService.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

import OSLog

class LoggerService {

    private let category = "Payments"
    private lazy var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: category)
    private let logLevel: PSDKLogLevel

    init(logLevel: PSDKLogLevel) {
        self.logLevel = logLevel
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
        print(logMessage)
        logger.debug("\(logMessage)")
    }

}
