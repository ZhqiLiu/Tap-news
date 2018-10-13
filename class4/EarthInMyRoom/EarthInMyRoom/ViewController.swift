//
//  ViewController.swift
//  EarthInMyRoom
//
//  Created by Yichi Zhang on 4/4/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let sphere = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/2_no_clouds_8k.jpg")
        sphere.materials = [material]
        
        let light = SCNLight()
        light.type = .omni
        light.intensity = 3000
        light.temperature = 3000
        
        // Create a new SCNNode
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0, z: -0.3)
        node.geometry = sphere
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: -1, y: 0, z: -0.3)
        
        // Set the scene to the view
        // sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        // 自转
        node.runAction(SCNAction.rotate(by: 360, around: SCNVector3(x: 0.5, y: 1, z: 0), duration: 1000))
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

}
