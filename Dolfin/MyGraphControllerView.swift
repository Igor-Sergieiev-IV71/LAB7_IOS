//
//  MyGraphControllerView.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class MyGraphControllerView: UIViewController {
    
    var dependence: ((Double) -> Double)? { didSet { refreshGraph() } }
    @IBOutlet weak var viewGraph: MyGraphView!
    @IBOutlet weak var viewChart: MyChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func chooseView(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewGraph.isHidden = false
            viewChart.isHidden = true
        case 1:
            viewGraph.isHidden = true
            viewChart.isHidden = false
        default:
            break
        }
    }
    
    func refreshGraph() {
        viewGraph.dependence = dependence
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dependence = { log($0) }
    }
}
