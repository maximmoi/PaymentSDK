//
//  ViewController.swift
//  PaymentSDKExampleSwift
//
//  Created by Maksims Moisja on 21/02/2025.
//

import PaymentSDK
import UIKit

class ViewController: UIViewController {

    private let results = [
        "Success",
        "API token is not set",
        "Invalid status code",
        "Encoding failed",
        "Decoding failed",
        "Request failed",
        "Unknown error"
    ]

    private var selectedResult = 0 {
        didSet {
            labelResult.text = results[selectedResult]
        }
    }
    private var useMocks = true

    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var labelResult: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.selectRow(selectedResult, inComponent: 0, animated: false)
        labelResult.text = results[selectedResult]
    }

    // MARK: - User actions

    @IBAction private func didChangeSwitchValue(_ sender: UISwitch) {
        pickerView.isUserInteractionEnabled = sender.isOn
        useMocks = sender.isOn
        labelResult.text = useMocks ? results[selectedResult] : nil
    }

    @IBAction private func didTapStart(_ sender: UIButton) {
        let networkResult: Result<(Data, URLResponse), Error>?

        if useMocks {
            switch selectedResult {
            case 0: networkResult = .success(NetworkServiceStub.paymentSuccess)
            case 1: networkResult = nil
            case 2: networkResult = .success(NetworkServiceStub.paymentFailureInvalidStatusCode)
            case 3: networkResult = .failure(EncodingError.invalidValue("", .init(codingPath: [], debugDescription: "Encoding Error")))
            case 4: networkResult = .failure(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Decoding Error")))
            case 5: networkResult = .failure(URLError(.badURL))
            default: networkResult = .failure(PSDKError.paymentFailure("SDK error"))
            }

            if selectedResult != 1 {
                PSDK.setup(apiToken: "", logLevel: .verbose, networkResult: networkResult)
            }
        }
        else {
            networkResult = nil
            PSDK.setup(apiToken: "", logLevel: .verbose, networkResult: networkResult)
        }

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        results.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        results[row]
    }

}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedResult = row
    }

}
