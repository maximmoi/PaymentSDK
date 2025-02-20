//
//  NetworkError.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

enum NetworkError: Error {
    case apiTokenNotSet
    case invalidStatusCode(Int)
    case encodingFailed(EncodingError)
    case decodingFailed(DecodingError)
    case requestFailed(URLError)
    case otherError(Error)

   var error: String {
        switch self {
        case .apiTokenNotSet: return "API token is not set"
        case .invalidStatusCode(let code): return "Response has invalid status code: \(code)"
        case .encodingFailed(let error): return "Incoding failed: \(error.failureReason ?? error.localizedDescription)"
        case .decodingFailed(let error): return "Decoding failed: \(error.failureReason ?? error.localizedDescription)"
        case .requestFailed(let error): return "Request failed: \(String(describing: error.failingURL)) || \(error.localizedDescription)"
        case .otherError(let errror): return "Unknown error: \(errror.localizedDescription)"
        }
    }
}
