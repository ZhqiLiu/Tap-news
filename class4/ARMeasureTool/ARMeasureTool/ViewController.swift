//
//  ViewController.swift
//  ARMeasureTool
//
//  Created by Yichi Zhang on 4/4/18.
//  Copyright © 2018 Yichi Zhang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodeList = [SCNNode]()
    var prevTextNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // 寻找并显示平面
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched!")
        
        //touches: A set of UITouch instances that represent the touches for the starting phase of the event, which is represented by event. For touches in a view, this set contains only one touch by default.
        if let position2D = touches.first?.location(in: self.sceneView) {
            let hitTestResults = sceneView.hitTest(position2D, types: .featurePoint)
            if let position3D = hitTestResults.first {
                addOnTheScene(at: position3D)
            }

        }
    }
    
    func addOnTheScene(at position3D: ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.002)
        
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.blue
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(position3D.worldTransform.columns.3.x, position3D.worldTransform.columns.3.y, position3D.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        nodeList.append(dotNode)
        
        if nodeList.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = nodeList[nodeList.count - 1]
        let end = nodeList[nodeList.count - 2]
        
        let dist = sqrt(pow(end.position.x - start.position.x, 2) + pow(end.position.y - start.position.y, 2) + pow(end.position.z - start.position.z, 2))
        
        print("distance: \(dist)")
        showDist(dist: dist, endPosition: end.position)
    }
    
    func showDist(dist: Float, endPosition: SCNVector3) {
        if prevTextNode != nil {
            prevTextNode!.removeFromParentNode()
        }
        
        let text3D = SCNText(string: "distance is \(dist) meters", extrusionDepth: 0.9)
        text3D.firstMaterial?.diffuse.contents = UIColor.red
        
        let textNode = SCNNode(geometry: text3D)
        textNode.position = SCNVector3(endPosition.x + 0.01, endPosition.y, endPosition.z - 0.2)
        textNode.scale = SCNVector3(0.008, 0.008, 0.008)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        prevTextNode = textNode
        
    }


}
