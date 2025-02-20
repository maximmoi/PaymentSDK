//
//  DefaultSetupUseCase.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

public final class DefaultSetupUseCase: SetupUseCase {

    private let repository: PaymentRepository

    init(repository: PaymentRepository) {
        self.repository = repository
    }

    func callAsFunction(apiToken: String) {
        repository.setupAPI(apiToken: apiToken)
    }

}
