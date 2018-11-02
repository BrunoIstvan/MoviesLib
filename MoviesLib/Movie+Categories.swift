//
//  Movie.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 21/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//


import Foundation

extension Movie {
    var categoriesString: String {
        if let categories = categories {
            return Array(categories).map({($0 as! Category).name ?? ""}).joined(separator: " | ")
        } else {
            return ""
        }
        
    }
}














