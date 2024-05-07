//
//  LoadingUIViewRepresentable.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//


import SwiftUI
import SceneKit

// only for preview， and it represents a swiftUI view that encapsulates a SceneKit view, typically used to display 3D content
struct LoadingUIViewRepresentable: View {
    var body: some View {
        BasicLoadingUIViewRepresentable(sceneName: "cloudy_night").frame(height: 350)
    }
}

#Preview {
    LoadingUIViewRepresentable()
}
// end of preview

// representative class
struct BasicLoadingUIViewRepresentable : UIViewRepresentable {
    
    let sceneName: String //Name of the scene to be loaded, which dictates the weather condition to display
    
    let sunshine = ["Cylinder_001", "Cylinder_002", "Cylinder_003", "Cylinder_004", "Cylinder_005", "Cylinder_006", "Cylinder_007", "Cylinder_008", "Cylinder_009", "Cylinder_010", "Cylinder_011", "Cylinder_012"] //Array of cylinder object names used in the "sunny" scene for shown
    //Creates the SceneKit view and configures it according to the sceneName
    func makeUIView(context: Context) -> SCNView {
        print(sceneName)
        let view = SCNView ()
        var scene = get3DModel(sceneName: sceneName)//Attempts to load a 3D model based on the sceneName
        if (scene == nil) {
            //If no model is found, try to load from the file
            scene = .init(named: "\(sceneName).scn")
            if (scene == nil) {
                view.backgroundColor = .clear//ensure the view is transparent if no scene is loaded
                return view
            }
        }
        //Basic SceneKit view configurations for better visual quality
        var rootOpacity = 1.0
        var opacityDuration = 1.0
        
        
//        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
    
        // Apply fade in effect,below are different animations and effects based on the sceneName
        view.scene?.rootNode.opacity = 0.0
        if (sceneName == "sunny") {
            rootOpacity = 0.1
            let fadeInAction = SCNAction.fadeOpacity(by: 0.2, duration: 0.5)
            view.scene?.rootNode.runAction(fadeInAction)
            for elt in sunshine {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
                    node.filters = addBloom(intensity: 0.2, radius: 5.0)
                    scaleAnimation(node: node, from: 1.0, to: 0.8)
                }
            }
            if let sun = view.scene?.rootNode.childNode(withName: "Sphere_001", recursively: true) {
                sun.filters = addBloom(intensity: nil, radius: nil)
                scaleAnimation(node: sun, from: 1.05, to: 1.1)
            }
        } else if (sceneName == "clear_moon") {
            if let moon_node = view.scene?.rootNode.childNode(withName: "crescent_moon", recursively: true) {
                moon_node.scale.x = 0.12
                moon_node.scale.y = 0.12
                moon_node.scale.z = 0.12
//                print("HEREE")
                moon_node.filters = addBloom(intensity: 0.5, radius: 7.0)
                rotationAnimation(node: moon_node)
            }
        } else if (sceneName == "cloudy") {
            opacityDuration = 0.4
            rootOpacity = 0.8
            if let cloud_node = view.scene?.rootNode.childNode(withName: "clear_cloud", recursively: true) {
                scaleAnimation(node: cloud_node, from: 1.387, to: 1.45)
                cloud_node.filters = addBloom(intensity: 0.1, radius: 4.0)
            }
        } else if (sceneName == "cloudy_fog") {
            opacityDuration = 0.4
            rootOpacity = 0.2
            if let cloud_node = view.scene?.rootNode.childNode(withName: "clear_cloud", recursively: true) {
                scaleAnimation(node: cloud_node, from: 1.387, to: 1.45)
                cloud_node.filters = addBloom(intensity: 1, radius: 10.0)
            }
        }
        else if (sceneName == "cloudy_night") {
            opacityDuration = 0.4
            for elt in ["stars_001", "stars_002", "stars_003", "stars_004"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.2, radius: 5.0)
                    starAnimation(node: node, direction: ((nb % 2) != 0))
                }
            }
            if let moon_node = view.scene?.rootNode.childNode(withName: "moon_night", recursively: true) {
                moon_node.filters = addBloom(intensity: 0.3, radius: 5.0)
            }
            if let cloud_node = view.scene?.rootNode.childNode(withName: "night_cloud", recursively: true) {
                scaleAnimation(node: cloud_node, from: 0.965, to: 1.0)
                cloud_node.filters = addBloom(intensity: 0.1, radius: 5.0)
            }
        } else if (sceneName == "partly_cloudy") {
            if let sun_node = view.scene?.rootNode.childNode(withName: "clean_sun", recursively: true) {
                sun_node.opacity = 0.8
                sun_node.filters = addBloom(intensity: 0.3, radius: 5.0)
                scaleAnimation(node: sun_node, from: 1.194, to: 1.3)
            }
        } else if (sceneName == "solo_snow") {
            if let solo_snow = view.scene?.rootNode.childNode(withName: "snowfall_001", recursively: true) {
                solo_snow.scale.x = 0.55
                solo_snow.scale.y = 0.55
                solo_snow.scale.z = 0.55
                rotationAnimation(node: solo_snow)
                scaleAnimation(node: solo_snow, from: 0.5, to: 0.55)
            }
        } else if (sceneName == "light_rain") {
            for elt in ["raindrop_1", "raindrop_2", "raindrop_3", "raindrop_4"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.2, radius: 3.0)
                    rainfallAnimation(node: node, speedIntervals: [1.5, 2.5])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "angry_rain") {
            for elt in ["raindrop_1_001", "raindrop_2_001", "raindrop_3_001", "raindrop_4_001"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.2, radius: 3.0)
                    rainfallAnimation(node: node, speedIntervals: [1.5, 2.5])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "heavy_rain") {
            for elt in ["raindrop_1_001", "raindrop_2_001", "raindrop_3_001", "raindrop_4_001","raindrop_1_002", "raindrop_2_002", "raindrop_3_002", "raindrop_4_002"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.opacity = 0.1
                    node.filters = addBloom(intensity: 0.1, radius: 2.0)
                    rainfallAnimation(node: node, speedIntervals: [0.5, 1.0])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "snowfall" || sceneName == "night_snowfall") {
            for elt in ["snowfall_005", "snowfall_006", "snowfall_007"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.1, radius: 3.0)
                    snowfallAnimation(node: node, speedIntervals: [2.5, 4.5])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "heavy_snow") {
            for elt in ["snowfall_004", "snowfall_005", "snowfall_006", "snowfall_007", "snowfall_008", "snowfall_009"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.1, radius: 2.0)
                    snowfallAnimation(node: node, speedIntervals: [1, 1.5])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "snowflake") {
            for elt in ["snowfall_001", "snowfall_002", "snowfall_003", "snowfall_004"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
                    rotationAnimation(node: node)
                    scaleAnimation(node: node, from: Double(node.scale.x) - 0.05, to: Double(node.scale.x))
                    node.filters = addBloom(intensity: 0.1, radius: 3.0)
//                    snowfallAnimation(node: node, speedIntervals: [2.5, 4.5])
                }
            }
        } else if (sceneName == "thunderstorm") {
//            Lightning_003
            if let lightning = view.scene?.rootNode.childNode(withName: "Lightning_003", recursively: true) {
                lightning.opacity = 0.8
                lightning.filters = addBloom(intensity: 0.3, radius: 5.0)
                scaleAnimation(node: lightning, from: 0.036, to: 0.040)
            }
        } else if (sceneName == "thunderstorm_with_hail") {
//            Lightning_003
            if let lightning = view.scene?.rootNode.childNode(withName: "Lightning_002", recursively: true) {
                lightning.opacity = 0.8
                lightning.filters = addBloom(intensity: 0.3, radius: 5.0)
                scaleAnimation(node: lightning, from: 0.024, to: 0.030)
            }
            for elt in ["raindrop_1_002", "raindrop_2_002", "raindrop_3_002", "raindrop_4_002"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.filters = addBloom(intensity: 0.2, radius: 3.0)
                    rainfallAnimation(node: node, speedIntervals: [1.5, 2.5])
//                    starAnimation(node: node, direction: false)
                }
            }
        } else if (sceneName == "big_thunderstorm_with_hail") {
//            Lightning_003
            if let lightning = view.scene?.rootNode.childNode(withName: "Lightning_002", recursively: true) {
                lightning.opacity = 0.8
                lightning.filters = addBloom(intensity: 0.3, radius: 5.0)
                scaleAnimation(node: lightning, from: 0.024, to: 0.030)
            }
            for elt in ["raindrop_1_003", "raindrop_2_003", "raindrop_3_003", "raindrop_4_003","raindrop_1_002", "raindrop_2_002", "raindrop_3_002", "raindrop_4_002"] {
                if let node = view.scene?.rootNode.childNode(withName: elt, recursively: true) {
//                    let nb = Int(elt.suffix(1))!
                    node.opacity = 0.1
                    node.filters = addBloom(intensity: 0.1, radius: 2.0)
                    rainfallAnimation(node: node, speedIntervals: [0.5, 1.0])
//                    starAnimation(node: node, direction: false)
                }
            }
        }
        else {}
        
        
        // return view
        let fadeInAction = SCNAction.fadeOpacity(by: rootOpacity, duration: opacityDuration)
        view.scene?.rootNode.runAction(fadeInAction)
        
        
        return view
   }
    //placeholder function required by UIViewRepresentable to update the view with new data
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    // extra functions, function to apply scale animations to a node
    
    private func scaleAnimation(node: SCNNode, from: Double, to: Double) {
        let scaleAction = SCNAction.scale(to: from, duration: 2) //Create a scaling action to the specified size
        scaleAction.timingMode = .easeInEaseOut
        let reverseScaleAction = SCNAction.scale(to: to, duration: 2)//set the timing mode to smooth the animation start and end
        reverseScaleAction.timingMode = .easeInEaseOut//Also smoothens the reverse action
        let disappearAndReverseScale = SCNAction.sequence([scaleAction, reverseScaleAction])
        let repeatAction = SCNAction.repeatForever(disappearAndReverseScale)//repeat the sequence indefinitely
        node.runAction(repeatAction)//starts the animation on the node
    }
    //function to apply rotation animations to a node
    private func rotationAnimation(node: SCNNode) {
        let startAction = SCNAction.rotate(by: 1, around: SCNVector3(x: 0, y: 0, z: 1), duration: 4)//creates a rotation action around the z-axis
        startAction.timingMode = .linear//use a linear timing mode for consistent speed
        let sequenceAction = SCNAction.sequence([startAction])
        let repeatAction = SCNAction.repeatForever(sequenceAction)//Makes the rotation continue indefinitely
        node.runAction(repeatAction)//Applied the rotation action to the node

    }
    //Example of a more specific animation that might toggle visibility or other properties
    private func starAnimation(node: SCNNode, direction: Bool) {
        let startAction = SCNAction.rotate(by: 1, around: SCNVector3(x: 0, y: 0, z: direction ? 1 : -1), duration: 0.5)//determines the direction of rotation based on a boolean value
        startAction.timingMode = .linear
        let sequenceAction = SCNAction.sequence([startAction])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        node.runAction(repeatAction)//starts the animation on the node
    }
    //Function for rainfall animation, demonstrating movement and visibility changes
    private func rainfallAnimation(node: SCNNode, speedIntervals: [Double]) {
        let startAction = SCNAction.move(by: SCNVector3(-0.15, 0, -0.25), duration: Double.random(in: speedIntervals[0]..<speedIntervals[1]))
        let disappearAction = SCNAction.fadeOut(duration: Double.random(in: speedIntervals[0]..<speedIntervals[1]))
        startAction.timingMode = .linear

        let appearAction = SCNAction.fadeIn(duration: 0)
        let topRaindrop = SCNAction.move(to: SCNVector3(node.position.x, node.position.y, node.position.z), duration: 0)
        
        let dropAnimation = SCNAction.group([startAction, disappearAction])
        let restartAnim = SCNAction.group([appearAction, topRaindrop])
        
        let sequenceAction = SCNAction.sequence([dropAnimation, restartAnim])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        node.runAction(repeatAction)
    }
    //similar to above one
    private func snowfallAnimation(node: SCNNode, speedIntervals: [Double]) {
        let startAction = SCNAction.move(by: SCNVector3(-0.05, 0, -0.25), duration: Double.random(in: speedIntervals[0]..<speedIntervals[1]))
        let disappearAction = SCNAction.fadeOut(duration: Double.random(in: speedIntervals[0]..<speedIntervals[1]))
        startAction.timingMode = .linear

        let appearAction = SCNAction.fadeIn(duration: 0.1)
        let topRaindrop = SCNAction.move(to: SCNVector3(node.position.x, node.position.y, node.position.z), duration: 0)
        
        let dropAnimation = SCNAction.group([startAction, disappearAction])
        let restartAnim = SCNAction.group([appearAction, topRaindrop])
        
        let sequenceAction = SCNAction.sequence([dropAnimation, restartAnim])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        node.runAction(repeatAction)
    }
    //function to create a looping animation that alternates between appearing and disappearing
    private func startLoopAnimation(_ node: SCNNode) {
        let appearAction = SCNAction.fadeIn(duration: 1)//fades the node in over 1 second
        let scaleAction = SCNAction.scale(to: 1, duration: 1) //scales the node up to its original size
        scaleAction.timingMode = .easeInEaseOut//smooths the scaling animation
        let reverseScaleAction = SCNAction.scale(to: 0.8, duration: 1)
        reverseScaleAction.timingMode = .easeInEaseOut
        let disappearAction = SCNAction.fadeOut(duration: 1)
        
        let appearAndScale = SCNAction.group([appearAction, scaleAction])
        let disappearAndReverseScale = SCNAction.group([disappearAction, reverseScaleAction])
        
        let sequence = SCNAction.sequence([appearAndScale, SCNAction.wait(duration: 1), disappearAndReverseScale])
        let repeatAction = SCNAction.repeatForever(sequence)
        node.runAction(repeatAction)
    }
    
    //function to create and apply a bloom effect using core image filters
    func addBloom(intensity: Double?, radius: Double?) -> [CIFilter]? {
        let bloomFilter = CIFilter(name:"CIBloom")!//instantiates a new bloom filter
        bloomFilter.setValue(intensity ?? 0.5, forKey: "inputIntensity") //set the intensity of the bloom
        bloomFilter.setValue(radius ?? 10.0, forKey: "inputRadius")//sets the radius of the bloom

        return [bloomFilter]
    }
}
