//
//  DispatcherSpy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class DispatcherSpy: Dispatcher<PaymentsTarget> {

    var argument: PaymentsTarget?
    var result: Result<Decodable, NetworkError> = .success(
        MakePaymentResponseDTO(status: "success", transactionId: "123")
    )
    override func execute<ResultObject: Decodable>(
        target: PaymentsTarget
    ) async throws(NetworkError) -> ResultObject {

        self.argument = target
        switch result {
        case .success(let success):
            return success as! ResultObject
        case .failure(let failure):
            throw failure
        }
    }

}
