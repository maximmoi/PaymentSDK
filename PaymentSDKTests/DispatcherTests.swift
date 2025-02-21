//
//  DispatcherTests.swift
//  PaymentSDKTests
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DispatcherTests {

    private let requestDTO = MakePaymentRequestDTO(amount: 100, currency: "USD", recipient: "Batman")
    private let provider = NetworkServiceStub()
    private let logger = LoggerServiceSpy()
    private let paymentTarget: PaymentsTarget

    init() {
        paymentTarget = .makePayment(MakePaymentRequestDTO(amount: 100, currency: "USD", recipient: "Batman"))
    }

    @Test("Verify URL request")
    func testURLRequest() async throws {
        let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)

        #expect(provider.argument?.httpMethod == paymentTarget.method.rawValue)
        #expect(provider.argument?.url?.absoluteString ==
                "\(paymentTarget.baseURL.absoluteString)/\(paymentTarget.path)")

        let header = ["Authorization": "Bearer token", "Content-Type": "application/json"]
        #expect(provider.argument?.allHTTPHeaderFields == header)

        let httpBodyJSON = try? JSONSerialization.jsonObject(with: provider.argument?.httpBody ?? Data()) as? [String : Any]
        #expect(httpBodyJSON?["amount"] as? Double == requestDTO.amount)
        #expect(httpBodyJSON?["currency"] as? String == requestDTO.currency)
        #expect(httpBodyJSON?["recipient"] as? String == requestDTO.recipient)
    }

    @Test("Verify successful execute")
    func testSuccessfulExecute() async throws {
        let result: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)

        #expect(result.status == "success")
        #expect(result.transactionId == "123")
    }

    @Test("Verify throwing apiTokenNotSet")
    func testThrowingApiTokenNotSet() async throws {
        await #expect(throws: NetworkError.apiTokenNotSet) {
            let _: MakePaymentResponseDTO = try await makeSUT(apiToken: nil).execute(target: paymentTarget)
        }
    }

    @Test("Verify throwing invalidStatusCode=-1")
    func testThrowingInvalidStatusCodeMinus1() async throws {
        provider.result = .success(NetworkServiceStub.paymentFailureNoStatusCode)

        await #expect(throws: NetworkError.invalidStatusCode(-1), performing: {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        })
    }

    @Test("Verify throwing invalidStatusCode")
    func testThrowingInvalidStatusCode() async throws {
        provider.result = .success(NetworkServiceStub.paymentFailureInvalidStatusCode)

        await #expect(throws: NetworkError.invalidStatusCode(404), performing: {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        })
    }

    @Test("Verify throwing decodingFailed")
    func testThrowingDecodingFailed() async throws {
        let error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
        provider.result = .failure(error)

        await #expect(throws: NetworkError.decodingFailed(error)) {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        }
    }

    @Test("Verify throwing encodingError")
    func testThrowingEncodingError() async throws {
        let error = EncodingError.invalidValue("", .init(codingPath: [], debugDescription: ""))
        provider.result = .failure(error)

        await #expect(throws: NetworkError.encodingFailed(error)) {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        }
    }

    @Test("Verify throwing requestFailed")
    func testThrowingRequestFailed() async throws {
        let error = URLError(.badURL)
        provider.result = .failure(error)

        await #expect(throws: NetworkError.requestFailed(error)) {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        }
    }

    @Test("Verify throwing otherError")
    func testThrowingOtherError() async throws {
        let error = TestError.dummy
        provider.result = .failure(error)

        await #expect(throws: NetworkError.otherError(error)) {
            let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)
        }
    }

    @Test("Verify did start network request is logged")
    func testStartRequestLog() async throws {
        let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)

        #expect(logger.logs.contains("Did send network request"))
        #expect(logger.metadata["url"] == paymentTarget.baseURL.appending(path: paymentTarget.path).absoluteString)
        #expect(logger.metadata["method"] == paymentTarget.method.rawValue)

        let requestData = try! JSONEncoder().encode(requestDTO)
        #expect(logger.metadata["body"] == String(describing: try? JSONSerialization.jsonObject(with: requestData)))
    }

    @Test("Verify did end network request is logged")
    func testEndRequestLog() async throws {
        let _: MakePaymentResponseDTO = try await makeSUT().execute(target: paymentTarget)

        #expect(logger.logs.contains("Did receive network response"))
        #expect(logger.metadata["response"] == String(describing: NetworkServiceStub.paymentSuccess.1))
    }

    private func makeSUT(apiToken: String? = "token") -> Dispatcher<PaymentsTarget> {
        let dispatcher = Dispatcher<PaymentsTarget>(logger: logger, provider: provider)
        dispatcher.apiToken = apiToken
        return dispatcher
    }
}

extension NetworkError: @retroactive Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.apiTokenNotSet, .apiTokenNotSet): return true
        case (.invalidStatusCode(let a), .invalidStatusCode(let b)): return a == b
        case (.encodingFailed(let a), .encodingFailed(let b)): return a.failureReason == b.failureReason
        case (.decodingFailed(let a), .decodingFailed(let b)): return a.failureReason == b.failureReason
        case (.requestFailed(let a), .requestFailed(let b)): return a.code == b.code
        case (.otherError(let a), .otherError(let b)): return a.localizedDescription == b.localizedDescription
        default: return false
        }
    }
}
