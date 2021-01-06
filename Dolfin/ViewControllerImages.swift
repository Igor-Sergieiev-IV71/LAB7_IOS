//
//  ViewControllerImages.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class ViewControllerImages: UIViewController {
    var images: [UIImage] = []
    var activitySpinner = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonBarAddPicture: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        activitySpinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activitySpinner)
        activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activitySpinner.startAnimating()
        fetchPixabayAPI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePickerController))
    }
    
    public func fetchPixabayAPI() {
        let urlApi = "https://pixabay.com/api/?key=19193969-87191e5db266905fe8936d565&q=red+cars&image_type=photo&per_page=21"
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        if let arrayImg = myJson["hits"] as? [NSDictionary] {
                            for data in arrayImg {
                                if let newImg = data["largeImageURL"] {
                                    let imageUrl = String(describing: newImg)
                                    let url = URL(string: imageUrl)
                                    let data = try? Data(contentsOf: url!)
                                    self.images.append(UIImage(data: data!)!)
                                }
                            }
                        }
                    }
                    catch {
                        print("Error")
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activitySpinner.stopAnimating()
            }
        }
        task.resume()
    }
}

extension ViewControllerImages: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as? ImagesCollectionViewCell else {
            fatalError("Fatal error")
        }
        let image = images[indexPath.item]
        cell.photoView.image = image
        
        return cell
    }
}

extension ViewControllerImages: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc fileprivate func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage]
        images.append(originalImage as! UIImage)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
