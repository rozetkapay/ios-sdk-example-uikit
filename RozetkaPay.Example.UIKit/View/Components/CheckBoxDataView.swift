//
//  CheckBoxDataView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//
import UIKit

public final class CheckBoxDataView: UIView {
    
    //MARK: - Properties
    private var isSelectedCallback: (Bool) -> ()
    
    private var colorOn: UIColor
    private var colorOff: UIColor
    
    // MARK: UI Elements
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(horizontalStack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            checkboxButton,
            checkboxLabel
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.setBackgroundImage(
            Images.square.image()?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.setBackgroundImage(
            Images.checkmarkSquareFill.image()?.withRenderingMode(.alwaysTemplate),
            for: .selected
        )
        button.tintColor = colorOff
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var checkboxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    public init(
        title: String,
        value: Bool = false,
        colorOn: UIColor = .systemGreen,
        colorOff: UIColor = .gray,
        isSelected: @escaping (Bool) -> ()
    ) {
        self.isSelectedCallback = isSelected
        self.colorOn = colorOn
        self.colorOff = colorOff
        super.init(frame: .zero)
        self.checkboxLabel.text = title
        self.setSelected(value, shouldNotify: false)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(mainStack)
        addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(checkboxDidTapped)
        ))
        isUserInteractionEnabled = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // MARK: - Public
    
    public func setSelected(_ selected: Bool) {
        setSelected(selected, shouldNotify: true)
    }
    
    public func setSelected(_ selected: Bool, shouldNotify: Bool) {
        updateButtonAppearance(isSelected: selected)
        if shouldNotify {
            isSelectedCallback(selected)
        }
    }
    
    // MARK: - Private
    
    private func updateButtonAppearance(isSelected: Bool) {
        checkboxButton.isSelected = isSelected
        checkboxButton.tintColor = isSelected ? colorOn : colorOff
    }
    
    // MARK: - Actions
    @objc private func checkboxDidTapped() {
        let newState = !checkboxButton.isSelected
        setSelected(newState, shouldNotify: true)
    }
}
