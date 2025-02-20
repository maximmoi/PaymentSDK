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
    func testFailingUseCase() async throws {
        let sut = makeSUT(result: .failure(.paymentFailure("Error")))

        await #expect(throws: PSDKError.self, performing: {
            try await sut(paymentData)
        })
    }

    private func makeSUT(result: Result<String, PSDKError> = .success("")) -> DefaultMakePaymentUseCase {
        repository.makePaymentResult = result
        return DefaultMakePaymentUseCase(repository: repository)
    }

}
