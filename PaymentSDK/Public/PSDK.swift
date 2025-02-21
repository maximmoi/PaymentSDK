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

    public static func setup(apiToken: String, logLevel: PSDKLogLevel, networkResult: Result<(Data, URLResponse), Error>? = nil) {
        shared.controller = DefaultPaymentController(useCases: makeUseCases(logLevel: logLevel, networkResult: networkResult))
        shared.controller?.setup(apiToken: apiToken)
    }

    public static func makePayment(amount: Double, currency: String, recipient: String) async throws -> String {
        guard let controller = shared.controller
        else { throw PSDKError.paymentFailure(NetworkError.apiTokenNotSet.error) }

        return try await controller.makePayment(amount: amount, currency: currency, recipient: recipient)
    }

    private static func makeUseCases(logLevel: PSDKLogLevel, networkResult: Result<(Data, URLResponse), Error>?) -> PaymentControllerUseCases {
        let logger = LoggerService(
            logLevel: logLevel,
            storage: Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Payments")
        )

        let provider: NetworkService
        if let networkResult {
            let stub = NetworkServiceStub()
            stub.result = networkResult
            provider = stub
        } else {
            provider = URLSession.shared
        }

        let dispatcher: Dispatcher<PaymentsTarget> = Dispatcher(logger: logger, provider: provider)
        let paymentService = DefaultRemotePaymentService(dispatcher: dispatcher, logger: logger)
        let repository = DefaultPaymentRepository(service: paymentService)
        let setupApiUseCase = DefaultSetupUseCase(repository: repository)
        let makePaymentUseCase = DefaultMakePaymentUseCase(repository: repository)

        return PaymentControllerUseCases(setupAPI: setupApiUseCase, makePayment: makePaymentUseCase)
    }

}
