//
//  BatchCartViewController.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//



import UIKit
import RozetkaPaySDK
import OSLog
import SwiftUI

class BatchCartViewController: UIViewController {
    
    //MARK: - ViewModel
    private var viewModel: BatchCartViewModel!
    
    //MARK: - UI
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLable,
            tableView,
            stackBottom
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = Localization.batch_cart_title.description
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseIdentifier)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.separatorStyle = .none
        list.estimatedRowHeight = 80
        list.rowHeight = UITableView.automaticDimension
        list.estimatedSectionHeaderHeight = 60
        list.sectionHeaderHeight = UITableView.automaticDimension
        list.showsVerticalScrollIndicator = false
        return list
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.batch_cart_checkout_button_title.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.didTapCheckoutButton()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = Localization.batch_cart_total_title.description
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: "%.2f", viewModel.totalAmount)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shipmentLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.batch_cart_shipment_title.description
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shipmentInfoLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.shipment
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
            stackShipment,
            stackTotal
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var checkBox: CheckBoxDataView = {
        let checkBox = CheckBoxDataView(
            title: Localization.batch_cart_use_tokenized_card.description,
            value: viewModel.isNeedToUseTokenizedCard,
            colorOn: .systemGreen,
            colorOff: .gray,
            isSelected: { [weak self] isSelected in
                self?.handleCheckBoxChanged(isSelected)
            }
        )
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        return checkBox
    }()
    
    private lazy var stackBottom: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            stackLable,
            checkBox,
            checkoutButton
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Inits
    init(
        externalId: String? = nil,
        orders: [Order]? = nil
    ) {
        self.viewModel = BatchCartViewModel(
            externalId: externalId ?? BatchCartViewModel.generateExternalId(),
            orders: orders ?? BatchCartViewModel.generateMocData()
        )
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
    
    //MARK: - Methods
    @objc private func didTapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Private Methods
private extension BatchCartViewController {
    
    func setupUI() {
        title = Localization.batch_cart_navigation_bar_title.description
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Images.arrowLeft.image(),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(mainStack)
        
        setupLayouts()
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            mainStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            titleLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            stackBottom.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackBottom.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            checkoutButton.heightAnchor.constraint(equalToConstant: 52),
            stackLable.widthAnchor.constraint(equalTo: stackBottom.widthAnchor)
        ])
    }
    
    func didTapCheckoutButton() {

        let payView =  RozetkaPaySDK.PayView(
            batchPaymentParameters: BatchPaymentParameters(
                client: viewModel.clientParameters,
                themeConfigurator: RozetkaPayThemeConfigurator(),
                paymentType: viewModel.isNeedToUseTokenizedCard ?
                    .singleToken(
                        SingleTokenPayment(
                            token: viewModel.testCardToken
                        )
                    ) :
                        .regular(
                            RegularPayment(
                                viewParameters: PaymentViewParameters(
                                    cardNameField: .none,
                                    emailField: .none,
                                    cardholderNameField: .none
                                ),
                                isAllowTokenization: true,
                                applePayConfig: viewModel.testApplePayConfig
                            )
                        ),
                amountParameters:  AmountParameters(
                    amount: viewModel.totalNetAmountInCoins,
                    tax: viewModel.totalVatAmountInCoins,
                    total: viewModel.totalAmountInCoins,
                    currencyCode: Config.defaultCurrencyCode
                ),
                externalId: viewModel.externalId,
                callbackUrl: Config.exampleCallbackUrl,
                orders: viewModel.orders.mapToBatchOrder()
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
    
    func handleCheckBoxChanged(_ selected: Bool) {
        viewModel.isNeedToUseTokenizedCard = selected
    }
    
    func handleResult(_ result: BatchPaymentResult) {
        let alertItem: AlertItem
        
        switch result {
        case let .pending(batchExternalId, ordersPayments, message, error):
            alertItem = AlertItem(
                type: .info,
                title: "Pending",
                message: "BatchPayment is pending. External ID: \(batchExternalId)"
            )
            Logger.payment.info(
                "BatchPayment is pending. External ID: \(batchExternalId). Message: \(message ?? "No message"). Error: \(error?.localizedDescription ?? "No error description")"
            )
        case let .complete(batchExternalId, ordersPayments, tokenizedCard):
            var text = "BatchPayment was successful. External ID: \(batchExternalId)"
            if let tokenizedCard = tokenizedCard {
                text += "TokenizedCard: \(tokenizedCard.cardInfo?.maskedNumber ?? tokenizedCard.name ?? tokenizedCard.token)"
            }
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: text
            )
            Logger.payment.info("\(text)")
        case let .failed(batchExternalId, error, ordersPayments):
            if error.code == .transactionAlreadyPaid {
                alertItem = AlertItem(
                    type: .warning,
                    title: "Failed",
                    message: "External ID: \(batchExternalId ?? viewModel.externalId) already paid. "
                )
                Logger.payment.info(
                    "⚠️ WARNING: BatchPayment already paid. External ID: \(batchExternalId ?? self.viewModel.externalId)."
                )
                return
            }
            
            if let message = error.message, !message.isEmpty {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "BatchPayment with external ID: \(batchExternalId ?? self.viewModel.externalId) has failed with message: \(message)."
                )
                var errorText =  "⚠️ WARNING: An error with message \"\(message)\", paymentId: \"\(error.paymentId ?? "")\"."
                
                
                errorText += " errorDescription: \(error.localizedDescription)."
                errorText += "Please try again. ⚠️"
                Logger.payment.warning("\(errorText)")
            } else {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "An unknown error occurred with external ID: \(batchExternalId ?? self.viewModel.externalId). Please try again."
                )
                Logger.payment.warning(
                    "⚠️ WARNING: An error occurred during batchpayment process. external ID: \(batchExternalId ?? self.viewModel.externalId). Please try again. ⚠️"
                )
            }
        case .cancelled:
            alertItem = AlertItem(
                type: .info,
                title: "Cancelled",
                message: "BatchPayment was cancelled manually by the user."
            )
            Logger.payment.info("BatchPayment was cancelled manually by user")
        }
        
        self.showCustomAlert(item: alertItem)
    }
}

// MARK: - UITableViewDelegate
extension BatchCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders[section].products.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.reuseIdentifier,
            for: indexPath
        ) as? CartItemCell else {
            return UITableViewCell()
        }
        let item = viewModel.orders[indexPath.section].products[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == viewModel.orders.count - 1 ? 50 : 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == viewModel.orders.count - 1 {
            let spacer = UIView()
            spacer.backgroundColor = .clear
            return spacer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CartSectionHeaderView()
        let order = viewModel.orders[section]
        headerView.configure(with: order, section: section)
        return headerView
    }
}

@available(iOS 17, *)
#Preview {
    let vc =  BatchCartViewController(
        externalId: BatchCartViewModel.generateExternalId(),
        orders: BatchCartViewModel.generateMocData()
    )
    return vc
}
