//
//  DefaultPaymentController.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

struct PaymentControllerUseCases {

    let setupAPI: SetupUseCase
    let makePayment: MakePaymentUseCase
    
}

final class DefaultPaymentController: PaymentController {

    private let useCases: PaymentControllerUseCases

    init(useCases: PaymentControllerUseCases) {
        self.useCases = useCases
    }

    func setup(apiToken: String) {
        useCases.setupAPI(apiToken: apiToken)
    }

    func makePayment(amount: Double, currency: String, recipient: String) async throws -> String {
        let paymentData = MakePaymentUseCaseData(
            amount: amount,
            currency: currency,
            recipient: recipient
        )
        return try await useCases.makePayment(paymentData)
    }

}
