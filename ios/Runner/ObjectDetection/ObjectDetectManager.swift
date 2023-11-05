//
//  ObjectDetectManager.swift
//  Runner
//
//  Created by Neo Nguyen on 04/11/2023.
//

import UIKit
import Flutter
import Vision

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}

struct DetectionWithCount {
    let name: String
    var count: Int
}

final class ObjectDetectManager {
    
    static let shared : ObjectDetectManager = ObjectDetectManager()
    
    // For Object Detection
    var request: VNCoreMLRequest!
    var model: VNCoreMLModel!
    var currentImage: UIImage!
    
    private init() {}
    
    func detect(result : FlutterResult) {
        result(["hello" : UIImage(named: "")])
    }

}
