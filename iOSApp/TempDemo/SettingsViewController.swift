//
//  SettingsViewController.swift
//  TempDemo
//
//  Created by John Cottrell on 12/4/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var samplesTextField: UITextField!
    @IBOutlet weak var divisorTextField: UITextField!
    
    let defaults = UserDefaults.standard
    var name: String?
    var host: String?
    var samples: String?
    var divisor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = defaults.string(forKey: "name")
        host = defaults.string(forKey: "host")
        samples = defaults.string(forKey: "samples")
        divisor = defaults.string(forKey: "divisor")
        
        nameTextField.text = name
        hostTextField.text = host
        samplesTextField.text = samples
        divisorTextField.text = divisor
        
        self.nameTextField.delegate = self
        self.hostTextField.delegate = self
        self.samplesTextField.delegate = self
        self.divisorTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveSettings()
    }
    
    @IBAction func saveSettingsButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        saveSettings()
    }
    
    func saveSettings() {
        if  nameTextField.text != name ||
            hostTextField.text != host ||
            samplesTextField.text != samples ||
            divisorTextField.text != divisor {
            defaults.set(nameTextField.text, forKey: "name")
            defaults.set(hostTextField.text, forKey: "host")
            defaults.set(samplesTextField.text, forKey: "samples")
            defaults.set(divisorTextField.text, forKey: "divisor")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


