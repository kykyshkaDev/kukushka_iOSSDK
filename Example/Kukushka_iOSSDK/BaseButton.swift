//
//  BaseButton.swift
//  Kukushka_iOSSDK_Example
//
//  Created by Aleksunder Volkov on 09.11.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

import UIKit

class BaseButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.layer.shadowOffset = .init(width: 12, height: 12)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        
        self.layer.masksToBounds = false
        addTapsAnimations()
    }
    
    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = cornerRadius
        layer.shadowOffset = .init(width: 0, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
//        clipsToBounds = true
        addTapsAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTouchDown() {
        animateButtonDown()
    }
    
    @objc
    private func didTouchUpOutside() {
        animateButtonUp()
    }
    
    @objc
    private func didTouchUpInside() {
        animateButtonUp()
    }
    
    private func animateButtonDown() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseIn],
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self?.layer.masksToBounds = true
                       },
                       completion: nil)
    }

    private func animateButtonUp() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.identity
            self?.layer.masksToBounds = false
                       },
                       completion: nil)
    }
}

extension BaseButton {
    private func addTapsAnimations() {
        addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        addTarget(self, action: #selector(didTouchUpOutside), for: .touchUpOutside)
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
}

