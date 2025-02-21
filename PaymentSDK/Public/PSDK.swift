//
//  PSDK.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

import OSLog

public final class PSDK {

    private static let shared = PSDK()

    private var controller: PaymentController?

    public static func setup(apiToken: String, logLevel: PSDKLogLevel, useMocks: Bool) {
        shared.controller = DefaultPaymentController(useCases: makeUseCases(logLevel: logLevel, useMocks: useMocks))
        shared.controller?.setup(apiToken: apiToken)
    }

    public static func makePayment(amount: Double, currency: String, recipient: String) async throws -> String {
        guard let controller = shared.controller
        else { throw PSDKError.paymentFailure(NetworkError.apiTokenNotSet.error) }

        return try await controller.makePayment(amount: amount, currency: currency, recipient: recipient)
    }

    private static func makeUseCases(logLevel: PSDKLogLevel, useMocks: Bool) -> PaymentControllerUseCases {
        let logger = LoggerService(
            logLevel: logLevel,
            storage: Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Payments")
        )
        let dispatcher: Dispatcher<PaymentsTarget> = Dispatcher(
            logger: logger,
            provider: useMocks ? NetworkServiceStub() : URLSession.shared)
        let paymentService = DefaultRemotePaymentService(dispatcher: dispatcher, logger: logger)
        let repository = DefaultPaymentRepository(service: paymentService)
        let setupApiUseCase = DefaultSetupUseCase(repository: repository)
        let makePaymentUseCase = DefaultMakePaymentUseCase(repository: repository)

        return PaymentControllerUseCases(setupAPI: setupApiUseCase, makePayment: makePaymentUseCase)
    }
    
}
