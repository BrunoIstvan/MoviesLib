//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 02/08/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColors: UISegmentedControl!
    @IBOutlet weak var swAutoplay: UISwitch!
    @IBOutlet weak var tfCategory: UITextField!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scColors.selectedSegmentIndex = ud.integer(forKey: "color")
        swAutoplay.setOn(ud.bool(forKey: "autoplay"), animated: false)
        tfCategory.text = ud.string(forKey: "category")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        saveCategory()
    }
    
    func saveCategory() {
        view.endEditing(true)
        ud.set(tfCategory.text!, forKey: "category")
    }
    

    @IBAction func changeColor(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        ud.set(index, forKey: "color")
    }
    
    @IBAction func changeAutoplay(_ sender: UISwitch) {
        ud.set(sender.isOn, forKey: "autoplay")
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveCategory()
        return true
    }
}












