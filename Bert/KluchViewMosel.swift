//
//  Book.swift
//  Bert
//
//  Created by Ivan Dimitrov on 13.09.21.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI


class KluchViewMosel : ObservableObject{
    
    @Published var sendKluch : String = ""
    @Published var text      : String = ""
    @Published var isSendData : Bool = false
    private var cancellabes = Set<AnyCancellable>()
    
    @Published var name : String =  ""
    @Published var description : String = ""
    @Published var registerText : String = ""
    
    
    init() {
        setupData()
        registration()
    }
    
  private  func setupData(){
        
        $sendKluch
            .debounce(for: .seconds(1) , scheduler: DispatchQueue.main)
            .sink { [weak self] returneddata in
                
                if !returneddata.isEmpty {
                    print(">>>>>>>>\(returneddata)")
                    //+ (self!.name == "" ? "name: unknown, " : "name: \(self!.name), ")  + (self!.description == "" ? "description: unknown, " : "description: \(self!.description). ")
                    self?.text = returneddata + " Force, "
                    self?.sendKluch = ""
                    withAnimation(.linear(duration: 2.0)){
                        self?.isSendData = true
                    }
                  
                }

            }
            .store(in: &cancellabes)
        
    }
    private func registration(){
        
        $name
            .debounce(for: .seconds(0.4) , scheduler: DispatchQueue.main)
            .sink { returneddata in
                if returneddata.count > 20 {
                    UIApplication.shared.endEditing()
                }
            }
            .store(in: &cancellabes)
        $description
            .debounce(for: .seconds(0.4) , scheduler: DispatchQueue.main)
            .sink { returneddata in
                if returneddata.count > 20 {
                    UIApplication.shared.endEditing()
                }
            }
            .store(in: &cancellabes)
        
    }
    
    func clearText() {
                        self.text = ""
                        self.sendKluch = ""
    }
}
