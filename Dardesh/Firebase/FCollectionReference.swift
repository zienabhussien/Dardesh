//
//  FCollectionReference.swift
//  Dardesh
//
//  Created by Zienab on 21/05/2023.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case User
}

func FireStoreReference(_ collectionRef: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionRef.rawValue)
}
