//
//  ShowDetailViewController.swift
//  WeatherInformation
//
//  Created by Indiawyn Gaming on 06/09/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var main: UILabel!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var timezone: UILabel!
    var data : wmodel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main.text = data.current.weather[0].main
        discription.text = data.current.weather[0].description
        timezone.text = data.timezone
    }

}
