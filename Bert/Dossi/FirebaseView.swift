//
//  FirebaseView.swift
//  Bert
//
//  Created by Ivan Dimitrov on 16.09.21.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorageSwift
import Combine

struct Country: Identifiable,Codable {
 @DocumentID   var id        : String? = UUID().uuidString
               var country   : String
               var flag      : String
               var urlToFile : String
               var name      : String
}

class CountryRepository: ObservableObject {
    
    @Published var models = [Country]()
    
    let db = Firestore.firestore()
    let cancelBag = Set<AnyCancellable>()
    
    func loadCountry(company: String, medicine: String) {
        if company != "" && medicine != "" {
            db.collection("\(company)").whereField("name", isEqualTo: medicine).addSnapshotListener {( snapshot, error ) in
                guard let document = snapshot?.documents else {
                    print("No 🇧🇬🇧🇷🇧🇪Document ")
                    return }
                print("Document:\(document)")
                self.models = document.compactMap{ queryDocumentSnapshot -> Country? in
                    return try? queryDocumentSnapshot.data(as: Country.self)
                }
            }
        }
        

    }
    
    func getURL(model: Country)  -> String {
        
           let index =  models.firstIndex(where: { $0.id == model.id}) ??  0
           let url = models[index].urlToFile

        return url
    }
    
    func loadFile(reference: String, fileURL : URL)  {
        
        let progress : PassthroughSubject<(id: Int, progress: Progress), Never> = .init()
        let reference = Storage.storage().reference(forURL: reference)
    }
    
    enum upLoad{
        case progress(procentage: Double)
    }
    
}

