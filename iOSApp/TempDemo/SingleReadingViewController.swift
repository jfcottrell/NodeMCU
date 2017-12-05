//
//  SingleReadingViewController.swift
//  TempDemo
//
//  Created by John Cottrell on 12/4/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import Foundation
import UIKit

class SingleReadingViewController: UIViewController {
    
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateReadings()
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateReadings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateReadings() {
        
        let urlString: String = "http://69.164.201.31/esp_get.php?records=1"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            //let str = String(data: data, encoding: .utf8)
            
            do {
                let temps:[Temp] = try JSONDecoder().decode([Temp].self, from: data)
                var val: Double = 0.0
                var timestamp: String = ""
                
                for temp in temps {
                    val = Double(temp.value)!
                    timestamp = temp.ts
                }
                
                DispatchQueue.main.async {
                    let readingString:String = "\(Int(val)) ºF"
                    self.readingLabel.text = readingString
                    self.timestampLabel.text = timestamp
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
