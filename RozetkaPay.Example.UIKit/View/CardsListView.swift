//
//  CardsListView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit
import RozetkaPaySDK
import OSLog

class CardsListViewController: UIViewController {
    
    var viewModel: CardsViewModel!
    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)
    
    init(items: [CardToken]) {
        self.viewModel = CardsViewModel(items: items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Tokenize card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        view.backgroundColor = UIColor.systemBackground
        
        // Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "CardCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Setup Add Button
        addButton.setTitle("Add new card", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        addButton.backgroundColor = .systemGreen
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 12
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        view.addSubview(addButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),
            
            addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapAddButton() {
        // Создаем представление TokenizationView (SwiftUI)
                let tokenizationView = RozetkaPaySDK.TokenizationView(
                    parameters: TokenizationParameters(
                        client: viewModel.clientWidgetParameters,
                        viewParameters: TokenizationViewParameters(
                            cardNameField: .optional,
                            emailField: .required,
                            cardholderNameField: .optional
                        )
                    ),
                    onResultCallback: { result in
                        self.handleResult(result)
                    }
                )
                
                // Оборачиваем SwiftUI в UIHostingController
                let hostingController = UIHostingController(rootView: tokenizationView)
                
                // Представляем UIHostingController как обычный контроллер
                present(hostingController, animated: true, completion: nil)
    }
}

extension CardsListViewController {
    
    private func handleResult(_ result: TokenizationResult) {
        switch result {
        case .success(let value):
            addNewCard(tokenizedCard: value)
        case .failure(let error):
            switch error {
            case let .failed(message, _):
                if let message = message, !message.isEmpty {
                    Logger.tokenizedCard.warning("⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️")
                } else {
                    Logger.tokenizedCard.warning("⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️")
                }
            case .cancelled:
                Logger.tokenizedCard.info("Tokenization was cancelled")
            }
        }
    }
    
    private func addNewCard(tokenizedCard: TokenizedCard) {
        let newCard = CardToken(
            paymentSystem: tokenizedCard.cardInfo?.paymentSystem,
            name: tokenizedCard.name,
            maskedNumber: tokenizedCard.cardInfo?.maskedNumber ?? "",
            cardToken: tokenizedCard.token
        )
        viewModel.add(item: newCard)
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension CardsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let card = viewModel.items[indexPath.row]
        cell.configure(with: card)
        return cell
    }
}


@available(iOS 17, *)
#Preview {
    let vc = CardsListViewController(items: CardsViewModel.mocData)
    return vc
}
