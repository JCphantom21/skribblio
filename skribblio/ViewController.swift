//
//  ViewController.swift
//  skribblio
//
//  Created by Jack Chen on 7/13/20.
//  Copyright © 2020 Jack Chen. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {


    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var draw: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var lines: [SCNVector3] = []
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
            //print("rendering")
            guard let pointOfView = sceneView.pointOfView else {return}
            let transform = pointOfView.transform
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let location = SCNVector3(transform.m41, transform.m42, transform.m43)
            let currentPositionOfCamera = orientation + location

            DispatchQueue.main.async {
                //if self.s {
                if self.draw.isHighlighted {
                    let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                    sphereNode.position = currentPositionOfCamera
                    self.sceneView.scene.rootNode.addChildNode(sphereNode)
                    sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                    self.lines.self.append(currentPositionOfCamera)
                    
                } else{
                    let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                    pointer.name = "pointer"
                    pointer.position = currentPositionOfCamera
                    self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                        if node.name == "pointer" {
                            node.removeFromParentNode()
                        }
                    })
                    self.sceneView.scene.rootNode.addChildNode(pointer)
                    pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.white

                }
            }
        }
    


}

//Create the '+' operator to accomadate for the vectors' x, y & z coordinates
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
