//
//  NetworkServiceStub.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

/// Use this class to simulate (mock) network responses.
public final class NetworkServiceStub: NetworkService {

    private static let dummyURL = URL(string: "https://dummy.com")!

    /// Response for successul payment.
    public static let paymentSuccess = (
        try! JSONSerialization.data(withJSONObject: ["status": "success", "transactionId": "123"]),
        HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )

    /// Response with no status code.
    public static let paymentFailureNoStatusCode = (Data(), URLResponse())

    /// Response with invalid - request failed - status code.
    public static let paymentFailureInvalidStatusCode = (
        Data(),
        HTTPURLResponse(url: dummyURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
    )

    /// Result of network request. Use this property to assign desired result of network request.
    public var result: Result<(Data, URLResponse), Error> = .success(NetworkServiceStub.paymentSuccess)

    public init() {}

    var argument: URLRequest?
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        argument = request
        
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }

}
