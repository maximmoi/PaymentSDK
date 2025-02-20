//
//  TargetType.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

protocol TargetType {

    var baseURL: URL { get }
    var path: String { get }
    var method: TargetMethod { get }
    var task: TargetTask { get }
    var headers: [String: String]? { get }
    
}
