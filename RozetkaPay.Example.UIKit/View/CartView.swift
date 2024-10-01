//
//  CartView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 01.10.2024.
//

import UIKit
import RozetkaPaySDK
import OSLog
import SwiftUI

class CartViewController: UIViewController {

    //MARK: - Constants
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 16
    }

    //MARK: - ViewModel
    var viewModel: CartViewModel!

    //MARK: - UI
    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()

    private lazy var checkoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Checkout", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Constants.buttonCornerRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.didTapCheckoutButton()
        }
        btn.addAction(action, for: .primaryActionTriggered)
        return btn
    }()

    private lazy var totalLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.label
        lbl.text = "Total:"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var totalAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String(format: "%.2f", viewModel.totalPrice)
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .systemGreen
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var shipmentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Shipment:"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = UIColor.label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var shipmentInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = viewModel.shipment
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = UIColor.label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var stackLable: UIStackView = {
        let stackTotal = UIStackView(arrangedSubviews: [
            totalLabel,
            totalAmountLabel
        ])
        stackTotal.axis = .horizontal
        stackTotal.distribution = .equalSpacing
        stackTotal.alignment = .fill
        stackTotal.translatesAutoresizingMaskIntoConstraints = false

        let stackShipment = UIStackView(arrangedSubviews: [
            shipmentLabel,
            shipmentInfoLabel
        ])
        stackShipment.axis = .horizontal
        stackShipment.distribution = .equalSpacing
        stackShipment.alignment = .fill
        stackShipment.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [
            stackTotal,
            stackShipment
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var stackBottom: UIStackView = {

        let stack = UIStackView(arrangedSubviews: [
            stackLable,
            checkoutButton
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    //MARK: - Inits
    init(orderId: String, items: [Product]) {
        self.viewModel = CartViewModel(orderId: orderId, items: items)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK - Methods
    private func setupUI() {
        title = "Your cart"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        view.backgroundColor = UIColor.systemBackground

        view.addSubview(tableView)
        view.addSubview(stackBottom)

        setupLayouts()
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackBottom.topAnchor, constant: -10),

            stackBottom.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackBottom.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            checkoutButton.heightAnchor.constraint(equalToConstant: 52),
            stackLable.widthAnchor.constraint(equalTo: stackBottom.widthAnchor)
        ])
    }

    @objc private func didTapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapCheckoutButton() {
        let payView = RozetkaPaySDK.PayView(
            parameters: PaymentParameters(
                client: ClientAuthParameters(token: Credentials.DEV_AUTH_TOKEN),
                viewParameters: PaymentViewParameters(cardNameField: .none, emailField: .none, cardholderNameField: .none),
                themeConfigurator: RozetkaPayThemeConfigurator(),
                amountParameters: PaymentParameters.AmountParameters(
                    amount: viewModel.totalAmount,
                    tax: viewModel.totalTax,
                    total: viewModel.totalPrice,
                    currencyCode: Config.defaultCurrencyCode
                ),
                orderId: viewModel.orderId,
                callbackUrl: Config.exampleCallbackUrl,
                isAllowTokenization: true,
                applePayConfig: viewModel.testApplePayConfig
            ),
            onResultCallback: { [weak self] result in
                self?.handleResult(result)
                self?.dismiss(animated: true, completion: nil)
            }
        )
        
        let hostingController = UIHostingController(rootView: payView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
}

extension CartViewController {
    
    private func handleResult(_ result: PaymentResult) {
        switch result {
        case let .pending(orderId, paymentId):
            Logger.payment.info("Payment pending \(orderId) \(paymentId)")
        case let .complete(orderId, paymentId):
            Logger.payment.info("Payment complete \(orderId) \(paymentId)")
        case let .failed(paymentId, message, errorDescription):
            if let message = message, !message.isEmpty {
                Logger.payment.warning(
                    "⚠️ WARNING: An error with message \"\(message)\", paymentId: \"\(paymentId ?? "")\". Please try again. ⚠️"
                )
            } else {
                Logger.payment.warning(
                    "⚠️ WARNING: An error occurred during payment process. Please try again. ⚠️"
                )
            }
        case .cancelled:
            Logger.payment.info("Payment was cancelled")
        }
    }
    
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


@available(iOS 17, *)
#Preview {
    let vc =  CartViewController(orderId: "test", items: CartViewModel.mocData)
    return vc
}
