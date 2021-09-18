
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
var network:Network = .rinkeby
var wallet:Wallet?
var password = "dakata_7b" // leave empty string for ganache


struct ContentView: View {
    
//    @ObservedObject private var model = BooksViewModel()
    @ObservedObject var models = CountryRepository()
    @State var company : String = ""
    @State var medicine: String = ""
    @State var location = Locale.current
    @State var onSelect : Bool = false
    
    @State var isShow : Bool = false
    @State var scanningText : String = ""
    @State var isMedic : Medic?
    @State private var  documentURL = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/fir-todo2-4d9ab.appspot.com/o/Color.pdf?alt=media&token=25e021f4-842f-4a29-8796-ef2fae19587c")

    
    var body: some View {

        
        ZStack {
            Image("qr_image")
                .resizable()
                .scaledToFit()
                .opacity(0.2)
                .scaleEffect(1.5)
                .edgesIgnoringSafeArea(.all)
            Text("\(self.documentURL!.relativeString)")
                .foregroundColor(.clear)
                .onChange(of: documentURL!.relativeString) { _ in
                    self.isMedic = .pdfAction
                }
            Text("Scanner goes here...\n\(self.scanningText)")
                .foregroundColor(.clear)
                .onChange(of: scanningText) { _ in
                    let elements = self.scanningText.components(separatedBy: "/")
                    self.company = elements[0]
                    self.medicine = elements[1]
                }
            Text("company...\(self.company)")
                .foregroundColor(.clear)
                .onChange(of: company) { _ in
                    self.models.loadCountry(company: self.company, medicine: self.medicine)
                }
                .foregroundColor(.red)
            
            VStack(alignment: .center) {
                
                VStack(alignment: .center){
                    Text("HackZurich 2021")
                        .font(.system(size: 27))
//                    Text(location.regionCode!)

                }
                .frame(width: UIScreen.main.bounds.width * 1.2 , height: 110)
                .modifier(PrimaryButton())
                .edgesIgnoringSafeArea(.top)
//                .onChange(of: scanningText) { _ in
//                    self.documentURL = NSURL(string: scanningText)
//                    isMedic = .pdfAction
//                }
                
//  MARK: - Buttons
                
                HStack{
                    
                    Button(action: {
                        // Create wallet using either a private key or mnemonic
                        wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"metamask")
                        
                        // Create contract with wallet as the sender
                        contract = ProjectContract(wallet: wallet!)
                        
                        // Call contract method
                        // createNewProject()
                        saveToFB(manifacturer: "BAYER", medicine: "Aspirin-protect", fileName: "famotidine", country: "Cuba", flag: "🇨🇺")
                        getProjectTitle()
                        
                     
                        
                    }) {
                       Text("🐱")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }.offset(x: -20)
                   
                    Button(action: {
                        // Create wallet using either a private key or mnemonic
                        wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"metamask")
                        // Create contract with wallet as the sender
                        contract = ProjectContract(wallet: wallet!)
                        // Call contract method
                       // createNewProject()
                        saveToFireBase()
                        getProjectTitle()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }.offset(x: 20)
                    
                }
                ZStack {
                    VStack(alignment: .center, spacing: 20){
                        ForEach(models.models) { model in
                            HStack{
                                Button(action: {
                                    self.onSelect = true
                                        let stringUrl = models.getURL(model: model)
                                    if stringUrl == self.documentURL?.relativeString {
                                        self.isMedic = .pdfAction
                                    }else{
                                        
                                        self.documentURL = NSURL(string: models.getURL(model: model))
                                    }
                                        let data = NSData(contentsOf: NSURL(string: stringUrl) as! URL)
                                        let hashedValue = SHA256.hash(data: data! )
//                                    трябва да се проверъ hashedValue с този от Етхериум и тогажа да се присвои  self.documentURL
//                                    в противен слуцхеи Алерт
                      
                                  
                                }) {
                                    HStack{
                                        Text(model.flag)
                                            .scaleEffect(2)
                                        Spacer()
                                        Text(model.country)
                                            .font(.system(size: 12))
                                    }


                                }
                                .padding(.horizontal, 20)
                                .frame(width: 200, height: 40, alignment: .center)
                                .modifier(PrimaryButton())

                            }

                        }
                    }
                    if onSelect {
                        ProgressView()
                            .scaleEffect(5)
                    }
                }
//  MARK: - Scanar
                
                Spacer()
                Button(action: {
                    isShow = true
                    isMedic = .scanningAction

                }) {
                    Text("start scanning")
                        .font(.system(size: 27))
                        .frame(width: UIScreen.main.bounds.width / 1.2 , height: 100)
                        .modifier(PrimaryButton())
                }
            }
            

                
//                Spacer()
//                Button(action: {
//                    // Create wallet using either a private key or mnemonic
//                    wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"metamask")
//                    // Create contract with wallet as the sender
//                    contract = ProjectContract(wallet: wallet!)
//                    // Call contract method
//                    createNewProject()
//                    getProjectTitle()
//                }) {
//                    Image(systemName: "paperplane.fill")
//                        .font(.largeTitle)
//                        .foregroundColor(.orange)
//                }
         
        }
       
        .sheet(item: $isMedic)  { medic in
            switch medic {
            case .scanningAction:  ScannerView( scanningText: $scanningText)
            case .pdfAction: PDFKitView(url: documentURL! as URL).onAppear(){onSelect = false}
            case .firebase: EmptyView()
            }
        }

//        .onAppear(){
//            self.models.loadCountry(company: self.company, medicine: self.medicine)
//        }

    }
    
//    func loadUrlFromFirebase() {
//        let fileRef     = Storage.storage().reference().child("nebilet.pdf")
//        fileRef.downloadURL {( url , err ) in
//            if let downloadUrl = url {
//                self.documentURL = NSURL(string: scanningText)
//            }
//        }
//    }
    
    func saveToFB(manifacturer: String, medicine: String, fileName: String, country: String, flag: String) {
        
        let path = Bundle.main.path(forResource: fileName, ofType: "pdf")
        let filePathURL = URL(fileURLWithPath: path!)
        let fileREF = Storage.storage().reference().child("\(manifacturer)/\(fileName)")
        
        do{
            let _ = try! fileREF.putFile( from: filePathURL , metadata: nil) { (metadata , error ) in
                
                guard let metadata = metadata else {
                    print("error metadada ...\n \(error?.localizedDescription)")
                    return
                }
                let size = metadata.size
                DispatchQueue.main.async { [self] in
                    fileREF.downloadURL{ (url , err) in
                        guard let downloadURL = url else {
                            print("error >>:: \(err?.localizedDescription)")
                            return
                        }
                        do{
                            let data = try  NSData(contentsOf: downloadURL)
                       
                            let hashedValue = SHA256.hash(data: data! )
                            print("Hashed Value: \(hashedValue)")
                            createNewProject( hashedValue: hashedValue, downloadURL: downloadURL.relativeString)
                        }catch{ print("no  > Hashed Value")}
                        
                        saveModelToFB(manifacturer: manifacturer, medicine:  medicine, downloadURL: downloadURL.relativeString, country: country, flag: flag)
                    }
                }
                
            }
            
        }catch{
            
        }
    }
    
    
    
    func saveModelToFB(manifacturer: String, medicine: String, downloadURL: String,  country: String, flag: String){
        
        let moselToSave = Country(country: country, flag: flag, urlToFile: downloadURL, name: medicine)
        let db = Firestore.firestore()
        
        do{
            let _ = try db.collection("\(manifacturer)").addDocument(from: moselToSave)
            
        }catch{
            print("No saved to Firestore.firestore()")
        }
    }
    
    
    
    func saveToFireBase(){
        
        let filename = "QRV"
        let filePath    = Bundle.main.url(forResource: filename, withExtension: "pdf")
        let fpath = Bundle.main.path(forResource: filename, ofType: "pdf")
        
        let filePathURL = URL(fileURLWithPath: fpath!)

        let fileRef     = Storage.storage().reference().child("ether/pdf")
        print("\(filePath)")
        do{
            let _ = try! fileRef.putFile( from: filePathURL , metadata: nil) { (metadata , error ) in

                guard let metadata = metadata else {
                    print("error 🇫🇷metadada ...\n \(error?.localizedDescription)")
                    return
                }
                let size = metadata.size

                DispatchQueue.main.async { [self] in
                    fileRef.downloadURL{( url , err ) in
                        guard let downloadURL = url else {
                            print("error .. >> url")
                            return
                        }
                        print("url >> \(downloadURL.relativeString)")
                        do{
                            let data = try  NSData(contentsOf: downloadURL)
                            print("data:>\(data)")
                            let hashedValue = SHA256.hash(data: data! )
                            print("Hashed Value: \(hashedValue)")
                            createNewProject( hashedValue: hashedValue, downloadURL: downloadURL.relativeString)
                        }catch{ print("no  > Hashed Value")}

                    }
                }
                

            }
        }
        catch {
            print("error putData ...")
        }
    }

    func createNewProject( hashedValue: SHA256.Digest, downloadURL: String) {
        
        let projectTitle = "HouseSiding"
        let projectLocation = "299 Race Ave. Dacula, GA 30019"
        let projectStart = "\(downloadURL)"
        let projectEnd = "\(hashedValue)"
        let teamType = "Collaboration"

        let parameters = [projectTitle,projectLocation,projectStart,projectEnd,teamType] as [AnyObject]
        firstly {
            // Call contract method
            callContractMethod(method: .projectContract, parameters: parameters,password: "dakata_7b")
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
            callContractMethod(method: .getProjectEnd, parameters: parameters,password: nil)
        }.done { response in
            // print out response
            print("getProjectTitle response \(response)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct ContentView_LibraryContent: LibraryContentProvider {
    var views: [LibraryItem] {
        LibraryItem(/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/)
    }
}



