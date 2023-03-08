//
//  FABStackView.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

class FABStackView: UIStackView {
    
    private var actionButtonViews: [UIView] = [UIView]()
    private var viewModels: [FABViewModel]?
    
    //Reference to the parent
    weak var actionButtonView: FABView?
    var callback: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Config UI
private extension FABStackView {
    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fill
        axis = .vertical
        alignment = .trailing
        spacing = 12
        clipsToBounds = true
        backgroundColor = .systemBackground
    }
}

//MARK: - Setup with data
extension FABStackView {
    func addActionButtons(viewModels: [FABViewModel], callback: @escaping FABViewCallback) {
        self.callback = callback
        self.viewModels = viewModels
        configureSecondaryButtons(with: viewModels)
    }
    
    private func configureSecondaryButtons(with viewModels: [FABViewModel]) {
        viewModels.forEach { item in
            let actionItemView = FABButtonView(viewModel: item)
            actionItemView.callback = { [weak self] in
                self?.callback?()
                self?.dismissWithAnimation()
                self?.actionButtonView?.close()
            }
            actionButtonViews.append(actionItemView)
        }
        
        addItemsToStack()
    }
    
    private func addItemsToStack() {
        actionButtonViews.forEach { view in
            view.alpha = 0
            addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.heightAnchor.constraint(equalToConstant: 34)
            ])
        }
    }
}


// MARK: - Show/Hide with animation
extension FABStackView {
    func showWithAnimation() {
        var delay = 0.0
        let animationGroup = DispatchGroup()
        self.alpha = 1
        
        for item in actionButtonViews {
            item.layer.transform = CATransform3DIdentity
            item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            animationGroup.enter()
            UIView.animate(withDuration: 0.3, delay: delay,
                           usingSpringWithDamping: 0.55,
                           initialSpringVelocity: 0.3,
                           options: UIView.AnimationOptions(), animations: { () -> Void in
                            item.layer.transform = CATransform3DIdentity
                            item.alpha = 1
            }, completion: { _ in
                animationGroup.leave()
            })
            let animationSpeed: Double = 0.1
            delay += animationSpeed
        }
    }
    
    func dismissWithAnimation() {
        var delay = 0.0
        let animationGroup = DispatchGroup()
        
        for item in actionButtonViews.reversed() {
            animationGroup.enter()
            UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: { () -> Void in
                item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
                item.alpha = 0
                self.alpha = 0
            }, completion: { _ in
                animationGroup.leave()
            })
            let animationSpeed: Double = 0.1
            delay += animationSpeed
        }
    }
}
