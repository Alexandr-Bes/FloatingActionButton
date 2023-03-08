//
//  MainViewController.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private var actionButtonView = FABView(buttonImage: UIImage(named: "plus_icon"))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupActionButton()
        
        let label = UILabel()
        label.text = "Hello world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        actionButtonView.frame = actionButtonViewFrame()
    }
}

private extension MainViewController {
    func actionButtonViewFrame() -> CGRect {
        let size: CGFloat = FABView.Height
        var horizontalMargin: CGFloat = size
        var verticalMargin: CGFloat = size
        
        let paddingX: CGFloat = FABView.paddingX
        let paddingY: CGFloat = FABView.paddingY
        
        if let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
            horizontalMargin += safeAreaInsets.right
            verticalMargin += view.safeAreaInsets.bottom
        }
        
        let result = CGRect(x: (view.frame.width - horizontalMargin) - paddingX,
                            y: (view.frame.height - verticalMargin) - paddingY,
                            width: size, height: size)
        return result
    }
    
    func setupActionButton() {
        view.addSubview(actionButtonView)
        
        actionButtonView.addItems(viewModels: createButtonsViewModel()) { [weak self] in
            self?.showSnackbar(with: "Hello world 🙂")
        }
    }
    
    func createButtonsViewModel() -> [FABViewModel] {
        let firstButton = FABViewModelImpl(title: "First Item", image: UIImage(named: "UkraineFlag_icon"))
        let secondButton = FABViewModelImpl(title: "Second Item", image: UIImage(named: "cool_icon"))
        let thirdButton = FABViewModelImpl(title: "Third Item", image: UIImage(named: "dev_icon"))
        return [firstButton, secondButton, thirdButton]
    }
}

fileprivate struct FABViewModelImpl: FABViewModel {
    var title: String
    var image: UIImage?
    var textColor: UIColor?
}
