//
//  RemotePaymentService.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

protocol RemotePaymentService {

    func setupAPI(apiToken: String)
    func makePayment(_ dto: MakePaymentRequestDTO) async throws -> MakePaymentResponseDTO

}


