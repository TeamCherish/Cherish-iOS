//
//  ImageFileManager.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/03/09.
//

import Foundation
import UIKit

class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    // Save Image
    // name: ImageName
    func saveImage(image: UIImage, name: String,
                   onSuccess: @escaping ((Bool) -> Void)) {
        guard let data: Data
                = image.jpegData(compressionQuality: 1)
                ?? image.pngData() else { return }
        if let directory: NSURL =
            try? FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false) as NSURL {
            do {
                try data.write(to: directory.appendingPathComponent(name)!)
                onSuccess(true)
            } catch let error as NSError {
                print("Could not saveImage🥺: \(error), \(error.userInfo)")
                onSuccess(false)
            }
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir: URL
            = try? FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false) {
            let path: String
                = URL(fileURLWithPath: dir.absoluteString)
                .appendingPathComponent(named).path
            let image: UIImage? = UIImage(contentsOfFile: path)
            
            return image
        }
        return nil
    }
}
