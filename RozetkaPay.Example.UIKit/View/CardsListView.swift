//
//  CardsListView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit
import RozetkaPaySDK
import OSLog
import SwiftUI

class CardsListViewController: UIViewController {
    
    //MARK: - ViewModel
    private var viewModel: CardsViewModel!
    
    // MARK: - State
    private var isNeedToSaveTokenizedCard = false {
        didSet {
            Logger.tokenizedCard.info(
                "👀 Checkbox is now \(self.isNeedToSaveTokenizedCard ? "ON" : "OFF")"
            )
        }
    }
    
    //MARK: - UI
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLable,
            tableView,
            tokenizationFormView
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
        label.text = Localization.cards_title.description
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(CardCell.self, forCellReuseIdentifier: CardCell.reuseIdentifier)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.separatorStyle = .none
        return list
    }()
    
    private lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Localization.cards_add_new_card_button_title.description
        configuration.image = Images.plus.image()
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .systemGreen
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let action = UIAction { [weak self] _ in
            self?.didTapAddButton()
        }
        button.addAction(action, for: .primaryActionTriggered)
        
        return button
    }()
    
    private lazy var tokenizationFormView: UIView = {
        let formView = RozetkaPaySDK.TokenizationFormView(
            parameters: TokenizationFormParameters(
                client: viewModel.clientWidgetParameters,
                viewParameters: TokenizationFormViewParameters(
                    cardNameField: .none,
                    emailField: .none,
                    cardholderNameField: .none,
                    isVisibleCardInfoTitle:  true,
                    isVisibleCardInfoLegalView: true,
                    stringResources: StringResources(
                        cardFormTitle: "TEST",
                        buttonTitle:"buttonTitle TEST"
                    )
                ),
                themeConfigurator: RozetkaPayThemeConfigurator(
                    mode: .dark,
                    sizes: RozetkaPayDomainThemeDefaults.sizes(
                        mainButtonTopPadding: 50
                    ),
                    typography: RozetkaPayDomainThemeDefaults.typography(
                        fontFamily: .monospace,
                        subtitleTextStyle: DomainTypographyDefaults.subtitle(
                            fontSize: 6
                        ),
                        inputTextStyle: DomainTextStyle(
                            from: UIFont(name: "HelveticaNeue-Medium", size: 20) ??
                            UIFont.systemFont(ofSize: 6)
                            
                        )
                    )
                )
            ),
            onResultCallback: { [weak self] result in
                self?.handleResult(result)
            },
            stateUICallback: { [weak self] state in
                self?.handleUIState(state)
            },
            cardFormFooterEmbeddedContent: { [weak self] in
                self?.checkboxView()
            }
        )
        
        let hostingController = UIHostingController(rootView: formView)
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    //MARK: - Inits
    init(
        items: [CardToken]? = nil
    ) {
        self.viewModel = CardsViewModel(
            items: items ??  CardsViewModel.generateMocData()
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
private extension CardsListViewController {
    
    private func setupUI() {
        title = Localization.cards_navigation_bar_title.description
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(mainStack)
        view.addSubview(addButton)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),
            
            titleLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            addButton.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width - 40),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func didTapAddButton() {
        
        let tokenizationView = RozetkaPaySDK.TokenizationView(
            parameters: TokenizationParameters(
                client: viewModel.clientWidgetParameters,
                viewParameters: TokenizationViewParameters(
                    cardNameField: .optional,
                    emailField: .required,
                    cardholderNameField: .optional
                )
            ),
            onResultCallback: { [weak self] result in
                self?.handleResult(result)
                self?.dismiss(animated: true, completion: nil)
            }
        )
        
        let hostingController = UIHostingController(rootView: tokenizationView)
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true, completion: nil)
    }
    
    func addNewCard(tokenizedCard: TokenizedCard) {
        viewModel.add(
            item: CardToken(
                paymentSystem: tokenizedCard.cardInfo.paymentSystem,
                name: tokenizedCard.name,
                maskedNumber: tokenizedCard.cardInfo.maskedNumber ,
                cardToken: tokenizedCard.token
            )
        )
        tableView.reloadData()
    }
    
    private func checkboxView() -> some View {
        struct CheckBoxStyle: ToggleStyle {
            let colorOn: Color
            let colorOff: Color

            func makeBody(configuration: Configuration) -> some View {
                Button(action: {
                    configuration.isOn.toggle()
                }) {
                    HStack {
                        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(configuration.isOn ? colorOn : colorOff)

                        configuration.label
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                }
            }
        }

        struct CheckboxWrapperView: View {
            @State private var isChecked: Bool = false
            let onValueChanged: (Bool) -> Void

            var body: some View {
                HStack {
                    Toggle(isOn: $isChecked) {
                        Text("Test checkbox text")
                    }
                    .toggleStyle(CheckBoxStyle(colorOn: .green, colorOff: .gray))
                    .onChange(of: isChecked) { newValue in
                        onValueChanged(newValue)
                    }

                    Spacer()
                }
                .padding(.top, 6)
            }
        }

        return CheckboxWrapperView { newValue in
            self.isNeedToSaveTokenizedCard = newValue
        }
    }
}

//MARK: - Private Methods
private extension CardsListViewController {
    func handleResult(_ result: TokenizationResult) {
        let alertItem: AlertItem
        
        switch result {
        case .complete(let value):
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: "Tokenization card was successful."
            )
            addNewCard(tokenizedCard: value)
        case .failed(let error):
            switch error {
            case let .failed(message, _):
                if let message = message, !message.isEmpty {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "Tokenization of card failed with message: \(message)."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️"
                    )
                } else {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "An unknown error occurred with card tokenization. Please try again."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️"
                    )
                }
            case .cancelled:
                alertItem = AlertItem(
                    type: .info,
                    title: "Cancelled",
                    message: "Tokenization was cancelled manually by the user."
                )
                
                Logger.tokenizedCard.info(
                    "🏁 Tokenization was cancelled manually by user"
                )
            }
        case .cancelled:
            alertItem = AlertItem(
                type: .info,
                title: "Cancelled",
                message: "Tokenization was cancelled manually by the user."
            )
            
            Logger.tokenizedCard.info(
                "🏁 Tokenization was cancelled manually by user"
            )
        }
        
        self.showCustomAlert(item: alertItem)
    }
    
    func handleResult(_ result: TokenizationFormResult) {
        let alertItem: AlertItem
        
        switch result {
        case .complete(let value):
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: "Tokenization card was successful."
            )
            Logger.tokenizedCard.info(
                "✅ Susses: Tokenization card was successful."
            )
            let valueDescription: String = value.debugDescription
            Logger.tokenizedCard.info(
                "✅ Susses: Tokenization card information: \(valueDescription)."
            )
            addNewCard(tokenizedCard: value)
        case .failed(let error):
            switch error {
            case let .failed(message, _):
                if let message = message, !message.isEmpty {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "Tokenization of card failed with message: \(message)."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️"
                    )
                } else {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "An unknown error occurred with card tokenization. Please try again."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️"
                    )
                }
            case .cancelled:
                alertItem = AlertItem(
                    type: .info,
                    title: "Cancelled",
                    message: "Tokenization was cancelled manually by the user."
                )
                
                Logger.tokenizedCard.info(
                    "🏁 Tokenization was cancelled manually by user"
                )
            }
        case .cancelled:
            alertItem = AlertItem(
                type: .info,
                title: "Cancelled",
                message: "Tokenization was cancelled manually by the user."
            )
            
            Logger.tokenizedCard.info(
                "🏁 Tokenization was cancelled manually by user"
            )
        }
        
        self.showCustomAlert(item: alertItem)
    }
    
    func handleUIState(_ state: TokenizationFormUIState) {
        switch state {
            
        case .startLoading:
            Logger.tokenizedCard.info(
                "🎬 StartLoading UI STATE"
            )
        case .stopLoading:
            Logger.tokenizedCard.info(
                "🏁 StopLoading UI STATE "
            )
        case .error(let message):
            Logger.tokenizedCard.warning(
                "⚠️ WARNING UI STATE: An error with message \"\(message)\". Please try again. ⚠️"
            )
        case .success:
            
            Logger.tokenizedCard.info(
                "✅ Susses UI STATE: Tokenization card was successful."
            )
            
        }
    }
}

// MARK: - UITableViewDataSource
extension CardsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CardCell.reuseIdentifier,
            for: indexPath) as? CardCell
        else {
            return UITableViewCell()
        }
        let card = viewModel.items[indexPath.row]
        cell.configure(with: card)
        return cell
    }
}


@available(iOS 17, *)
#Preview {
    let vc = CardsListViewController(items: CardsViewModel.generateMocData())
    return vc
}
