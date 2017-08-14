//
//  ViewController.swift
//  MotionTest
//
//  Created by Sami Rämö on 10/08/2017.
//  Copyright © 2017 Sami Ramo. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var directionControl: UISegmentedControl!
    
    private var isTracking = false
    
    private var altitude = 0.0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            altitudeLabel.text = formatter.string(from: NSNumber(value: altitude))! + " m"
        }
    }
    
    private var altimeter = CMAltimeter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetPosition()
        startButton.layer.cornerRadius = startButton.frame.width / 2
        if !CMAltimeter.isRelativeAltitudeAvailable() {
            startButton.isEnabled = false
            startButton.setTitle("ERROR", for: .normal)
            startButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func bigButtonPressed(_ sender: UIButton) {
        if isTracking {
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = UIColor(red: 0.0, green: 164/255, blue: 0.0, alpha: 1.0)
            stopTracking()
        } else {
            startButton.setTitle("STOP", for: .normal)
            startButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            startTracking()
        }
        isTracking = !isTracking
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetPosition()
    }
    
    func resetPosition() {
        altitude = 0.0
        //CMAltimeter
    }
    
    func startTracking() {
        print("Tracking started")
        directionControl.isEnabled = false
        altimeter.startRelativeAltitudeUpdates(to: .main, withHandler: { data, error in
            if data != nil {
                print(data!.relativeAltitude)
                if self.directionControl.selectedSegmentIndex == 0 {
                    if data!.relativeAltitude.doubleValue > self.altitude {
                        self.altitude = data!.relativeAltitude.doubleValue
                    }
                } else {
                    if data!.relativeAltitude.doubleValue < self.altitude {
                        self.altitude = data!.relativeAltitude.doubleValue
                    }
                }
            }
        })
    }
    
    func stopTracking() {
        print("Tracking stopped")
        directionControl.isEnabled = true
        altimeter.stopRelativeAltitudeUpdates()
    }
}

