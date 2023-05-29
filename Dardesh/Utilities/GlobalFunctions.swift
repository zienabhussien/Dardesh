//
//  GlobalFunctions.swift
//  Dardesh
//
//  Created by Zienab on 28/05/2023.
//

import Foundation

func fileNameFrom(fileUrl: String)-> String{
    let name = fileUrl.components(separatedBy: "_").last
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    
    return name2!
}
