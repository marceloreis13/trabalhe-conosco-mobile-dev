//
//  TransactionCoordinator.swift
//  PicPay
//
//  Created by Marcelo Reis on 11/24/18.
//  Copyright © 2018 Marcelo Reis. All rights reserved.
//

import UIKit

public final class TransactionCoordinator: Coordinator {
    fileprivate let presenter: UINavigationController
    fileprivate var transactionViewController: UINavigationController?
    fileprivate var credcardListCoordinator: CredcardListCoordinator?
    fileprivate var user: User?
    fileprivate var accountStorage: AccountStorage
    
    init(presenter: UINavigationController, user: User, accountStorage: AccountStorage) {
        self.presenter = presenter
        self.user = user
        self.accountStorage = accountStorage
    }
    
    public func start() {
        let viewController = TransactionViewController(nibName: nil, bundle: nil)
        viewController.user = user
        viewController.accountStorage = accountStorage
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        transactionViewController = UINavigationController(rootViewController: viewController)
        
        let btn = UIButtonNavbar(title: "Cancelar")
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let leftBtn = UIBarButtonItem(customView: btn)
        transactionViewController?.navigationBar.topItem?.leftBarButtonItem = leftBtn

        presenter.present(transactionViewController!, animated: true, completion: nil)
    }
}

// MARK: - Delegates

extension TransactionCoordinator: TransactionViewControllerProtocol {
    public func goesToCredcardList() {
        guard let transactionViewController = transactionViewController else { return }
        
        credcardListCoordinator = CredcardListCoordinator(presenter: transactionViewController, account: accountStorage)
        credcardListCoordinator?.start()
    }
    
    @objc
    public func dismiss() {
        transactionViewController?.dismiss(animated: true, completion: nil)
    }
}
