//
//  DefaultMakePaymentUseCase.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

public final class DefaultMakePaymentUseCase: MakePaymentUseCase {

    private let repository: PaymentRepository

    init(repository: PaymentRepository) {
        self.repository = repository
    }

    func callAsFunction(_ paymentData: MakePaymentUseCaseData) async throws -> String {
        guard paymentData.amount > 0 else { throw PSDKError.paymentFailure("Amount must be bigger than 0") }
        guard paymentData.currency.count == 3 else { throw PSDKError.paymentFailure("Currency must be 3 chars long") }
        guard (paymentData.recipient.count > 0 && paymentData.recipient.count < 17) else {
            throw PSDKError.paymentFailure("Recipient must be between 0 and 17 chars")
        }

        return try await repository.makePayment(paymentData)
    }

}
