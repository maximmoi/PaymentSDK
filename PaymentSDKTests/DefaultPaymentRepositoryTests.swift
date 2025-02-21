//
//  DefaultPaymentRepositoryTests.swift
//  PaymentSDKTests
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DefaultPaymentRepositoryTests {

    private let paymentData = MakePaymentUseCaseData(amount: 100, currency: "USD", recipient: "Batman")
    private let service = RemotePaymentServiceSpy()

    @Test("Verify setupAPI method")
    func testSetupAPI() {
        let service = RemotePaymentServiceSpy()
        let sut = DefaultPaymentRepository(service: service)

        sut.setupAPI(apiToken: "token")

        #expect(service.setupAPIArgument == "token")
    }

    @Test("Verify repository passes arguments to service")
    func testMakePayment() async throws {
        let sut = makeSUT()

        let _ = try await sut.makePayment(paymentData)

        #expect(service.makePaymentArgument?.amount == paymentData.amount)
        #expect(service.makePaymentArgument?.currency == paymentData.currency)
        #expect(service.makePaymentArgument?.recipient == paymentData.recipient)
    }

    @Test("Verify successful payment")
    func testSuccessfulMakePayment() async throws {
        let sut = makeSUT()

        let result = try await sut.makePayment(paymentData)

        #expect(result == "123")
    }

    @Test("Verify throwing payment")
    func testThrowingMakePayment() async throws {
        let sut = makeSUT(result: .failure(.paymentFailure("Error")))

        await #expect(throws: PSDKError.self, performing: {
            let _ = try await sut.makePayment(paymentData)
        })
    }

    private func makeSUT(result: Result<MakePaymentResponseDTO, PSDKError> = .success(
        MakePaymentResponseDTO(status: "success", transactionId: "123"))
    ) -> DefaultPaymentRepository {

        service.makePaymentResult = result
        return DefaultPaymentRepository(service: service)
    }
}
