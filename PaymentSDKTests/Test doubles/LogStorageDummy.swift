//
//  LogStorageDummy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 21/02/2025.
//

@testable import PaymentSDK

final class LogStorageDummy: LogStorage {

    func write(_ message: String) {}

}
