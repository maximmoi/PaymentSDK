//
//  DefaultPaymentRepository.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

final class DefaultPaymentRepository: PaymentRepository {

    private let service: RemotePaymentService

    init(service: RemotePaymentService) {
        self.service = service
    }

    func setupAPI(apiToken: String) {
        service.setupAPI(apiToken: apiToken)
    }

    func makePayment(_ paymentData: MakePaymentUseCaseData) async throws -> String {
        let dto = MakePaymentRequestDTO(
            amount: paymentData.amount,
            currency: paymentData.currency,
            recipient: paymentData.recipient
        )
        return try await service.makePayment(dto).transactionId
    }
}
