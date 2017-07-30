//
//  ViewController.swift
//  blurEffect
//
//  Created by 陳 冠禎 on 2017/7/27.
//  Copyright © 2017年 陳 冠禎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    func keyboardHide(){
        view.endEditing(true)
    }
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let effect = UIBlurEffect(style: .extraLight)
        let myBlurView = UIVisualEffectView(effect: blurEffect)
        myBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        myBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myBlurView.alpha = 0.5
        myBlurView.isHidden = true
        return myBlurView
    }()
    
    let vibranceView: UIVisualEffectView = {
        let vibranceEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
        let myVibranceView = UIVisualEffectView(effect: vibranceEffect)
        return myVibranceView
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.text = "測試 vibranceView"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let sliderView: UISlider = {
        let mySlider = UISlider()
        mySlider.translatesAutoresizingMaskIntoConstraints = false
        mySlider.setThumbImage(UIImage(named: "redPoint"), for: .normal)
        mySlider.maximumValue = 1
        mySlider.minimumValue = 0
        mySlider.value = 0.5
        mySlider.isContinuous = true
        mySlider.isHidden = false
        mySlider.addTarget(self,
                           action: #selector(handleSliderChange),
                           for: .valueChanged)
        return mySlider
    }()
    
    func handleSliderChange() {
        blurEffectView?.alpha = CGFloat(sliderView.value)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarItem()
        setupView()
    }
    
    let vibrantLabel = UITextField()
    
    
    var blurEffectView: UIVisualEffectView?
    private func setupView() {
        
//        
//        let textfield = UITextField()
//        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.backgroundColor = .clear
//        textfield.placeholder = "enter"
//        textfield.isUserInteractionEnabled = true
//        
        
         view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        
//        UIBlurEffect(style: <#T##UIBlurEffectStyle#>)
//        UIBlurEffectStyle.prominent
       
        // Blur Effect
        let blurEffect = UIBlurEffect(style: .prominent)
         blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        
        
        // Vibrancy Effect
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        // Label for vibrant text
        
        vibrantLabel.text = "shiung"
        vibrantLabel.font = UIFont.systemFont(ofSize: 72.0)
        vibrantLabel.sizeToFit()
        vibrantLabel.center = view.center
        vibrantLabel.textAlignment = .center
        // Add label to the vibrancy view
        vibrancyEffectView.contentView.addSubview(vibrantLabel)
        
        // Add the vibrancy view to the blur view
        blurEffectView?.contentView.addSubview(vibrancyEffectView)
        
        view.addSubview(blurEffectView!)
        blurEffectView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardHide)))

        view.addSubview(sliderView)
        sliderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupBarItem() {
        
        
        
        let photoLibary = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickupPhoto))
        navigationItem.setRightBarButton(photoLibary, animated: true)
    }
    
    func pickupPhoto() {
     let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true) {
                    self.sliderView.isHidden = false
                    self.blurView.isHidden = false
                }
                
            } else {
                print("Camera not available")
            }
            
        }))

        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true) {
            self.sliderView.isHidden = false
            self.blurView.isHidden = false
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            backgroundImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

