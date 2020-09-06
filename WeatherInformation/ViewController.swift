//
//  ViewController.swift
//  WeatherInformation
//
//  Created by Indiawyn Gaming on 06/09/20.
//  Copyright © 2020 myorg. All rights reserved.
// API Key 897f94b9e0a3b7f7673c35779056f9cf


import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var data : wmodel!
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ShowDetailViewController
        vc.data = data
        self.dismiss(animated: false, completion: nil)
    }
    
    func MakeAlert(){
        let alert = UIAlertController(title: "Alert", message: "Please Connect To Internet!.", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
//1
extension ViewController: CLLocationManagerDelegate,GMSMapViewDelegate {
  // 2
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.startUpdatingLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
    
    // 8
    locationManager.stopUpdatingLocation()
  }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        self.showSpinner(onView: self.view)
        if Reachability.isConnectedToNetwork() {
            WeatherApiCall.getData(long: coordinate.longitude, lat: coordinate.latitude, suceess: { rep in
            print(rep!)
            self.data = rep!
            self.removeSpinner()
            self.performSegue(withIdentifier: "toDetails", sender: nil)

                
        }, error: { error in
            print(error!)
            self.removeSpinner()
        })
        }else{
           MakeAlert()
        }
    
    }
    
    func loading(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

}
extension ViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
