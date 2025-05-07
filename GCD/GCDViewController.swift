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
    func didUpdateUser()
    func didFailWithError(_ error: Error)
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
    
    private lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.delegate = self
        userTableView.delegate = self
        userTableView.dataSource = self
        setupViews()
        setupConstraints()
        viewModel.fetchUsers()
    }
    
    func setupViews() {
        view.addSubview(containerView)
        view.addSubview(userTableView)
        containerView.addSubview(label)
        containerView.addSubview(heavyCalculateStartButton)
        containerView.addSubview(colorChangeButton)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
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
        
        userTableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
        
    }

    
    
    //MARK: Private Functions
    
    @objc private func startGCD() {
        viewModel.globalQueueSync2()
        
    }
    
    @objc private func plusNumber() {
        number += 1
        label.text = "\(number)"
        
    }

}

extension GCDViewController: GCDViewModelDelegate {
    func didUpdateUser() {
        userTableView.reloadData()
    }
    
    func didFailWithError(_ error: any Error) {
        label.text = "\(error)"
    }
    
    
    func heavyCalculateDidFinish() {
        self.label.text = "Calculate Finished"
    }
}

extension GCDViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(user.name) - \(user.email)"
        return cell
    }
}

