import UIKit
import Foundation

fileprivate struct Config {
    static let reuseIdentifier = "FlowerCell"
    static let segueIdentifier = "ShowFlowerDetail"
    static let fileName = "flowers.txt"
    static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    static let itemsPerRow: CGFloat = 3
}

class FlowerCollectionViewController: UICollectionViewController {
    
    var imageFileNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageFileNames()
    }
    
    private func setupView() {
        collectionView?.allowsMultipleSelection = false
    }
    
    private func setupImageFileNames() {
        imageFileNames = arrayFromContentsOfFileWithName(fileName: Config.fileName)
    }
    
    private func arrayFromContentsOfFileWithName(fileName: String) -> [String] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            fatalError("Resource file for \(fileName) not found.")
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n").filter { !($0.isEmpty) }
        } catch {
            fatalError("Could not load strings from \(path): \(error).")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.segueIdentifier {
            if let flowerDetailsVC = segue.destination as? FlowerDetailsViewController {
                guard let indexPath = collectionView?.indexPathsForSelectedItems?.first else {
                    fatalError("Could not retrieve index path for selected cell.")
                }
                flowerDetailsVC.imageFileName = imageFileNames[indexPath.row]
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension FlowerCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return imageFileNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.reuseIdentifier,
                                                      for: indexPath) as! FlowerCell
        
        let imageFileName = imageFileNames[indexPath.row]
        cell.backgroundColor = UIColor.gray
        cell.imageView.image = UIImage(named: imageFileName)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension FlowerCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Config.segueIdentifier, sender: nil)
    }
}

extension FlowerCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Config.sectionInsets.left * (Config.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Config.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Config.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.sectionInsets.left
    }
}

