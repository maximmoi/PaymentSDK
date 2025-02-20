//
//  DefaultRemotePaymentService.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

import Foundation

final class DefaultRemotePaymentService: RemotePaymentService {

    private let dispatcher: Dispatcher<PaymentsTarget>
    private let logger: LoggerService

    init(dispatcher: Dispatcher<PaymentsTarget>, logger: LoggerService) {
        self.dispatcher = dispatcher
        self.logger = logger
    }

    func setupAPI(apiToken: String) {
        self.dispatcher.apiToken = apiToken
    }

    func makePayment(_ dto: MakePaymentRequestDTO) async throws(PSDKError) -> MakePaymentResponseDTO {
        let unsuccessfullPayment = "Payment was unsuccessful"
        do {
            let response: MakePaymentResponseDTO = try await self.dispatcher.execute(target: .makePayment(dto))
            logger.log(event: "Did parse response object", metadata: ["Object": String(describing: response)])

            if response.status == "success" {
                return response
            } else {
                throw PSDKError.paymentFailure(unsuccessfullPayment)
            }
        }
        catch let error as NetworkError {
            throw PSDKError.paymentFailure(error.error)
        }
        catch {
            throw PSDKError.paymentFailure(unsuccessfullPayment)
        }
    }
}


//let block = {
////            do {
//        let response: MakePaymentResponseDTO? = try? await self.dispatcher.execute(target: .makePayment(dto))
//        return response
////                if response.status == "success" {
////                    return response
////                } else {
////                    throw PSDKError.paymentFailure(nil)
////                }
////            }
////            catch {
////                throw PSDKError.paymentFailure((error as? NetworkError)?.error)
////            }
//}
//
//if let response = await block(), response.status == "success" {
//    return response
//} else if retryCounter < retryTimes {
//    return try await self.makePayment(dto)
//} else {
//    throw PSDKError.paymentFailure(nil)
//}
//}
