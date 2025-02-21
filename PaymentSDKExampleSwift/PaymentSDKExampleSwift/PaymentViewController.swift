//
//  PaymentViewController.swift
//  PaymentSDKExampleSwift
//
//  Created by Maksims Moisja on 21/02/2025.
//

import PaymentSDK
import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet private var textFieldAmount: UITextField!
    @IBOutlet private var textFieldCurrency: UITextField!
    @IBOutlet private var textFieldRecipient: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction private func didTapPay(_ sender: UIButton) {
        view.endEditing(true)

        guard let amount = Double(textFieldAmount.text ?? "") else {
            showAlert("Amount is invalid")
            return
        }

        Task {
            do {
                let transactionID = try await PSDK.makePayment(
                    amount: amount,
                    currency: textFieldCurrency.text ?? "",
                    recipient: textFieldRecipient.text ?? ""
                )
                showAlert(transactionID, title: "Success")
            }
            catch let error as PSDKError {
                guard case .paymentFailure(let string) = error else { return }

                showAlert(string)
            }
        }
    }

    @IBAction private func didRecognizeTap(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - private

    private func showAlert(_ message: String, title: String = "Error") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.present(alertVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension PaymentViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}
