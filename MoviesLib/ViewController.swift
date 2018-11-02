//
//  ViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 14/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = movie.title
        lbCategories.text = movie.categoriesString
        lbDuration.text = movie.duration
        lbRating.text = "⭐️ \(movie.rating)/10"
        ivMovie.image = movie.image as? UIImage
        tvSummary.text = movie.summary
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieRegisterViewController {
            vc.movie = movie
        }
    }



}

