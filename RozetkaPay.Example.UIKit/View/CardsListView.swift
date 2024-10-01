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
    
    //MARK: - Constants
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 16
    }

    //MARK: - ViewModel
    var viewModel: CardsViewModel!
    
    
    //MARK: - UI
    private lazy var tableView: UITableView = {
        let list = UITableView()
        list.delegate = self
        list.dataSource = self
        list.register(CardCell.self, forCellReuseIdentifier: "CardCell")
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
    private lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Add new card"
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .systemGreen
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let btn = UIButton(configuration: configuration)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        btn.layer.cornerRadius = Constants.buttonCornerRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let action = UIAction { [weak self] _ in
            self?.didTapAddButton()
        }
        btn.addAction(action, for: .primaryActionTriggered)
        
        return btn
    }()
    
    //MARK: - Inits
    init(items: [CardToken]) {
        self.viewModel = CardsViewModel(items: items)
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
    private func setupUI() {
        title = "Tokenize card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        setupLayouts()
    }
        
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),
            
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            addButton.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width - 40),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    @objc private func didTapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapAddButton() {
      
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
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️"
                    )
                } else {
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️"
                    )
                }
            case .cancelled:
                Logger.tokenizedCard.info("Tokenization was cancelled")
            }
        }
    }
    
    private func addNewCard(tokenizedCard: TokenizedCard) {
        viewModel.add(
            item: CardToken(
                paymentSystem: tokenizedCard.cardInfo?.paymentSystem,
                name: tokenizedCard.name,
                maskedNumber: tokenizedCard.cardInfo?.maskedNumber ,
                cardToken: tokenizedCard.token
            )
        )
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
