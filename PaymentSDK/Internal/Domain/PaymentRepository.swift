//
//  PaymentRepository.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

protocol PaymentRepository {

    func setupAPI(apiToken: String)
    func makePayment(_ paymentData: MakePaymentUseCaseData) async throws -> String

}
