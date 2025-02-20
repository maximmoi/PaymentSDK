//
//  PaymentsTarget.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

enum PaymentsTarget: TargetType {
    private static let urlString = "https://dummy.com"

    case makePayment(MakePaymentRequestDTO)

    var baseURL: URL { URL(string: Self.urlString)! }

    var path: String { "payment" }

    var method: TargetMethod { .post }

    var task: TargetTask {
        switch self {
        case .makePayment(let dto): return .requestJSONEncodable(dto)
        }
    }

    var headers: [String : String]? { nil }
}
