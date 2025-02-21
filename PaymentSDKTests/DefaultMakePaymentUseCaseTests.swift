//
//  DefaultMakePaymentUseCaseTests.swift
//  PaymentSDKTests
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DefaultMakePaymentUseCaseTests {

    private let paymentData = MakePaymentUseCaseData(amount: 100, currency: "USD", recipient: "Batman")
    private let repository = PaymentRepositoryStub()

    @Test("Verify use case passes arguments to repository")
    func testUseCase() async throws {
        let _ = try await makeSUT()(paymentData)

        #expect(repository.makePaymentArgument?.amount == paymentData.amount)
        #expect(repository.makePaymentArgument?.currency == paymentData.currency)
        #expect(repository.makePaymentArgument?.recipient == paymentData.recipient)
    }

    @Test("Verify successful use case")
    func testSuccessfulUseCase() async throws {
        let sut = makeSUT(result: .success("123"))

        let result = try await sut(paymentData)

        #expect(result == "123")
    }

    @Test("Verify throwing use case")
    func testThrowingUseCase() async throws {
        let sut = makeSUT(result: .failure(.paymentFailure("Error")))

        await #expect(throws: PSDKError.self, performing: {
            try await sut(paymentData)
        })
    }

    @Test("Verify throwing invalid amount use case")
    func testInvalidAmountUseCase() async throws {
        let sut = makeSUT()

        await #expect(throws: PSDKError.paymentFailure("Amount must be bigger than 0"), performing: {
            try await sut(MakePaymentUseCaseData(amount: -1, currency: "USD", recipient: "Batman"))
        })
    }

    @Test("Verify throwing invalid currency use case", arguments: ["US", "USDD"])
    func testInvalidCurrencyUseCase(currency: String) async throws {
        let sut = makeSUT()

        await #expect(throws: PSDKError.paymentFailure("Currency must be 3 chars long"), performing: {
            try await sut(MakePaymentUseCaseData(amount: 1, currency: currency, recipient: "Batman"))
        })
    }

    @Test("Verify throwing invalid recipient use case", arguments: ["", "123456789123456789"])
    func testInvalidRecipientUseCase(recipient: String) async throws {
        let sut = makeSUT()

        await #expect(throws: PSDKError.paymentFailure("Recipient must be between 0 and 17 chars"), performing: {
            try await sut(MakePaymentUseCaseData(amount: 1, currency: "USD", recipient: recipient))
        })
    }

    private func makeSUT(result: Result<String, PSDKError> = .success("")) -> DefaultMakePaymentUseCase {
        repository.makePaymentResult = result
        return DefaultMakePaymentUseCase(repository: repository)
    }

}
