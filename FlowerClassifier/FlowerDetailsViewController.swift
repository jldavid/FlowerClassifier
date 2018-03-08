import UIKit

class FlowerDetailsViewController: UIViewController {
    
    var imageFileName: String!

    let model = FlowerClassifier()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        imageView.image = UIImage(named: imageFileName)
        
        let output = classifyFlower()
        let probability = Int(output.prob[output.classLabel]! * 100)
        let emoji = emojiBasedOnProbability(probability)
        outputLabel.text = "I'm \(probability)% sure it's a \(output.classLabel)! \(emoji)"
    }
    
    private func classifyFlower() -> FlowerClassifierOutput {
        guard let image = imageView.image else {
            fatalError("No image specified.")
        }
        let scaledImage = image.scaleImage(newSize: CGSize.init(width: 227.0, height: 227.0))
        let buffer = scaledImage!.buffer()!
        guard let output = try? model.prediction(data: buffer) else {
            fatalError("Prediction process failed.")
        }
        return output
    }
    
    private func emojiBasedOnProbability(_ probability: Int) -> String {
        var emoji = ""
        if probability > 95 {
            emoji = "😎"
        } else if probability > 80 {
            emoji = "😉"
        } else if probability > 70 {
            emoji = "🤔"
        } else if probability > 50 {
            emoji = "😒"
        } else if probability > 30 {
            emoji = "😣"
        } else {
            emoji = "😫"
        }
        return emoji
    }
}

