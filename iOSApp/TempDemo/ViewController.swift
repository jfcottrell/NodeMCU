//
//  ViewController.swift
//  TempDemo
//
//  Created by John Cottrell on 12/1/17.
//  Copyright © 2017 John Cottrell. All rights reserved.
//

import UIKit
import Charts

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var values = [Double]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return times[Int(value)]
    }
    
    public func setValues(values: [Double]) {
        self.values = values
    }
}

struct TempArray: Decodable {
    let data: [Temp]
}

struct Temp: Codable {
    let ts: String
    let value: String
}

var numbers = [Double]()
var times = [String]()

class ViewController: UIViewController {

    @IBOutlet weak var chtChart: LineChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Style chart
        chtChart.drawMarkers = false
        chtChart.animate(yAxisDuration: 2.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        let defaults = UserDefaults.standard
        let optionalHost = defaults.string(forKey: "host")
        let optionalSamples = defaults.string(forKey: "samples")
        
        guard let host = optionalHost else {
            
            let alert = UIAlertController(title: "Error", message: "The Host is not set. Please update the host name in settings.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let samples = optionalSamples else {return}
        
        chtChart.clear()
        numbers.removeAll()
        times.removeAll()
        chtChart.chartDescription?.text = defaults.string(forKey: "name")
    
        let urlString = "http://\(host)/esp_get.php?records=\(samples)"
        
        print("urlString = \(urlString)")
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        guard let data = data else { return }

            do {
                let temps:[Temp] = try JSONDecoder().decode([Temp].self, from: data)
                
                var index = 0
                
                for temp in temps {
                    let val = Double(temp.value)
                    if index % 100 == 0 {
                        numbers.append(val!)
                        index = 0
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: temp.ts)
                        let calendar = Calendar.current
                        let comp = calendar.dateComponents([.hour, .minute], from: date!)
                        let hour = comp.hour
                        let minute = comp.minute
                        //let dateString: String = "\(hour! + 1):\(minute!)"
                        let dateString: String = String(format:"%d:%02d", hour!, minute!)
                        times.append(dateString)
                    }
                    index += 1
                }
                
                DispatchQueue.main.async {
                    self.updateGraph()
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y:Double(numbers[i]))
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Temp (ºF)")
        line1.colors = [NSUIColor.blue]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier

        let data = LineChartData()
        data.addDataSet(line1)
        
        // Axes setup
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: numbers)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.valueFormatter = xaxis.valueFormatter
        chtChart.data = data
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getData()
    }
}
