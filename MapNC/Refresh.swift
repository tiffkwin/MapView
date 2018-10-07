//
//  ViewController.swift
//  MapNC
//
//  Created by Tiff on 10/6/18.
//  Copyright © 2018 Tiff. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GoogleMaps
import GooglePlaces

class RefreshViewController: UIViewController, ARSCNViewDelegate {
    
    let placesClient = GMSPlacesClient()
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func refreshButton(_ sender: Any) {
        self.view.setNeedsDisplay()
        //update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doStuff()
        
    }
    
    func addAnimation(node: SCNNode) {
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.02, z: 0, duration: 1.0)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.02, z: 0, duration: 1.0)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let repeatForever = SCNAction.repeatForever(hoverSequence)
        node.runAction(repeatForever)
    }
    
    func update(){
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        doStuff()
    }
    
    func doStuff(){
        
        // Set the view's delegate
        sceneView.delegate = self
        
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = LocManager.locManager.location
            let long = currentLocation.coordinate.longitude
            let lat = currentLocation.coordinate.latitude
            print(long)
            print(lat)
            
            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                if let placeLikelihoodList = placeLikelihoodList {
                    var num = 0
                    for likelihood in placeLikelihoodList.likelihoods {
                        let place = likelihood.place
                        print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        print("Current Place address \(String(describing: place.formattedAddress))")
                        print("Current Place attributions \(String(describing: place.attributions))")
                        print("Current PlaceID \(place.placeID)")
                        if(num == 0){
                            
                            let node = SCNNode()
                            let node2 = SCNNode()
                            let nodeStar = SCNNode()
                            
                            let text = SCNText(string: place.name, extrusionDepth: 2)
                            let rating = SCNText(string: String(place.rating), extrusionDepth: 2)
                            let material = SCNMaterial()
                            material.diffuse.contents = UIColor.blue
                            text.materials = [material]
                            rating.materials = [material]
                            
                            node.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.01)
                            node.geometry = text
                            
                            node2.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.01)
                            node2.geometry = rating
                            
                            let star = SCNText(string: "★", extrusionDepth: 2)
                            let materialStar = SCNMaterial()
                            materialStar.diffuse.contents = UIColor.yellow
                            star.materials = [materialStar]
                            
                            nodeStar.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.01)
                            nodeStar.geometry = star
                            
                            node.position = SCNVector3(x: -0.17, y: 0.01, z: -0.9)
                            node2.position = SCNVector3(x: 0.0, y: -0.1, z: -0.9)
                            nodeStar.position = SCNVector3(x: 0.1, y: -0.1, z: -0.9)
                            
                            self.sceneView.scene.rootNode.addChildNode(node)
                            self.sceneView.scene.rootNode.addChildNode(node2)
                            self.sceneView.scene.rootNode.addChildNode(nodeStar)
                            self.sceneView.autoenablesDefaultLighting = true
                            
                            self.addAnimation(node: nodeStar)
                            
                        }
                        num += 1
                    }
                }
            })
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*func renderer(_ renderer: SCNSceneRenderer,
     updateAtTime time: TimeInterval){
     
     }*/
    
    /*// Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }*/
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
