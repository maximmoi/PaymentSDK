//
//  PaymentController.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

protocol PaymentController {

    func setup(apiToken: String)
    func makePayment(amount: Double, currency: String, recipient: String) async throws -> String
    
}
