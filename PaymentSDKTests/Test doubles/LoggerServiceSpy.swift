//
//  LoggerServiceSpy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class LoggerServiceSpy: LoggerService {

    var logs = [String]()
    var metadata = [[String: String]]()

    override init(logLevel: PSDKLogLevel = .verbose) {
        super.init(logLevel: logLevel)
    }

    override func log(event: String, metadata: [String : String]? = nil) {
        logs.append(event)
        if let metadata {
            self.metadata.append(metadata)
        }
    }

}
