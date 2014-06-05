//
//  GameViewController.swift
//  SceneKit
//
//  Created by Nikolas on 05.06.14.
//  Copyright (c) 2014 Nikolas. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0.4)
        
        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light.type = SCNLightTypeOmni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light.type = SCNLightTypeAmbient
//        ambientLightNode.light.color = UIColor.darkGrayColor()
//        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a 3d box to the scene
        let boxNode = SCNNode()
        boxNode.geometry = SCNSphere(radius: 1)
        boxNode//        boxNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.02)
        boxNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(boxNode)
        
        // create and configure a material
        let material1 = SCNMaterial()
        var imageForTexture1: UIImage = UIImage(named: "tile.jpg")
        material1.doubleSided = true
        material1.diffuse.contents = imageForTexture1
        material1.specular.contents = UIColor.grayColor()
        material1.locksAmbientWithDiffuse = true

//        let material2 = SCNMaterial()
//        var imageForTexture2: UIImage = UIImage(named: "tile2.jpg")
//        material2.diffuse.contents = imageForTexture2
//        material2.specular.contents = UIColor.grayColor()
//        material2.locksAmbientWithDiffuse = true

        // set the material to the 3d object geometry
//        boxNode.geometr
        boxNode.geometry.materials = [material1]
//        boxNode.geometry.materials = [imageForTexture, imageForTexture, imageForTexture, imageForTexture, imageForTexture, imageForTexture]

        // animate the 3d object
//        let animation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
//        animation.toValue = NSValue(SCNVector4: SCNVector4(x: 1, y: 1, z: 0, w: Float(M_PI)*2))
//        animation.duration = 5
//        animation.repeatCount = MAXFLOAT //repeat forever
//        boxNode.addAnimation(animation, forKey: nil)

        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        gestureRecognizers.addObjectsFromArray(scnView.gestureRecognizers)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry.firstMaterial
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
