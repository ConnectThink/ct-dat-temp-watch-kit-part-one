//
//  ViewController.swift
//  weatherWatchKit
//
//  Created by Matthew Lathrop on 1/12/15.
//  Copyright (c) 2015 Connect Think. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate let weatherService: WeatherServiceProtocol = OpenWeatherMapWeatherService()
    
    // MARK: -
    
    @IBAction func refreshButtonTouchUpInside(_ sender: AnyObject) {
        updateCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCurrentLocation()
    }
    
    // MARK: - Location Handling
    
    fileprivate func updateCurrentLocation() {
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        if let coordinate = manager.location?.coordinate {
            print("location = \(coordinate.latitude) \(coordinate.longitude)")
            updateTemperatureWithCoordinate(coordinate)
        }
    }
    
    // MARK: Temperture Handling
    
    fileprivate func updateTemperatureWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
        weatherService.retrieveTemperatureAtCoordinate(coordinate,
            success: { (temp) -> () in
                let temperature = Int(temp)
                self.temperatureLabel.text = "\(temperature)"
            },
            failure: { (errorMessage) -> () in
                print(errorMessage)
        })
    }
}

