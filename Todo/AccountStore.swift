//
//  AccountStore.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 25/06/2022.
//

import Foundation

class AccountStore{
    var allAccounts = [Account]()
    
    func addAccount(account: Account){
        allAccounts.append(account)
        Database.addAccount(newAccount: account)
    }
}
