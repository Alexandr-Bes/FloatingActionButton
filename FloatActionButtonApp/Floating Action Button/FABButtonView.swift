//
//  FABButtonView.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

protocol FABViewModel {
    var title: String { get set }
    var image: UIImage? { get set }
    var textColor: UIColor? { get set }
}

class FABButtonView: UIView {
    
    private var iconImageView = UIImageView()
    private var titleLabel = FABInsetLabel()
    private var viewModel: FABViewModel?
    
    //Reference to the parent
    weak var actionButtonView: FABView?
    var callback: (()->())?
    
    var size: CGFloat = 30 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: size, height: size)
            iconImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            self.setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure(with: viewModel)
    }

    init(viewModel: FABViewModel) {
         super.init(frame: .zero)
         self.viewModel = viewModel
         configure(with: viewModel)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with viewModel: FABViewModel?) {
        configureSecondaryButton()
        setupAction()
        configureLabel()
        configureLayoutUI()
    }
    
    private func configureSecondaryButton() {
        iconImageView.image = viewModel?.image
        iconImageView.round(radius: 15)
    }
    
    private func configureLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .natural
        titleLabel.text = viewModel?.title
        titleLabel.numberOfLines = 2
        titleLabel.textColor = viewModel?.textColor ?? UIColor.black
    }
    
    private func setupAction() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(touch)
    }
    
    @objc private func tapAction() {
        callback?()
    }
    
    private func configureLayoutUI() {
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
}


