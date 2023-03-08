//
//  ActionButton.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

class ActionButton: UIButton {
    
    var action: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension ActionButton {
    @objc func action(_ sender: UIButton) {
        action.map { $0() }
    }
}
