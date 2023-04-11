//
//  PayKitViewController.swift
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PayKit
import UIKit

// swiftlint:disable file_length
class PayKitViewController: UIViewController {

    private lazy var stackView = makeStackView()

    private lazy var endpointLabel = makeLabel(text: environment.title)
    private lazy var endpointToggle = makeEndpointToggle()
    private lazy var paymentTypeControlLabel = makeLabel(text: "Payment Type")
    private lazy var paymentTypeControl = makePaymentTypeControl()

    private lazy var amountTextField = makeAmountTextField()
    private lazy var amountTextFieldLabel = makeLabel(text: "Amount (in cents)")

    private lazy var accountReferenceIDTextField = makeAccountReferenceIDTextField()
    private lazy var accountReferenceIDTextFieldLabel = makeLabel(text: "Account Reference ID")

    private lazy var createRequestButton = makeCreateRequestButton()
    private lazy var updateRequestButton = makeUpdateRequestButton()
    private lazy var authorizeRequestButton = makeAuthorizeRequestButton()
    private lazy var statusTextView = makeStatusTextView()

    var environment: Environment = .sandbox {
        didSet {
            updateViewState()
        }
    }

    var pendingRequest: CustomerRequest? {
        didSet {
            updateViewState()
        }
    }

    private lazy var sdk: CashAppPay = {
        let sdk = CashAppPay(clientID: environment.clientID, endpoint: environment.endpoint)
        sdk.addObserver(self)
        return sdk
    }()

    private var brandID: String {
        environment.brandID
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackView)

        stackView.addArrangedSubview(paymentTypeControlLabel)
        stackView.addArrangedSubview(paymentTypeControl)

        stackView.setCustomSpacing(20, after: paymentTypeControl)

        stackView.addArrangedSubview(amountTextFieldLabel)
        stackView.addArrangedSubview(amountTextField)

        stackView.setCustomSpacing(20, after: amountTextField)

        stackView.addArrangedSubview(accountReferenceIDTextFieldLabel)
        stackView.addArrangedSubview(accountReferenceIDTextField)

        stackView.setCustomSpacing(20, after: accountReferenceIDTextField)

        stackView.addArrangedSubview(endpointToggle)

        stackView.setCustomSpacing(20, after: endpointToggle)

        stackView.addArrangedSubview(createRequestButton)
        stackView.addArrangedSubview(updateRequestButton)
        stackView.addArrangedSubview(authorizeRequestButton)
        stackView.addArrangedSubview(statusTextView)

        stackView.setCustomSpacing(20, after: authorizeRequestButton)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.readableContentGuide.centerYAnchor),

            endpointToggle.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            paymentTypeControlLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            paymentTypeControl.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            amountTextFieldLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            amountTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            accountReferenceIDTextFieldLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            accountReferenceIDTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            createRequestButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            updateRequestButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            authorizeRequestButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            statusTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            statusTextView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.25),
        ])

        updateViewState()
    }

    func updateViewState() {
        updateRequestButton.isEnabled = (pendingRequest != nil)
        authorizeRequestButton.isEnabled = (pendingRequest != nil)
        amountTextField.isEnabled = (paymentType == .ONE_TIME_PAYMENT)
        accountReferenceIDTextField.isEnabled = (paymentType == .ON_FILE_PAYMENT)
        endpointLabel.text = environment.title
    }

    // MARK: - Button Actions

    func createButtonPress() {
        sdk.createCustomerRequest(params: createParamsFromView)
    }

    func updateButtonPress() {
        guard let request = pendingRequest else { return }
        sdk.updateCustomerRequest(request, with: updateParamsFromView)
    }

    func authorizeButtonPress() {
        guard let request = pendingRequest else { return }
        sdk.authorizeCustomerRequest(request)
    }

    func endpointToggleChanged() {
        self.environment = (environment == .sandbox) ? .staging : .sandbox
        sdk.removeObserver(self)
        sdk = CashAppPay(clientID: environment.clientID, endpoint: environment.endpoint)
        sdk.addObserver(self)
    }
}

// MARK: - Computed Properties
extension PayKitViewController {
    private var paymentType: PaymentType {
        return PaymentType.allCases[paymentTypeControl.selectedSegmentIndex]
    }

    private var amount: Money? {
        guard let amountText = amountTextField.text, !amountText.isEmpty, let amount = UInt(amountText) else {
            return nil
        }
        return Money(amount: amount, currency: .USD)
    }

    private var accountReferenceID: String? {
        guard let accountReferenceID = accountReferenceIDTextField.text, !accountReferenceID.isEmpty else {
            return nil
        }
        return accountReferenceID
    }

    var createParamsFromView: CreateCustomerRequestParams {
        let action: PaymentAction
        switch paymentType {
        case .ONE_TIME_PAYMENT:
            action = .oneTimePayment(scopeID: brandID, money: amount)
        case .ON_FILE_PAYMENT:
            action = .onFilePayment(scopeID: brandID, accountReferenceID: accountReferenceIDTextField.text)
        }

        return CreateCustomerRequestParams(
            actions: [action],
            redirectURL: URL(string: "paykitdemo://callback")!,
            referenceID: nil,
            metadata: nil
        )
    }

    var updateParamsFromView: UpdateCustomerRequestParams {
        let action: PaymentAction
        switch paymentType {
        case .ONE_TIME_PAYMENT:
            action = .oneTimePayment(scopeID: brandID, money: amount)
        case .ON_FILE_PAYMENT:
            action = .onFilePayment(scopeID: brandID, accountReferenceID: accountReferenceIDTextField.text)
        }

        return UpdateCustomerRequestParams(
            actions: [action],
            referenceID: nil,
            metadata: nil
        )
    }
}

// MARK: - View Building
extension PayKitViewController {

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }

    func makeEndpointToggle() -> UIStackView {
        let toggle = UISwitch(frame: .zero, primaryAction: UIAction { [weak self] _ in
            self?.endpointToggleChanged()
        })
        let stack = UIStackView(arrangedSubviews: [toggle, endpointLabel])
        stack.spacing = 16
        return  stack
    }

    func makeCreateRequestButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.title = NSLocalizedString(
            "Create Customer Request",
            comment: "Title for button to create Customer Request"
        )
        let button = UIButton(
            configuration: configuration,
            primaryAction: UIAction(
                handler: { [weak self] _ in
            self?.createButtonPress()
                }
            )
        )
        return button
    }

    func makeUpdateRequestButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.title = NSLocalizedString(
            "Update Customer Request",
            comment: "Title for button to update Customer Request"
        )
        let button = UIButton(
            configuration: configuration,
            primaryAction: UIAction(
                handler: { [weak self] _ in
            self?.updateButtonPress()
                }
            )
        )
        return button
    }

    func makeAuthorizeRequestButton() -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.title = NSLocalizedString(
            "Authorize Customer Request",
            comment: "Title for button to create Customer Request"
        )
        let button = UIButton(
            configuration: configuration,
            primaryAction: UIAction(
                handler: { [weak self] _ in
            self?.authorizeButtonPress()
                }
            )
        )
        return button
    }

    func makeStatusTextView() -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .cyan
        textView.text = "Expect results here"
        return textView
    }

    func makePaymentTypeControl() -> UISegmentedControl {
        let control = UISegmentedControl(frame: .zero, actions: [
            UIAction(
                title: "One-Time",
                handler: handlePaymentTypeControlChanged
            ),
            UIAction(
                title: "On File",
                handler: handlePaymentTypeControlChanged
            ),
        ])
        control.selectedSegmentIndex = 0
        return control
    }

    func handlePaymentTypeControlChanged(action: UIAction) {
        updateViewState()
    }

    func makeAmountTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }

    func makeAccountReferenceIDTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Reference ID #"
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        return textField
    }

    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        return label
    }
}

// MARK: - CashAppPayObserver

extension PayKitViewController: CashAppPayObserver {
    // swiftlint:disable:next cyclomatic_complexity
    func stateDidChange(to state: CashAppPayState) {
        switch state {
        case .notStarted:
            statusTextView.text = "Hit that button!"
        case .creatingCustomerRequest:
            statusTextView.text = "Awaiting create response..."
        case .updatingCustomerRequest:
            statusTextView.text = "Awaiting update response..."
        case .readyToAuthorize(let customerRequest):
            statusTextView.text = "Received Customer Request: \n \(customerRequest)"
            pendingRequest = customerRequest
        case .redirecting:
            statusTextView.text = "Redirecting..."
        case .polling:
            statusTextView.text = "Polling..."
        case .declined(let customerRequest):
            pendingRequest = customerRequest
            statusTextView.text = "❌ DECLINED ❌ \n \(customerRequest)"
        case .approved(let customerRequest, let grants):
            pendingRequest = customerRequest
            statusTextView.text = "✅ APPROVED! ✅ \n \(grants)"
        case .apiError(let apiError):
            statusTextView.text = "🚨🚨🚨🚨🚨\n API ERROR \n🚨🚨🚨🚨🚨 \n\n\(apiError)"
        case .integrationError(let integrationError):
            statusTextView.text = "🐛🐛🐛🐛🐛\n INTEGRATION ERROR \n🐛🐛🐛🐛🐛 \n\n\(integrationError)"
        case .networkError(let networkError):
            statusTextView.text = "🌐🌐🌐🌐🌐\n NETWORK ERROR \n🌐🌐🌐🌐🌐 \n\n\(networkError)"
        case .unexpectedError(let unexpectedError):
            statusTextView.text = "⁉️⁉️⁉️⁉️⁉️\n UNEXPECTED ERROR \n⁉️⁉️⁉️⁉️⁉️ \n\n\(unexpectedError)"
        }
    }
}

extension PayKitViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard textField == amountTextField else { return true }
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension PayKitViewController {
    enum Environment {
        private static let sandboxClientID = "CAS-CI_PAYKIT_MOBILE_DEMO"
        private static let sandboxBrandID = "BRAND_9t4pg7c16v4lukc98bm9jxyse"
        private static let stagingClientID = "CASH_CHECKOUT"
        private static let stagingBrandID = "BRAND_4wv02dz5v4eg22b3enoffn6rt"

        case sandbox
        case staging

        var title: String {
            switch self {
            case .staging: return "Staging"
            case .sandbox: return "Sandbox"
            }
        }

        var clientID: String {
            switch self {
            case .sandbox: return Environment.sandboxClientID
            case .staging: return Environment.stagingClientID
            }
        }

        var brandID: String {
            switch self {
            case .sandbox: return Environment.sandboxBrandID
            case .staging: return Environment.stagingBrandID
            }
        }

        var endpoint: CashAppPay.Endpoint {
            switch self {
            case .sandbox: return .sandbox
            case .staging: return .staging
            }
        }
    }
}
