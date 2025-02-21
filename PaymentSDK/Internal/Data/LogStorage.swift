//
//  LogStorage.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 21/02/2025.
//

import OSLog

protocol LogStorage {

    func write(_ message: String)

}

extension Logger: LogStorage {

    func write(_ message: String) {
        debug("\(message)")
    }

}
