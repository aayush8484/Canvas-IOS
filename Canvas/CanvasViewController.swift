//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Aayush  Gupta on 3/18/18.
//  Copyright © 2018 Aayush  Gupta. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 250
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began{
            trayOriginalCenter = trayView.center
        }else if sender.state == .changed{
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }else if sender.state == .ended{
            if (velocity.y > 0){
                // Moving Down.
                print("Moving Down")
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayDown
                }, completion: nil)
                
            }else{
                // Moving Up.
                print("Moving Up")
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayUp
                }, completion: nil)
                trayView.transform.inverted()
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began{
            // Animation for increased size.
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
           enlargeImage(imageToEnlarge: self.newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        }else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceCanvas(sender:)))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchFace(sender:)))
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didTapRotate(sender:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
        } else if sender.state == .ended{
           returnImageDefault(enlargedImage: self.newlyCreatedFace)
        }
        
    }
    
    @objc func didTapRotate(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    @objc func didPinchFace(sender: UIPinchGestureRecognizer){
        print("Inside Pinch Gesture.")
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        if sender.state == .began{
            imageView.transform.scaledBy(x: scale, y: scale)
        } else if sender.state == .ended{
            sender.scale = 1
        }
    }
    
    func enlargeImage(imageToEnlarge: UIImageView){
        UIView.animate(withDuration: 0, delay: 0, options: [.allowAnimatedContent], animations: {
            imageToEnlarge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
    }
    
    func returnImageDefault(enlargedImage: UIImageView){
        UIView.animate(withDuration: 0, delay: 0, options: [.allowAnimatedContent], animations: {
            enlargedImage.transform = self.newlyCreatedFace.transform.scaledBy(x: 0.67, y: 0.67)
        }, completion: nil)
    }
    
    @objc func didPanFaceCanvas(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        if sender.state == .began{
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            enlargeImage(imageToEnlarge: newlyCreatedFace)
        }else if sender.state == .changed{
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
//                self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
//            }, completion: nil)
            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == .ended{
            returnImageDefault(enlargedImage: newlyCreatedFace)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
