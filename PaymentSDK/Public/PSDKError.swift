//
//  PSDKError.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

/// Errors PaymentSDK can report
public enum PSDKError: Error {

    /// Error is reported, when there is issue with making payment using PaymentSDK
    /// Associted value contains description of the error
    case paymentFailure(String)
}
