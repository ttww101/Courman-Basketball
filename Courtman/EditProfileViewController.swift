//
//  EditProfileViewController.swift
//  Courtman
//
//  Created by steven.chou on 2017/4/16.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import YPImagePicker

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!

    let loadingIndicator = LoadingIndicator()
    var userOriginName = ""
    var isUpdated  = false

    @IBAction func levelSetupDidTouchUpSide() {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//
            let chooseLevelStorybard = UIStoryboard(name: Constant.Storyboard.chooseLevel, bundle: nil)
            let vc = chooseLevelStorybard.instantiateViewController(withIdentifier: Constant.Controller.chooseLevel) as? ChooseLevelViewController
            vc?.type = .setup
            if let vc = vc {
                self.navigationController?.pushViewController(vc, animated: true)
            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getUserInfo()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transparentizeNavigationBar(navigationController: self.navigationController)
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
            
            self.loadingIndicator.stop()
            
            if user != nil {
                self.userOriginName = user!.name
                self.nameTextField.text = user!.name
                self.loadAndSetUserPhoto(user!.photoURL)
            }

            if error != nil {
                print("=== Error in EditProfileViewController: \(String(describing: error))")
            }
        }
    }

    // MARK: - Load User Picture From Firebase
    func loadAndSetUserPhoto(_ userPhotoUrlString: String) {

        DispatchQueue.global().async {

            let storageRef = Storage.storage().reference()
            
            let islandRef = storageRef.child(userPhotoUrlString)
            
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("=== \(error)")
                } else {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.userImage.image = image
                        self.loadingIndicator.stop()
                    }
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
        presentImagePicker()
    }
    
    func presentImagePicker() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "CourtsMan"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo,.library]
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedColour = UIColor.hexColor(with: "dd7663")
        config.bottomMenuItemUnSelectedColour = UIColor.hexColor(with: "454545")
        
        config.library.options = nil
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        //navigation bar
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes // Title fonts
        
        UINavigationBar.appearance().tintColor = .white // Left. bar buttons
        config.colors.tintColor = .white // Right bar buttons (actions)
        
        //bar background
        let coloredImage = UIColor.hexColor(with: "454545").image()
        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
        
       let barButtonAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal) // Bar Button fonts
        
        UITabBar.appearance().backgroundColor = UIColor.hexColor(with: "454545")
        
        YPImagePickerConfiguration.shared = config
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            
            if let photo = items.singlePhoto {
                self.userImage.image = photo.image
                self.isUpdated = true

            } else {

            }

            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
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
            let uploadData = self.userImage.image!.jpegData(compressionQuality: 0.3)
            else { return }

        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

            if error != nil {
                print("=== Firebase upload profile photo Error: \(String(describing: error))")
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
                print("Firebase update user name & photo url Error in EditProfileViewController03: \(String(describing: error))")
            }
        }
    }

    @IBAction func cancelEdit(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
}
