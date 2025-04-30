//
//  GCDViewController.swift
//  GCD
//
//  Created by Onur Altintas on 30.04.2025.
//

import SnapKit
import UIKit

protocol GCDViewModelDelegate: AnyObject {
    func heavyCalculateDidFinish()
}

class GCDViewController: UIViewController {
    
    //MARK: Private Properties
    
    private var number = 0
    
    private let viewModel = GCDViewModel()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "\(number)"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var heavyCalculateStartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .systemGray6
        button.addTarget(self, action: #selector(startGCD), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .systemGray6
        button.addTarget(self, action: #selector(plusNumber), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.delegate = self
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(heavyCalculateStartButton)
        containerView.addSubview(colorChangeButton)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        heavyCalculateStartButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        colorChangeButton.snp.makeConstraints { make in
            make.top.equalTo(heavyCalculateStartButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
    }

    
    
    //MARK: Private Functions
    
    @objc private func startGCD() {
        viewModel.heavyCalculationStart()
        
    }
    
    @objc private func plusNumber() {
        number += 1
        label.text = "\(number)"
        
    }

}

extension GCDViewController: GCDViewModelDelegate {
    
    func heavyCalculateDidFinish() {
        self.label.text = "Calculate Finished"
    }
}

