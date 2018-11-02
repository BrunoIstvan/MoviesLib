//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 30/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            tfTitle.text = movie.title
            tfDuration.text = movie.duration
            tfRating.text = "\(movie.rating)"
            ivPoster.image = movie.image as? UIImage
            tvSummary.text = movie.summary
            btAddEdit.setTitle("Atualizar", for: .normal)
        } else {
            movie = Movie(context: context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbCategories.text = movie.categoriesString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoriesTableViewController {
            vc.movie = movie
        }
    }

    @IBAction func addEditMovie(_ sender: UIButton) {
        movie.title = tfTitle.text!
        movie.rating = Double(tfRating.text!)!
        movie.duration = tfDuration.text!
        movie.summary = tvSummary.text
        movie.image = ivPoster.image
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MovieRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            ivPoster.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}









