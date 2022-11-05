//
//  ContentView.swift
//  wrench
//111
//  Created by Ivan Dimitrov on 9.12.21.
//

import SwiftUI

import SwiftUI
import web3swift
import PromiseKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorageSwift
import Combine
import CryptoKit

var contract:ProjectContract?

var web3:web3?
var network:Network = .goerli
var wallet:Wallet?

var password        = ""
var privateKey      = ""
var walletName      = "GanacheWallet"
var contractAddress = "0x545bf7119FA620C4D269D9b1E8722d15c3b81A7f"


struct ContentView: View {
    
    @State private var text = "The data obtained will be written to:"
    @State private var eteryum: [String] = "Ethereum".map{ String($0)}
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var couner = 0
    @State private var sendedText : String = ""
    @State private var isSend :  Bool = false

    @State private var projectTitle: String = ""
    
    @StateObject var kluchViewMosel = KluchViewMosel()
    @State private var screenWidth = UIScreen.main.bounds.width
    @State private var screenHeight =  UIScreen.main.bounds.height * 0.8
    @State private var SelectButton : Bool = true
   
   

    var body: some View {
        ZStack {
            Color.white.opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 0) {

                VStack {
                    
                    if SelectButton {
                        Registration
                            .frame(width: screenWidth, height: screenHeight)
                            .transition(.move(edge: .trailing))
                    }
                    else{
                        WorkingArray
                            .frame(width: screenWidth, height: screenHeight)
                            .transition(.move(edge: .leading))
                    }
                }
              
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.linear(duration: 1)){
                            self.SelectButton = true
                        }
                    }) {
                        HStack{
                            Text("💿")
                            
                            Text("Register")
                        }
                        .padding()
                        .font(.system(size: 24))
                        .foregroundColor(Color("GreenLogo"))
                        
                    }
                    .background(
                        !self.SelectButton ?    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2) : nil
                    )
                    Spacer()
                    Button(action: {
                        withAnimation(.linear(duration: 1)){
                            self.SelectButton = false
                        }
                    }) {
                        HStack{
                            Text("🔧")
                            
                            Text("Work  ")
                        }
                        .padding()
                        .font(.system(size: 24))
                        .foregroundColor(Color("GreenLogo"))
                        
                       
                    }
                    .background(
                        self.SelectButton ?    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2) : nil
                    )
                    Spacer()
                }

            }
        }
}

  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView {
    
    
    
    
    private var WorkingArray : some View {
        
        ZStack {
            Color.white.opacity(0.5)
                .ignoresSafeArea()
            VStack{
                Spacer()
                logoTitle
                Spacer()
                if !self.kluchViewMosel.isSendData {
                    stackImage
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }else{
                    stackText
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
                Spacer()
            }
        }
        .onChange(of:kluchViewMosel.text, perform: { kluch in
            print(">>>>>\(kluch)")
                    self.projectTitle = kluch
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if kluchViewMosel.sendKluch == "" && !projectTitle.isEmpty {
                    self.projectTitle = self.projectTitle +  (kluchViewMosel.name == "" ? "name: unknown, " : "name: \(kluchViewMosel.name), ")  + (kluchViewMosel.description == "" ? "description: unknown, " : "description: \(kluchViewMosel.description). ")
                    saveToEt()
                    print(">>>>>>>>>>>>> \(projectTitle) >>>>>>>>>>>>>>>>>>")
                }
            }
        })
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()){
                let lastIndex = eteryum.count - 1
                if couner == lastIndex{
                    couner = 0
                }else{
                    couner += 1
                }
            }
        })
        
    }
    
    private var Registration : some View {
        ZStack {
            Color.white.opacity(0.5)
                .ignoresSafeArea()
            VStack{
                Image("BCRL")
                    .resizable()
                    .frame(width: screenWidth, height: 200)
                Section{
                    HStack(spacing: 0){
                        TextField("Name ... ", text: $kluchViewMosel.name )
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 5).stroke(Color("ArdaColor") ,style: StrokeStyle(lineWidth: 2)))
                            .padding()
                        Spacer()
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            kluchViewMosel.name = ""
                        }) {
                            
                            Text(kluchViewMosel.name == "" ? "" :  "⌫")
                            
                                .font(.system(size: 32))
                                .foregroundColor(Color("GreenLogo"))
                        }
                        .frame(width: 40, height: 40, alignment: .leading)
                        .padding(.vertical, 15.0)
                    }

                    HStack(spacing: 0) {
                        TextField("Description ...", text: $kluchViewMosel.description)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 5).stroke(Color("ArdaColor") ,style: StrokeStyle(lineWidth: 2)))
                            .padding()
                        Spacer()
                        Button(action: {
                            UIApplication.shared.endEditing()
                            kluchViewMosel.description = ""
                        }) {
                            
                            Text(kluchViewMosel.description == "" ? "" :  "⌫")
                            
                                .font(.system(size: 32))
                                .foregroundColor(Color("GreenLogo"))
                        }
                        .frame(width: 40, height: 40, alignment: .leading)
                        .padding(.vertical, 15.0)
                    }
                }
                Spacer()
            }
           
        }
    }
    
    
    private var logoTitle : some View {
        
        VStack{
            Text(text)
                .foregroundColor(Color("GreenLogo"))
            HStack{
                ForEach(eteryum.indices) { index in
                    Text(eteryum[index])
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("GreenLogo"))
                        .offset(y: couner == index ? 10 : 0)
                }
            }
            .offset(y: 10)
        }
    }
    
    private var  stackImage :  some View {
        
        ZStack(alignment: .bottom) {
            Image("kluch")
                .scaleEffect()
                .frame(width: UIScreen.main.bounds.width * 0.8)
            
            HStack(alignment: .bottom){
                TextField(" Waiting ...", text: $kluchViewMosel.sendKluch)
                    .padding(.vertical,6)
                    .background(Color.white)
                    .background(RoundedRectangle(cornerRadius: 1).stroke(Color("ArdaColor") ,style: StrokeStyle(lineWidth: 3)))
            }
            .frame( height: 70, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).padding(.top, 15))
            .padding(.horizontal)
            
                
        }
       .frame(width: UIScreen.main.bounds.width)
       
        .background( RoundedRectangle(cornerRadius: 10).fill(Color.gray).padding(.horizontal, 8))
    }
    
    private var  stackText :  some View {
        ZStack {
            HStack{
                VStack(spacing: 0){
                   Text("The data is being send ....")
                        .foregroundColor(Color("GreenLogo"))
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                    VStack(spacing: 0){
                        Text(kluchViewMosel.text)
                        Text(kluchViewMosel.name == ""  ? " unknown " : kluchViewMosel.name)
                        Text(kluchViewMosel.description == "" ? " unknown " : kluchViewMosel.description)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("ArdaColor"))
                    .multilineTextAlignment(.leading)
                    
                    Text("please wait ...")
                        .foregroundColor(Color("GreenLogo"))
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
           
                ProgressView()
                    .scaleEffect(2)
                    .padding(.horizontal, 30)
                
            }

        }
        .frame(width: UIScreen.main.bounds.width, height: 130)
        .background( RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 3)
                    .fill(Color.gray) .padding(.horizontal, 8))
                       
       
    }
    

    
    private var addClear : some View {
        VStack{
            Text( kluchViewMosel.isSendData ? " The data\n \(kluchViewMosel.text) \nsend to Eteriyum " : "enter data ...." )
                .padding()
                .font(.system(size: 21))
                .foregroundColor(.red.opacity(0.8))
            
                .onChange(of:kluchViewMosel.text, perform: { kluch in
                    
                    print(">>>>>\(kluch)")

                            self.projectTitle = kluch
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if kluchViewMosel.sendKluch == "" && !projectTitle.isEmpty {
                            saveToEt()
                            print(">>>>>>>>>>>>> \(projectTitle) >>>>>>>>>>>>>>>>>>")
                        }
                    }
                })
        }
    }
    
    func saveToEt(){
        wallet = getWallet(password: password, privateKey: privateKey, walletName: walletName)
        // Create contract with wallet as the sender
        contract = ProjectContract(wallet: wallet!, contractString: contractAddress)
        // Call contract method
        createNewProject()
    }
    

    func createNewProject() {
        print("....\(projectTitle)")
        let parameters = [projectTitle] as [AnyObject]
        firstly {
            // Call contract method
            callContractMethod(method: .projectContract, parameters: parameters,password: password)
        }.done { response in
            // print out response
            print("createNewProject response \(response)")
            // Call out get projectTitle
            self.getProjectTitle()
        }
    }

    func getProjectTitle() {
        let parameters = [] as [AnyObject]
        firstly {
            // Call contract method
//            callContractMethod(method: .getProjectTitle, parameters: parameters,password: nil)
            callContractMethod(method: .getProjectTitle, parameters: parameters,password: nil)
        }.done { response in
            // print out response
            print("getProjectTitle response \(response) arda")
            withAnimation(.linear(duration: 1)) {
                self.kluchViewMosel.isSendData = false
            }
          
            self.kluchViewMosel.clearText()
            
        }
    }
}


extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
