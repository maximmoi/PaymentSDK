//
//  LoggerServiceSpy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class LoggerServiceSpy: LoggerService {

    var logs = [String]()
    var metadata = [String: String]()

    init() {
        super.init(logLevel: .verbose, storage: LogStorageDummy())
    }

    override func log(event: String, metadata: [String : String]? = nil) {
        logs.append(event)
        self.metadata.merge(metadata ?? [:], uniquingKeysWith: { $1 })

        super.log(event: event, metadata: metadata)
    }

}
