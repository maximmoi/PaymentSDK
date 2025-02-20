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
        try await repository.makePayment(paymentData)
    }

}
