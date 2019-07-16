//
//  ConvertImageToBW.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation
import UIKit

class ConverImageToBW {

    init() {}

    func convertImageToBW(image: UIImage) -> UIImage {

        let filter = CIFilter(name: "CIPhotoEffectMono")

        // convert UIImage to CIImage and set as input

        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        // get output CIImage, render as CGImage first to retain proper UIImage scale

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

        return UIImage(cgImage: cgImage!)
    }
}
