//
//  NetworkServiceStub.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

final class NetworkServiceStub: NetworkService {

    private static let dummyURL = URL(string: "https://dummy.com")!

    static let paymentSuccess = (
        try! JSONSerialization.data(withJSONObject: ["status": "success", "transactionId": "123"]),
        HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )
    static let paymentFailureNoStatusCode = (Data(), URLResponse())
    static let paymentFailureInvalidStatusCode = (
        Data(),
        HTTPURLResponse(url: dummyURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
    )

    var result: Result<(Data, URLResponse), Error> = .success(NetworkServiceStub.paymentSuccess)

    var argument: URLRequest?
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        argument = request
        
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }

}
