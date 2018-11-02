//
//  CategoriesTableViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 30/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    var categories: [Category] = []
    var movie: Movie!
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        showAlert(category: nil)
    }
    
    
    func showAlert(category: Category?) {
        
        let title = category == nil ? "Adicionar" : "Atualizar"
        
        let alert = UIAlertController(title: title, message: "Preencha a categoria abaixo", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let categoryName = alert.textFields![0].text!
            let cat = category ?? Category(context: self.context)
            cat.name = categoryName
            try! self.context.save()
            self.loadCategories()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da categoria"
            textField.text = category?.name
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    func loadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        categories = try! context.fetch(fetchRequest)
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.accessoryType = .none
        if let categories = movie.categories, categories.contains(category) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action, indexPath) in
            let category = self.categories[indexPath.row]
            self.context.delete(category)
            try! self.context.save()
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Editar") { (action, indexPath) in
            let category = self.categories[indexPath.row]
            self.showAlert(category: category)
            tableView.setEditing(false, animated: true)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            movie.removeFromCategories(category)
        } else {
            cell.accessoryType = .checkmark
            movie.addToCategories(category)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
