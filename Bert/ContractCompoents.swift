// works 2
//  ContractCompoents.swift
//  web3Interaction
//
//  Created by Mitchell Tucker on 5/14/21.
//works2

import Foundation

// Methods available within the contract
enum ContractMethods:  String {

    case projectContract = "store"
//    case setContract = "setContract"
    case getProjectTitle = "retrieve"
}

let contractAddress = "0x550434D6bd42CAfF4F4c6A6Cbe4e6bA5C65D4D86"

let contractABI =
    """
 [
     {
         "inputs": [],
         "name": "retrieve",
         "outputs": [
             {
                 "internalType": "string",
                 "name": "",
                 "type": "string"
             }
         ],
         "stateMutability": "view",
         "type": "function"
     },
     {
         "inputs": [
             {
                 "internalType": "string",
                 "name": "num",
                 "type": "string"
             }
         ],
         "name": "store",
         "outputs": [],
         "stateMutability": "nonpayable",
         "type": "function"
     }
 ]
"""
