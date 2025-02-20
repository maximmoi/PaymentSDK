//
//  PaymentRepositoryStub.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class PaymentRepositoryStub: PaymentRepository {

    var setupAPIArgument = ""
    func setupAPI(apiToken: String) {
        setupAPIArgument = apiToken
    }

    var makePaymentResult: Result<String, PSDKError> = .success("")
    var makePaymentArgument: MakePaymentUseCaseData?
    func makePayment(_ paymentData: MakePaymentUseCaseData) async throws -> String {
        makePaymentArgument = paymentData

        switch makePaymentResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }

}
