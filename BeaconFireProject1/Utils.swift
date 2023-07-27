//
//  Utils.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import AVFoundation
import Foundation
import UIKit

class Utils {
    static func resizeImage(_ image: UIImage?, width: Double) -> UIImage? {
        guard let image else {
            return nil
        }
        // keep aspect ratio
        let longLength = image.size.width > image.size.height ? width : width * image.size.height / image.size.width
        let maxSize = CGSize(width: longLength, height: longLength)
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        
        // resize image
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized
    }
    
    static func resizeImage(_ image: UIImage?, height: Double) -> UIImage? {
        guard let image else {
            return nil
        }
        // keep aspect ratio
        let longLength = image.size.height > image.size.width ? height : height * image.size.width / image.size.height
        let maxSize = CGSize(width: longLength, height: longLength)
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        
        // resize image
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized
    }
    
    static func cropImage(_ image: UIImage?, WHRatio: Double) -> UIImage? {
        guard let image else {
            return nil
        }
        guard let cgImage = image.cgImage else {
            return image
        }
        let originalWHRatio = image.size.width / image.size.height
        let rect = originalWHRatio > WHRatio
            ? CGRect(origin: .zero, size: CGSize(width: image.size.height * WHRatio, height: image.size.height))
        : CGRect(origin: .zero, size: CGSize(width: image.size.width, height: image.size.width / WHRatio))
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
}
