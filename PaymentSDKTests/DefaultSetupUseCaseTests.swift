//
//  DefaultSetupUseCaseTests.swift
//  PaymentSDKTests
//
//  Created by Maksims Moisja on 20/02/2025.
//

@testable import PaymentSDK
import Testing

struct DefaultSetupUseCaseTests {

    @Test("Verify repository calls", arguments: ["token"])
    func testRepositoryCall(apiToken: String)  {
        let repository = PaymentRepositoryStub()
        let sut = DefaultSetupUseCase(repository: repository)

        sut(apiToken: apiToken)

        #expect(repository.setupAPIArgument == "token")
    }

}
