//
//  ViewController.swift
//  Pango
//
//  Created by Chen Zhang on 8/2/14.
//  Copyright (c) 2014 Chen Zhang. All rights reserved.
//

import UIKit
import SceneKit
import QuartzCore

class ViewController: UIViewController {
                            
    @IBOutlet weak var sceneView: SCNView!
//    var panRecognizer : UIPanGestureRecognizer!
    var panGestureStart : CGPoint?
    var rotateGestureStart : CGPoint?
    var pinchGestureStart : CGFloat?
    var rotateGesture2Start : CGFloat?
    var initialTransform : SCNMatrix4?
    var model = SCNNode()
    let cameraNode = SCNNode()
    var cameraPosition : SCNVector3!
    //var camera = SCNCamera()
    
    
    func installRecognizers() {
        var panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        panRecognizer.minimumNumberOfTouches = 2
        sceneView.addGestureRecognizer(panRecognizer)
        
        var rotateRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleRotate:"))
        rotateRecognizer.maximumNumberOfTouches = 1
        sceneView.addGestureRecognizer(rotateRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinch:"))
        sceneView.addGestureRecognizer(pinchRecognizer)
        
        let rotateRecognizer2 = UIRotationGestureRecognizer(target: self, action: Selector("handleRotate2:"))
        sceneView.addGestureRecognizer(rotateRecognizer2)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        installRecognizers()
        let scene = SCNScene()
        
        // Camera
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 30)
        scene.rootNode.addChildNode(cameraNode)
        
        // Camera constraints
        
        let lookAt = SCNLookAtConstraint(target: model)
        cameraNode.constraints = [lookAt]

        // Ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light.type = SCNLightTypeAmbient
        ambientLight.light.color = UIColor(white: 0.1, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // Diffuse light
        let diffuseLight = SCNNode()
        diffuseLight.light = SCNLight()
        diffuseLight.light.type = SCNLightTypeOmni
        diffuseLight.position = SCNVector3Make(-30, 50, 50)
//        diffuseLight.light.color = UIColor(white: 0.1, alpha: 1.0)
        scene.rootNode.addChildNode(diffuseLight)
        
        
        func configureMaterialProperty(materialProperty: SCNMaterialProperty) {
            materialProperty.minificationFilter = .Linear
            materialProperty.magnificationFilter = .Linear
            materialProperty.mipFilter = .Linear
        }
        let material = SCNMaterial()
        configureMaterialProperty(material.ambient)
        configureMaterialProperty(material.diffuse)
        configureMaterialProperty(material.specular)
        configureMaterialProperty(material.emission)
        configureMaterialProperty(material.transparent)
        configureMaterialProperty(material.reflective)
        configureMaterialProperty(material.multiply)
        configureMaterialProperty(material.normal)
        
        let floor = SCNNode()
        floor.geometry = SCNFloor()
        floor.position = SCNVector3Make(0, -3, 0)
        scene.rootNode.addChildNode(floor)
        
        
        let modelNode = model
//        modelNode.geometry = SCNSphere(radius: 5.0)
        modelNode.geometry = SCNBox(width: 4.0, height: 4.0, length: 4.0, chamferRadius: 0.4)
        modelNode.geometry.materials = [material]
        scene.rootNode.addChildNode(modelNode)
        sceneView.scene = scene
        sceneView.contentMode = .ScaleAspectFit
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.sceneView.setNeedsDisplay()
    }

    @objc func handlePan(recognizer: UIGestureRecognizer!) {
        if let r = recognizer as? UIPanGestureRecognizer {
            switch r.state {
            case .Began:
                break
            case .Changed:
                break
            case .Cancelled:
                break
            case .Ended:
                break
            default:
                break
            }
        }
    }

    var cosA : Float!
    var sinA : Float!

    @objc func handleRotate(recognizer: UIGestureRecognizer!) {
        let rotationFactor : Float = 0.03
        if let r = recognizer as? UIPanGestureRecognizer {
            switch r.state {
            case .Began:
                rotateGestureStart = r.locationInView(self.view)
                cameraPosition = cameraNode.position
                cosA = cameraNode.position.z/30.0
                sinA = cameraNode.position.x/30.0
                break
            case .Changed:
                let point = r.locationInView(self.view)
                let dx : Float = Float(point.x - rotateGestureStart!.x)

                let cosB = cos(-dx * rotationFactor)
                let sinB = sin(-dx * rotationFactor)
                
                cameraNode.position = SCNVector3Make(30 * (sinA * cosB + cosA * sinB) , 0, 30 * (cosA * cosB - sinA * sinB))
                
                break
//            case .Cancelled:
//                rotateGestureStart = nil
//                model.transform = initialTransform!
//                break
            case .Ended:
                rotateGestureStart = nil
                cameraPosition = cameraNode.position
                break
            default:
                break
            }
        }
    }
//    @objc func handleRotate(recognizer: UIGestureRecognizer!) {
//        let rotationFactor : Float = 0.03
//        if let r = recognizer as? UIPanGestureRecognizer {
//            switch r.state {
//            case .Began:
//                rotateGestureStart = r.locationInView(self.view)
//                initialTransform = model.transform
//                break
//            case .Changed:
//                let point = r.locationInView(self.view)
//                let dx : Float = Float(point.x - rotateGestureStart!.x)
//                let dy : Float = Float(point.y - rotateGestureStart!.y)
////                let dx : CGFloat = point.x - rotateGestureStart!.x
////                let dy : CGFloat = point.y - rotateGestureStart!.y
//                
//                let rotY = SCNMatrix4MakeRotation(dx * rotationFactor, 0, 1, 0)
//                let rotX = SCNMatrix4MakeRotation(dy * rotationFactor, 1, 0, 0)
//                let rotation = SCNMatrix4Mult(rotY, rotX)
//                
//                model.transform = SCNMatrix4Mult(initialTransform!, rotation)
//                
//                break
//            case .Cancelled:
//                rotateGestureStart = nil
//                model.transform = initialTransform!
//                break
//            case .Ended:
//                rotateGestureStart = nil
//                initialTransform = model.transform
//                break
//            default:
//                break
//            }
//        }
//    }

    @objc func handlePinch(recognizer: UIPinchGestureRecognizer!) {
        let pinchFactor : Float = 0.04
        switch recognizer.state {
        case .Began:
            pinchGestureStart = recognizer.scale
            initialTransform = model.transform
            break
        case .Changed:
            let scale = Float(recognizer.scale)
            let zoom = SCNMatrix4MakeScale(scale, scale, scale)
            model.transform = SCNMatrix4Mult(initialTransform!, zoom)
            break
        case .Cancelled:
            model.transform = initialTransform!
            pinchGestureStart = nil
            break
        case .Ended:
            pinchGestureStart = nil
            initialTransform = model.transform
            break
        default:
            break
        }
        
    }
    
    @objc func handleRotate2(recognizer: UIRotationGestureRecognizer!) {
        let rotate2Factor = 0.03
        switch recognizer.state {
        case .Began:
            rotateGesture2Start = recognizer.rotation
            initialTransform = model.transform
            break
        case .Changed:
            let rotation = SCNMatrix4MakeRotation(Float(recognizer.rotation - rotateGesture2Start!), 0, 0, -1)
            model.transform = SCNMatrix4Mult(initialTransform!, rotation)
            break
        case .Cancelled:
            rotateGesture2Start = nil
            model.transform = initialTransform!
            break
        case .Ended:
            rotateGesture2Start = nil
            initialTransform = model.transform
            break
        default:
            break
        }
    }
}

