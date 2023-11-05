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

struct DetectionWithCount : Codable {
    let name: String
    var count: Int
}

final class ObjectDetectManager {
    
    static let shared : ObjectDetectManager = ObjectDetectManager()
    
    // For Object Detection
    var request: VNCoreMLRequest!
    var model: VNCoreMLModel!
    var currentImage: UIImage!
    
    var predictions: [VNRecognizedObjectObservation] = []
    private var result : FlutterReply?
    private var colors: [String: UIColor] = [:]
    private func labelColor(with label: String) -> UIColor {
        // Assign random color per class
        if let color = self.colors[label] {
            return color
        } else {
            let color = UIColor(
                red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 0.8
            )
            self.colors[label] = color
            return color
        }
    }
    
    init(){
        setupModel()
    }
    
    private func setupModel(){
        guard let odModel = try? best_yolov8s_080923() else { fatalError("fail to load the model") }
        if let model = try? VNCoreMLModel(for: odModel.model) {
            self.model = model
//            request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
            request = VNCoreMLRequest(model: model) {[weak self] request, err in
                guard let `self` = self else { return }
                self.visionRequestDidComplete(request: request, error: err)
            }
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("fail to create vision model")
        }
    }
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let predictions = request.results as? [VNRecognizedObjectObservation]{
            self.predictions = predictions
            
            // Print out detection result
            var detections: [Detection] = []
            var objectCount: [String: Int] = [:]
            for result in predictions {
                print("Detected object: \(result.labels.first?.identifier ?? "Unknown"), with confidence: \(result.confidence)")
                // The output coordinates from models is normalized between 0 -> 1.
                let flippedBox = CGRect(
                    x: result.boundingBox.minX,
                    y: 1 - result.boundingBox.maxY,
                    width: result.boundingBox.width,
                    height: result.boundingBox.height
                )
                // De-normalized to the actual size.
                let box = VNImageRectForNormalizedRect(
                    flippedBox,
                    Int(currentImage.size.width),
                    Int(currentImage.size.height)
                )
                let confidence = result.confidence
                let label: String = result.labels.first?.identifier ?? "Unknown"
                let detection = Detection(
                    box: box,
                    confidence: confidence,
                    label: label,
                    color: labelColor(with: label)
                )
                detections.append(detection)
                objectCount[label, default: 0] += 1
            }
            
            // Update the image with drawing bouning boxes
            let drawdImage = self.drawDetectionsOnImage(currentImage, detections: detections)
            
//            // Update the table count per object
//            var detectionWithCounts: [DetectionWithCount] = []
//            for (name, count) in objectCount {
//                print("Object: \(name), with count: \(count)")
//                detectionWithCounts.append(DetectionWithCount(name: name, count: count))
//            }
            
            // emit value
            self.result?(["data" : objectCount,
                    "img": drawdImage?.pngData()
                   ])
        }
    }
    
    func detect2(image :UIImage, result : @escaping FlutterResult) {
        self.result = result
        self.currentImage = image
        visionSendRequest(image: image)
    }
    
    private func visionSendRequest(image: UIImage){
        guard let request = request else { fatalError() }
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }
}

extension ObjectDetectManager{
    func drawDetectionsOnImage(_ inputImage: UIImage, detections: [Detection]) -> UIImage? {
        // Create a graphics context
        UIGraphicsBeginImageContextWithOptions(inputImage.size, false, inputImage.scale)
        
        // Draw the input image
        inputImage.draw(at: .zero)
        
        // Get the current graphics context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let size = inputImage.size
        // Loop through the rectangles and draw them
        for detection in detections {
            context.setStrokeColor(detection.color.cgColor)
            context.setLineWidth(6)
            context.stroke(detection.box)
            
            let labelText = "\(detection.label!) : \(round(detection.confidence*100))"
                    
            let textRect = CGRect(
                x: detection.box.origin.x,
                y: detection.box.origin.y - size.height * 0.04,
                width: detection.box.width,
                height: size.height * 0.1
            )
            
            let textFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: detection.box.width * 0.12, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            
            let attributedText = NSAttributedString(string: labelText, attributes: textFontAttributes)
            attributedText.draw(in: textRect)
        }
        
        // Create an image from the context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the graphics context
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
