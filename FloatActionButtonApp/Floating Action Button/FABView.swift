//
//  FABView.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

typealias FABViewCallback = (() -> ())  // Change it to your callback type if you need different types

class FABView: UIView {
    
    private let overlayView = UIControl()
    private let stackView = FABStackView()
    private var actionItems: [FABButtonView] = []
    private let mainButton = FABMainButton()
    private var isMenuOnScreen: Bool = false
    var callback: FABViewCallback?
    
    static let paddingX: CGFloat = 13.0
    static let paddingY: CGFloat = 25.0
    static let Height: CGFloat = 50.0
    
    var size: CGFloat = 50.0 {
        didSet {
            self.setNeedsDisplay()
            self.recalculateItemsOrigin()
        }
    }
    
    private var overlayViewDidCompleteOpenAnimation: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(buttonImage: UIImage?) {
        super.init(frame: .zero)
        mainButton.setImage(buttonImage, for: .normal)
        mainButton.addTarget(self, action: #selector(mainButtonAction), for: .touchUpInside)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func configure() {
        setObserver()
        configureContainer()
        layoutUI()
    }
    
    private func configureContainer() {
        mainButton.backgroundColor = UIColor.blue
    }
    
    private func layoutUI() {
        addSubview(mainButton)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            mainButton.widthAnchor.constraint(equalToConstant: 50),
//            mainButton.heightAnchor.constraint(equalToConstant: 50),
            mainButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainButton.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func deviceOrientationDidChange(_ notification: Notification) {
        setOverlayFrame()
    }
    
    private func recalculateItemsOrigin() {
        for item in actionItems {
            let big = size > item.size ? size : item.size
            let small = size <= item.size ? size : item.size
            item.frame.origin = CGPoint(x: big/2-small/2, y: big/2-small/2)
        }
    }
    
    private func setOverlayView() {
      setOverlayFrame()
      overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
      overlayView.alpha = 0
      overlayView.isUserInteractionEnabled = true
    }
    
    private func setOverlayFrame() {
        if let superview = superview {
          overlayView.frame = CGRect(
            x: 0,y: 0,
            width: superview.bounds.width,
            height: superview.bounds.height
          )
        }
    }
    
    private func setStackView() {
        if let _superview = superview {
            if !stackView.isDescendant(of: _superview) {
                _superview.addSubview(stackView)
                stackView.alpha = 0
                stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                stackView.isLayoutMarginsRelativeArrangement = true
                stackView.round(radius: 5.0)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
            }
        }
    }
    
    //MARK: - Main Action
    @objc private func mainButtonAction() {
        setOverlayFrame()
        isMenuOnScreen ? close() : open()
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred()
    }
}

//MARK: - Animation
extension FABView {
    @objc func open() {
        setOverlayView()
        setStackView()
        
        self.superview?.insertSubview(overlayView, aboveSubview: self)
        self.superview?.insertSubview(stackView, aboveSubview: overlayView)
        self.superview?.bringSubviewToFront(self)
        overlayView.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let animationGroup = DispatchGroup()
        animationGroup.enter()
        overlayViewDidCompleteOpenAnimation = false
        
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.3,
                       options: UIView.AnimationOptions(), animations: { () -> Void in
            self.mainButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.overlayView.alpha = 1
        }, completion: { _ in
            self.overlayViewDidCompleteOpenAnimation = true
            animationGroup.leave()
        })
        
        UIAccessibility.post(notification: .layoutChanged, argument: stackView.arrangedSubviews.first)
        
        stackView.showWithAnimation()
        
        isMenuOnScreen.toggle()
        setNeedsDisplay()
        self.layoutSubviews()
    }
    
    @objc func close() {
        let animationGroup = DispatchGroup()
        
        self.overlayView.removeTarget(self, action: #selector(close), for: .touchUpInside)
        animationGroup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: [], animations: { () -> Void in
            self.mainButton.transform = CGAffineTransform(rotationAngle: 0)
            self.overlayView.alpha = 0
        }, completion: { _ in
            if self.overlayViewDidCompleteOpenAnimation {
                self.overlayView.removeFromSuperview()
            }
            animationGroup.leave()
        })
        
        UIAccessibility.post(notification: .layoutChanged, argument: self)
        stackView.dismissWithAnimation()
        
        isMenuOnScreen.toggle()
    }
}

// MARK: - Config with Data
extension FABView {
    func addItems(viewModels: [FABViewModel], callback: @escaping FABViewCallback) {
        stackView.addActionButtons(viewModels: viewModels, callback: callback)
        stackView.actionButtonView = self
    }
}
