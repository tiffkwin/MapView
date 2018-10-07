//
//  Intro.swift
//  MapNC
//
//  Created by Tiff on 10/6/18.
//  Copyright © 2018 Tiff. All rights reserved.
//

import UIKit
import Foundation
import MapKit

struct LocManager {
    static let locManager = CLLocationManager()
}

class Intro: UIViewController{
    @IBAction func goButton(_ sender: Any) {
        performSegue(withIdentifier: "ToViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocManager.locManager.requestWhenInUseAuthorization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToViewController"{
            let viewController = segue.destination as! ViewController
        viewController.title = "Home"
    }
}

    
}
