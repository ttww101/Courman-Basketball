//
//  EditProfileViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/16.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!

    let loadingIndicator = LoadingIndicator()
    var userOriginName = ""
    var isUpdated  = false

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        setView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setUserImageView()
    }

    // MARK: - Get User Info From Firebase
    func getUserInfo() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        loadingIndicator.start()

        UserManager.shared.getUserInfo(currentUserUID: uid) { (user, error) in

            if user != nil {
                self.userOriginName = user!.name
                self.nameTextField.text = user!.name
                self.loadAndSetUserPhoto(user!.photoURL)
            }

            if error != nil {
                print("=== Error in EditProfileViewController: \(String(describing: error))")
                self.loadingIndicator.stop()
            }
        }
    }

    // MARK: - Load User Picture From Firebase
    func loadAndSetUserPhoto(_ userPhotoUrlString: String) {

        DispatchQueue.global().async {

            if let imageUrl = URL(string: userPhotoUrlString) {
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.userImage.image = image
                            self.loadingIndicator.stop()
                        }
                    }
                } catch {
                    print("=== \(error)")
                }
            }
        }
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.basketball)
    }

    func setUserImageView() {

        userImage.layer.cornerRadius = userImage.bounds.size.height / 2.0
        userImage.layer.borderWidth = 1.0
        userImage.layer.masksToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Select Picture
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            let tappedImage = tapGestureRecognizer.view as? UIImageView
            else { return }

        let pickerController = DKImagePickerController()

        pickerController.singleSelect = true
        pickerController.assetType = .allPhotos

        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count != 0 {
//                assets[0].fetchOriginalImageWithCompleteBlock({ (image, _) in
//                    tappedImage.image = image
//                    self.isUpdated = true
//                })
            }
        }

        self.present(pickerController, animated: true) {}
    }

    // MARK: - Save User Info to Firebase
    @IBAction func saveProfileInfo(_ sender: Any) {

        if (nameTextField.text != userOriginName) || isUpdated {

            self.loadingIndicator.start()

            guard let uid = Auth.auth().currentUser?.uid else { return }

            let storageRef = Storage.storage().reference()
                .child(Constant.FirebaseStorage.userPhoto)
                .child(Constant.FirebaseStorage.userPhoto + "_" + uid)

            // Delete the file
            storageRef.delete { error in

                if error == nil {

                    // File deleted successfully
                    self.uploadImageToFirebase(uid, storageRef)

                } else {
                    print("=== Error in EditProfileViewController01 \(String(describing: error))")
                }
            }

        } else {

            self.dismiss(animated: true, completion: nil)
        }
    }

    func uploadImageToFirebase(_ uid: String, _ storageRef: StorageReference) {

        guard
            let uploadData = UIImageJPEGRepresentation(self.userImage.image!, 0.3)
            else { return }

        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

            if error != nil {
                print("=== Error in EditProfileViewController02: \(String(describing: error))")
                return
            }

            let userPhotoURL = metadata?.path
            self.updateValueToFirebase(uid: uid,
                                       name: self.nameTextField.text!,
                                       userPhotoURL: userPhotoURL!)
        })
    }

    func updateValueToFirebase(uid: String, name: String, userPhotoURL: String) {

        let ref = Database.database().reference().child(Constant.FirebaseUser.nodeName).child(uid)

        let userUpdatedInfo = [Constant.FirebaseUser.name: name,
                               Constant.FirebaseUser.photoURL: userPhotoURL]

        ref.updateChildValues(userUpdatedInfo) { (error, _) in

            self.loadingIndicator.stop()

            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("=== Error in EditProfileViewController03: \(String(describing: error))")
            }
        }
    }

    @IBAction func cancelEdit(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
}
