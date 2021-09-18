//
//  Book.swift
//  Bert
//
//  Created by Ivan Dimitrov on 13.09.21.
//

import Foundation
import FirebaseFirestore

struct Book: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var author: String
}

class BooksViewModel: ObservableObject {
    @Published var books = [Book]()
    private var db = Firestore.firestore()
    
    func fetchData() {
        
        db.collection("book").addSnapshotListener { (querySnapshot , error) in
            guard let document = querySnapshot?.documents else {
                return
            }
            self.books = document.map { queryDocumentSnapShot -> Book in
                let data = queryDocumentSnapShot.data()
                
                let title = data["title"] as? String ?? ""
                let author = data["author"] as? String ?? ""
                return Book(title: title, author: author)
            }
        }
        
    }
}
