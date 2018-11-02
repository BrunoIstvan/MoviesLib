//
//  UIViewController+CoreData.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 30/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
