//
//  ViewController.swift
//  Kukushka_iOSSDK
//
//  Created by sunsay86 on 11/03/2023.
//  Copyright (c) 2023 sunsay86. All rights reserved.
//

import UIKit
import Kukushka_iOSSDK

class ViewController: UIViewController {
    
    private lazy var gameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.placeholder = "Game Key"
        tf.text = "gamedemo_cta"
        tf.textColor = .black
        tf.delegate = self
        tf.textAlignment = .left
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
        
    }()
    
    private lazy var userTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.text = "test"
        tf.layer.cornerRadius = 8
        tf.placeholder = "User ID"
        tf.textColor = .black
        tf.textAlignment = .left
        tf.delegate = self
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
        
    }()
    
    private lazy var hasSurveyButton: BaseButton = {
        let button = BaseButton(cornerRadius: 10)
        button.setTitle("Предзагрузка опроса", for: .normal)
        button.addTarget(self, action: #selector(hasSurveyButtonTapped), for: .touchUpInside)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var showSurveyButton: BaseButton = {
        let button = BaseButton(cornerRadius: 10)
        button.setTitle("Показать опрос", for: .normal)
        button.addTarget(self, action: #selector(showSurveyButtonTapped), for: .touchUpInside)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.contentMode = .center
        label.tintColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var master: SurveyClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        
        view.backgroundColor = .lightGray
        
        view.addSubview(gameTextField)
        gameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            gameTextField.heightAnchor.constraint(equalToConstant: 40),
            gameTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(userTextField)
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTextField.topAnchor.constraint(equalTo: gameTextField.bottomAnchor, constant: 40),
            userTextField.heightAnchor.constraint(equalToConstant: 40),
            userTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(hasSurveyButton)
        hasSurveyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hasSurveyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hasSurveyButton.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            hasSurveyButton.heightAnchor.constraint(equalToConstant: 40),
            hasSurveyButton.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(statusLabel)
                NSLayoutConstraint.activate([
                    statusLabel.centerXAnchor.constraint(equalTo: hasSurveyButton.centerXAnchor),
                    statusLabel.topAnchor.constraint(equalTo: hasSurveyButton.bottomAnchor, constant: 20)
                ])
        
        view.addSubview(showSurveyButton)
        showSurveyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showSurveyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSurveyButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            showSurveyButton.heightAnchor.constraint(equalToConstant: 40),
            showSurveyButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupSurveyClient() {
        master = SurveyMaster(
            userId: userTextField.text ?? "",
            gameKey: gameTextField.text ?? "",
            debugMode: true
        )
        master?.onSurveyAvailable = { [weak self] data in
            self?.statusLabel.text = "Подходящий опрос найден"
        }
        master?.onSurveyUnavailable = { [weak self] data in
            self?.statusLabel.text = "Подходящий опрос не найден"
            
        }
        master?.onSurveySuccess = { [weak self] nq in
            guard let nq, nq else {
                self?.statusLabel.text = "Последний опрос пройден успешно"
                return
            }
            self?.statusLabel.text = "Пользователь не подошёл под  целевую группу последнего опроса"
        }
        
        master?.onFail = { [weak self] _ in
            self?.statusLabel.text = "Последний опрос не пройден"
        }
        
        master?.onLoadFail = { [weak self] _ in
            self?.statusLabel.text = "Ошибка загрузки"
        }
        
        master?.onSurveyStart = { _ in
            print("[ViewController] onSurveyStart")
        }
    }
    
    @objc
    private func textDidChange() {
        master = nil
    }
    
    @objc
    private func hasSurveyButtonTapped(_ sender: UIButton) {
        
        statusLabel.text = "Проверяем наличие подходящего  опроса.."
        master = nil
        setupSurveyClient()
        master?.hasSurvey()
        
    }
    
    @objc private func showSurveyButtonTapped(_ sender: UIButton) {
        if master == nil {
            setupSurveyClient()
        }
        statusLabel.text = ""
        master?.showSurvey()
    }

}

extension ViewController: UITextFieldDelegate {
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the replacement string contains uppercase characters
        if string.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
            return false // Do not allow the change
        }
        return true // Allow the change
    }
    
}



