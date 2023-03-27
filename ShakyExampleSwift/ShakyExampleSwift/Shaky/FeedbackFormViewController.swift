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
    private let addImageButton = UIButton()
    private let submitButton = UIButton()
    private let cancelButton = UIButton()
    private var imagePickerCompletion: ((UIImage?) -> Void)?
    weak var delegate: ShakyFeedbackFormDelegate?
    
    public init(delegate: ShakyFeedbackFormDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.addImageButton.setTitle("Add Image", for: .normal)
        self.addImageButton.setTitleColor(.black, for: .normal)
        self.addImageButton.addTarget(self, action: #selector(self.addImage), for: .touchUpInside)
        self.containerView.addSubview(self.addImageButton)
        self.addImageButton.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16).isActive = true
        self.addImageButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        
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
    
    @objc private func addImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { _ in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.present(imagePickerController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc private func submit() {
        let feedback = ShakyFeedback(description: self.descriptionTextView.text, category: self.categoryPickerView.selectedCategory ?? String(), image: self.imageView.image)
        self.delegate?.feedbackFormDidSubmit(feedback)
    }
    
    @objc private func cancel() {
        self.delegate?.feedbackFormDidCancel()
    }
}
