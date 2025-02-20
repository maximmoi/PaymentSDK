//
//  NetworkService.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

protocol NetworkService {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkService {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
