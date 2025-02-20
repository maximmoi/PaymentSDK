//
//  MakePaymentUseCase.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

public struct MakePaymentUseCaseData {
    let amount: Double
    let currency: String
    let recipient: String
}

protocol MakePaymentUseCase {

    func callAsFunction(_ paymentData: MakePaymentUseCaseData) async throws -> String

}
