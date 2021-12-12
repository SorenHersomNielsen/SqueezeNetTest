//
//  ViewController.swift
//  SqueezeNetTest
//
//  Created by Søren Nielsen on 08/12/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var identificere: UILabel!
    
    @IBOutlet weak var probabilty: UILabel!
    
    @IBAction func ChooseButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        analyseImage(image: image)
        showImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func analyseImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 227, height:227))?.getCVPixelBuffer() else {
            return
        }
        let model = SqueezeNet()
        guard let output = try? model.prediction(image: buffer) else { return}
        
        let classlabel = output.classLabel
        let classlabelprobs = output.classLabelProbs
        
        var ModelsProbability: Double {
            let probabilty = classlabelprobs[classlabel] ?? 0.0
            let probabiltyXWith100 = (probabilty * 100)
            
            return probabiltyXWith100
        }
        identificere.text = "The obejct is identify as: \(classlabel)"
        probabilty.text = "The probabilty is: \(ModelsProbability)"
    }
}

