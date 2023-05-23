//
//  FirestoreManager.swift
//  StaffX
//
//  Created by Danylo Ternovoi on 16.05.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Firestorable: Codable {
    var id: String { get }
}

enum StaffXCollections: String {
    case departments
}

enum StaffXSubCollections: String {
    case employees
}

class FirestoreManager {
    
    let database = Firestore.firestore()
    
    func getDocuments<T: Firestorable>(fromCollection collectionName: StaffXCollections.RawValue,
                                       inDocument documentName: String? = nil,
                                       inSubCollection subcolletionDocumentName: StaffXSubCollections.RawValue? = nil) async throws -> [T] {
        if let documentName, let subcolletionDocumentName {
            let collectionReference = database
                .collection(collectionName)
                .document(documentName)
                .collection(subcolletionDocumentName)
            return try await loadData(fromReference: collectionReference)
        } else {
            let collectionReference = database.collection(collectionName)
            return try await loadData(fromReference: collectionReference)
        }
    }
    
    private func loadData<T: Firestorable>(fromReference reference: CollectionReference) async throws -> [T] {
        let querySnapshot = try await reference.getDocuments()
        let documents = querySnapshot.documents
        let response = documents.compactMap { document -> T? in
            do {
                return try document.data(as: T.self)
            } catch {
                print("error")
                return nil
            }
        }
        return response
    }
    
    func createOrUpdate<T: Firestorable>(document: T,
                                         inCollection collectionName: StaffXCollections.RawValue,
                                         inDocument documentName: String? = nil,
                                         inSubcollection subCollectionName: StaffXSubCollections.RawValue? = nil) throws {
        if let documentName, let subCollectionName {
            let collectionReference = database
                .collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(document.id)
            try collectionReference.setData(from: document)
        } else {
            let collectionReference = database
                .collection(collectionName)
                .document(document.id)
            try collectionReference.setData(from: document)
        }
    }
    
    func delete(documentID: String,
                fromCollection collectionName: StaffXCollections.RawValue,
                inDocument documentName: String? = nil,
                inSubCollection subCollectionName: StaffXSubCollections.RawValue? = nil) async throws {
        if let documentName, let subCollectionName {
            let collectionReference = database
                .collection(collectionName)
                .document(documentName)
                .collection(subCollectionName)
                .document(documentID)
            try await collectionReference.delete()
        } else {
            let collectionReference = database
                .collection(collectionName)
                .document(documentID)
            try await collectionReference.delete()
        }
    }
}
