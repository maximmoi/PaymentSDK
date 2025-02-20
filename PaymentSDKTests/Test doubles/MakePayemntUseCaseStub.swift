//
//  MakePayemntUseCaseStub.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class MakePayemntUseCaseStub: MakePaymentUseCase {

    var returnValue: Result<String, PSDKError> = .success("")
    var argument: MakePaymentUseCaseData?
    func callAsFunction(_ paymentData: MakePaymentUseCaseData) async throws -> String {
        self.argument = paymentData
        switch returnValue {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }

}
