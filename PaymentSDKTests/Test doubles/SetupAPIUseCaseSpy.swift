//
//  SetupAPIUseCaseSpy.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK

final class SetupUseCaseSpy: SetupUseCase {

    var argument = ""
    func callAsFunction(apiToken: String) {
        argument = apiToken
    }
    
}
