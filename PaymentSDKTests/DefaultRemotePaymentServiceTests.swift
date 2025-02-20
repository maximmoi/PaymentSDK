//
//  DefaultRemotePaymentServiceTests.swift
//  PaymentSDKTests
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DefaultRemotePaymentServiceTests {

    private let requestDTO = MakePaymentRequestDTO(amount: 100, currency: "USD", recipient: "Batman")
    private let dispatcher = DispatcherSpy(logger: LoggerServiceSpy())

    @Test("Verify setupAPI method")
    func testSetupAPI() {
        makeSUT().setupAPI(apiToken: "token")

        #expect(dispatcher.apiToken == "token")
    }

    @Test("Verify service creates expected target type")
    func testMakePaymentTargetType() async throws {
        let _ = try await makeSUT().makePayment(requestDTO)

        switch dispatcher.argument {
        case .makePayment(let makePaymentRequestDTO):
            #expect(makePaymentRequestDTO.amount == requestDTO.amount)
            #expect(makePaymentRequestDTO.currency == requestDTO.currency)
            #expect(makePaymentRequestDTO.recipient == requestDTO.recipient)
        default:
            #expect(Bool(false), "This should not happen")
        }
    }

    @Test("Verify successful payment")
    func testSuccessfulMakePayment() async throws {
        let result = try await makeSUT().makePayment(requestDTO)

        #expect(result.status == "success")
        #expect(result.transactionId == "123")
    }

    @Test("Verify unsuccessful status throws error")
    func testUnsuccessfulMakePayment() async throws {
        let sut = makeSUT(result: .success(MakePaymentResponseDTO(status: "failure", transactionId: "")))

        await #expect(throws: PSDKError.paymentFailure("Payment was unsuccessful"), performing: {
            let _ = try await sut.makePayment(requestDTO)
        })
    }

    @Test("Verify throwing payment")
    func testThrowingMakePayment() async throws {
        let sut = makeSUT(result: .failure(.invalidStatusCode(-1)))

        await #expect(throws: PSDKError.self, performing: {
            let _ = try await sut.makePayment(requestDTO)
        })
    }

    @Test(
        "Verify error messages",
        arguments: [
            NetworkError.apiTokenNotSet,
            NetworkError.decodingFailed(.dataCorrupted(.init(codingPath: [], debugDescription: "error"))),
            NetworkError.encodingFailed(.invalidValue("", .init(codingPath: [], debugDescription: "error"))),
            NetworkError.invalidStatusCode(404),
            NetworkError.otherError(TestError.dummy),
            NetworkError.requestFailed(.init(.unknown))
        ]
    )
    func testErrorMessages(_ error: NetworkError) async throws {
        let sut = makeSUT(result: .failure(error))

        await #expect(throws: PSDKError.paymentFailure(error.error), performing: {
            let _ = try await sut.makePayment(requestDTO)
        })
    }

    private func makeSUT(result: Result<Decodable, NetworkError> = .success(
        MakePaymentResponseDTO(status: "success", transactionId: "123"))
    ) -> DefaultRemotePaymentService {

        dispatcher.result = result
        return DefaultRemotePaymentService(dispatcher: dispatcher, logger: LoggerServiceSpy())
    }
}

extension PSDKError: @retroactive Equatable {
    public static func == (lhs: PSDKError, rhs: PSDKError) -> Bool {
        switch (lhs, rhs) {
        case (.paymentFailure(let a), .paymentFailure(let b)): return a == b
        }
    }
    

}
