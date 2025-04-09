//
//  ViewController.swift
//  MLiOSBasics
//
//  Created by Rahul Padmakumar on 09/04/25.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var cameraImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func onCameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            cameraImageView.image = pickedImage
            if let ciImage = CIImage(image: pickedImage){
                detectImage(ciImage)
            }
        }
        imagePicker.dismiss(animated: true)
    }

    func detectImage(_ image: CIImage){
        
        if let model = try? VNCoreMLModel(for: MobileNet(configuration: MLModelConfiguration()).model){
            let request = VNCoreMLRequest(model: model) { req, error in
                if(error != nil){
                    print(error?.localizedDescription ?? "")
                }
                if let results = (req.results as? [VNClassificationObservation])?.first{
                    print(results.identifier)
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            do{
                try handler.perform([request])
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

