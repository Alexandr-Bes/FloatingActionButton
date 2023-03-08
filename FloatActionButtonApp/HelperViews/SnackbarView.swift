//
//  SnackbarView.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

//A simple Snackbar View
final class BaseSnackbarView: UIView {

    //MARK: - Properties
    
    static let Height: CGFloat = 50.0
    static let SmallHeight: CGFloat = 40.0
    
    private static let padding: CGFloat = 16.0
    
    var callback: (()->())?
    
    //MARK: - UI
    private let contentView = UIView()
    private let leftIndicatorView = UIView()
    private let closeButton = ActionButton()
    private let actionButton = ActionButton()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Initialise
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupActions()
    }

    
    //MARK: - Public

    /// Remove snackbar view from superview after finished animation
    func showWithAnimationAndRemove(message: String?) {
        self.isHidden = false
        textLabel.text = message
        showWithAnimationAndRemove()
    }
}

//MARK: - Setup
private extension BaseSnackbarView {
    func setupUI() {
        self.alpha = 0
        self.isHidden = true
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Self.padding),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(Self.padding)),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        contentView.addSubview(leftIndicatorView)
        leftIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftIndicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftIndicatorView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
//            textLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 6),
//            textLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 6),
            textLabel.leadingAnchor.constraint(equalTo: leftIndicatorView.trailingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        closeButton.setImage(UIImage(named: "cross_icon"), for: .normal)
        closeButton.contentMode = .scaleAspectFit
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        configUI()
    }
    
    func setupActions() {
        actionButton.action = { [weak self] in
            self?.callback?()
            self?.hideAndRemoveView()
        }
        
        closeButton.action = { [weak self] in
            self?.callback?()
            self?.hideAndRemoveView()
        }
        
        setupSwipeGesture()
    }
    
    func setupSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideAndRemoveView))
        swipeRight.direction = .left
        self.addGestureRecognizer(swipeRight)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideAndRemoveView))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
    }

    func configUI() {
        textLabel.textColor = .white
        contentView.backgroundColor = .green
        leftIndicatorView.backgroundColor = .brown
    }
    
    func showWithAnimationAndRemove() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        Timer.scheduledTimer(timeInterval: 3,
                             target: self,
                             selector: #selector(hideAndRemoveView),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc func hideAndRemoveView() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { success in
            if success {
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
}
