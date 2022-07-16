import UIKit

import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var choosenImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var resultLabel2: UILabel!
    var choosenCImage : CIImage? = nil
    @IBAction func belirleClicked(_ sender: Any) {
        let picker=UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let ciImage = CIImage(image: image.image!){
            choosenImage = ciImage
        }
        recognizeImage(images: choosenImage)
        
        
    }
    func recognizeImage(images : CIImage){
        resultLabel2.text="Finding"
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                if let results = vnrequest.results as? [VNClassificationObservation]{
                    if (results.count > 0){
                        let topResult = results.first
                        DispatchQueue.main.async {
                            let confidenceLvl = (topResult?.confidence ?? 0) * 100
                            let rounded = Int(confidenceLvl*100) / 100
                            self.resultLabel2.text = "\(rounded)% it is a \(topResult?.identifier)"
                            print(topResult?.identifier)
                        }
                    }
                }
                    
                
            }
            let handler = VNImageRequestHandler(ciImage: images)
            DispatchQueue.global(qos: .userInteractive).async {
                try? handler.perform([request])
            }
        }
    }
    
    
    
    
    
    


}

