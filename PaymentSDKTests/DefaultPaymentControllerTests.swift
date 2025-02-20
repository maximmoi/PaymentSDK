//
//  DefaultPaymentControllerTests.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DefaultPaymentControllerTests {

    @Test("Verify that setup method calls use case", arguments: ["apiToken"])
    func testSetup(apiToken: String) {
        let setupApiUseCase = SetupUseCaseSpy()
        let sut = DefaultPaymentController(
            useCases: PaymentControllerUseCases(
                setupAPI: setupApiUseCase,
                makePayment: MakePayemntUseCaseStub()
            )
        )

        sut.setup(apiToken: apiToken)

        #expect(setupApiUseCase.argument == apiToken)
    }

    @Test("Verify that make payment method calls use case", arguments: [(100, "USD", "Batman")])
    func testMakePayment(amount: Double, currency: String, recipient: String) async {
        let makePaymentUseCase = MakePayemntUseCaseStub()
        let sut = DefaultPaymentController(
            useCases: PaymentControllerUseCases(
                setupAPI: SetupUseCaseSpy(),
                makePayment: makePaymentUseCase
            )
        )

        let _ = try? await sut.makePayment(amount: amount, currency: currency, recipient: recipient)

        #expect(makePaymentUseCase.argument?.amount == amount)
        #expect(makePaymentUseCase.argument?.currency == currency)
        #expect(makePaymentUseCase.argument?.recipient == recipient)
    }

    @Test("Verify that make payment can throw error")
    func testMakePaymentThrows() async {
        let makePaymentUseCase = MakePayemntUseCaseStub()
        makePaymentUseCase.returnValue = .failure(.paymentFailure(""))

        let sut = DefaultPaymentController(
            useCases: PaymentControllerUseCases(
                setupAPI: SetupUseCaseSpy(),
                makePayment: makePaymentUseCase
            )
        )

        await #expect(throws: PSDKError.self, performing: {
            try await sut.makePayment(amount: 0, currency: "", recipient: "")
        })
    }

}
