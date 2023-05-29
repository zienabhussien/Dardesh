//
//  FileStorage.swift
//  Dardesh
//
//  Created by Zienab on 27/05/2023.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseStorage

let storage = Storage.storage()
class FileStorage{

    // MARK: - images

    class func uploadImage(_ image: UIImage,directory: String, completion: @escaping(_ documentLink: String?)-> Void){
        
        //1. create folder in firestore
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        
        //2. convert image to data
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        //3. put data into firestore and return link
        var  task: StorageUploadTask!
        
       task = storageRef.putData(imageData!,metadata: nil) { (metaData, error) in
        
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error uploading imag: \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url else{
                    completion( nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
            
        }
        
        //4. observe percentage upload
        task.observe(StorageTaskStatus.progress) { snapshot in
            
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    class func downloadImage(imageUrl: String, completion: @escaping(UIImage?)-> Void){
        
      let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        if fileExistsAtPath(path: imageFileName){
        //  print("file exists locally")
            if let contentOfFile = UIImage(contentsOfFile: fileInDocumentDirectory(fileName: imageFileName)){
               completion(contentOfFile)
            }else{
                print("could not convert local image")
                completion(UIImage(named: "avatar")!)
         }
                
        }else{
            // download image from firebase
            if imageUrl != "" {
                let documentUrl = URL(string: imageUrl)
                let documentQueue = DispatchQueue(label: "imageDownloadQueue")

                documentQueue.async {
                    let data = NSData(contentsOf: documentUrl!)

                    if data != nil{
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }

                    }else{
                       print("no document found")
                        completion(nil)
                    }
                }
            }
        }
        
    }
    
    // MARK: - save file locally
    class func saveFileLocally(fileData: NSData,fileName: String){
    
        let docUrl = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
        
    }

}

// MARK: - Helpers
    
    func getDocumentURL() -> URL {
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    func fileInDocumentDirectory(fileName: String)-> String{
        return getDocumentURL().appendingPathComponent(fileName).path
    }
   
    func fileExistsAtPath(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: fileInDocumentDirectory(fileName: path))
    }
