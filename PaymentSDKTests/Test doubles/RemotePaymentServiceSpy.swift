//
//  RemotePaymentServiceSpy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class RemotePaymentServiceSpy: RemotePaymentService {

    var setupAPIArgument = ""
    func setupAPI(apiToken: String) {
        setupAPIArgument = apiToken
    }

    var makePaymentArgument: MakePaymentRequestDTO?
    var makePaymentResult: Result<MakePaymentResponseDTO, PSDKError> =
        .success(MakePaymentResponseDTO(status: "success", transactionId: "123"))
    func makePayment(_ dto: MakePaymentRequestDTO) async throws -> MakePaymentResponseDTO {
        makePaymentArgument = dto

        switch makePaymentResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }

}
