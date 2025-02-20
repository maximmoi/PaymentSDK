//
//  MakePaymentRequestDTO.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

struct MakePaymentRequestDTO: Encodable {

    let amount: Double
    let currency: String
    let recipient: String

}
