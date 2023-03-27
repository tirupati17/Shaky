//
//  FeedbackFormViewController.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import UIKit

public class FeedbackFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let containerView = UIView()
    private let descriptionTextView = UITextView()
    private let categoryPickerView = ShakyCategoryPickerView()
    private let imageView = UIImageView()
    private let submitButton = UIButton()
    private let cancelButton = UIButton()
    private var imagePickerCompletion: ((UIImage?) -> Void)?
    weak var delegate: ShakyFeedbackFormDelegate?
    var feedbackScreenshotFilePath: String?
    
    public init(delegate: ShakyFeedbackFormDelegate, screenshotFilePath: String?) {
        self.delegate = delegate
        self.feedbackScreenshotFilePath = screenshotFilePath
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Take screenshot of parent app view
        let parentAppView = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.view
        let screenshotImage = parentAppView?.takeScreenshot()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.backgroundColor = .white
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
        self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionTextView.font = .systemFont(ofSize: 17)
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        self.descriptionTextView.layer.cornerRadius = 8
        self.descriptionTextView.layer.masksToBounds = true
        self.descriptionTextView.textColor = .black
        self.descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.containerView.addSubview(self.descriptionTextView)
        self.descriptionTextView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16).isActive = true
        self.descriptionTextView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        self.descriptionTextView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16).isActive = true
        self.descriptionTextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.containerView.addSubview(self.categoryPickerView)
        self.categoryPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.categoryPickerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        self.categoryPickerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16).isActive = true
        self.categoryPickerView.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor, constant: 16).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFit
        self.containerView.addSubview(self.imageView)
        self.imageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.categoryPickerView.bottomAnchor, constant: 16).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true    // Take screenshot of parent app's view and set it as the thumbnail image
        if let parentView = self.presentingViewController?.view {
            let renderer = UIGraphicsImageRenderer(bounds: parentView.bounds)
            let screenshotImage = renderer.image { _ in
                parentView.drawHierarchy(in: parentView.bounds, afterScreenUpdates: true)
            }
            let thumbnailImage = screenshotImage.resize(to: CGSize(width: 100, height: 100))

            self.imageView.image = thumbnailImage
            
            // Save the actual screenshot image to be passed in the feedback object
            let screenshotData = screenshotImage.jpegData(compressionQuality: 0.8)
            let tempDirectory = NSTemporaryDirectory()
            let tempFilePath = "\(tempDirectory)/screenshot.jpeg"
            do {
                try screenshotData?.write(to: URL(fileURLWithPath: tempFilePath))
            } catch {
                print("Failed to save screenshot image to temp file: \(error.localizedDescription)")
            }
            self.feedbackScreenshotFilePath = tempFilePath
            
            // Load the screenshot image and set it as the thumbnail
            if let screenshotFilePath = feedbackScreenshotFilePath, let screenshotImage = UIImage(contentsOfFile: screenshotFilePath) {
                self.imageView.image = screenshotImage
            } else {
                self.imageView.image = nil
            }
        }
                
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.setTitleColor(.black, for: .normal)
        self.submitButton.addTarget(self, action: #selector(self.submit), for: .touchUpInside)
        self.containerView.addSubview(self.submitButton)
        self.submitButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 24).isActive = true
        self.submitButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16).isActive = true
        self.submitButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -24).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(.black, for: .normal)
        self.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.containerView.addSubview(self.cancelButton)
        self.cancelButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 24).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: self.submitButton.leadingAnchor, constant: -16).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -24).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func attachImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true)
    }
    
    @objc private func submit() {
        // Auto screenshot the parent app view
        let feedback = ShakyFeedback(description: self.descriptionTextView.text, category: self.categoryPickerView.selectedCategory ?? String(), image: self.imageView.image)
        self.delegate?.feedbackFormDidSubmit(feedback)
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension UIView {
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
