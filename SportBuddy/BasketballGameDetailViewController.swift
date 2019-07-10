//
//  BasketballGameDetailViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/14.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class BasketballGameDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    enum Component {
        case weather, map, members, comment, joinOrLeave
    }

    var components: [Component] = [ .weather, .map, .members, .comment, .joinOrLeave]

    var currentUserUid = ""
    var game: BasketballGame?
    var weather: Weather?
    var members: [User] = []
    var comments: [GameComment] = []
    var commentOwnersPhoto: [String: UIImage] = [:]

    var isUserInMembers = false
    var isTotallyUpdated = false

    let loadingIndicator = LoadingIndicator()
    let fullScreenSize = UIScreen.main.bounds.size

    var selectedWeatherIndex: IndexPath = IndexPath()
    var isWeatherExpanded = false

    var selectedMapIndex: IndexPath = IndexPath()
    var isMapExpanded = false

    var selectedMemberIndex: IndexPath = IndexPath()
    var isMemberExpanded = true

    var selectedCommentIndex: IndexPath = IndexPath()
    var isCommentExpanded = true

    var isFinishLoadMembers = false
    var isFinishLoadComments = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let uid = Auth.auth().currentUser?.uid {
            currentUserUid = uid
        } else {
            print("=== Can't find this user in BasketballGameDetailViewController")
        }

        setView()
        getWeather()
        getMembersInfo()
        getGameComments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MARK: Loading indicator
        self.loadingIndicator.start()

        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let topPadding = navigationController?.navigationBar.frame.maxY {
            self.tableView.frame = CGRect(x: 0,
                                          y: topPadding,
                                          width: self.tableView.frame.width,
                                          height: self.tableView.frame.height)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }

    func setView() {
        // NavigationItem
        self.navigationItem.title = game?.name

        // Background
        setBackground(imageName: Constant.BackgroundName.basketball)

        // Separator
        tableView.separatorStyle = .none

        let weatherNib = UINib(nibName: WeatherTableViewCell.identifier, bundle: nil)
        tableView.register(weatherNib, forCellReuseIdentifier: WeatherTableViewCell.identifier)

        let mapNib = UINib(nibName: MapTableViewCell.identifier, bundle: nil)
        tableView.register(mapNib, forCellReuseIdentifier: MapTableViewCell.identifier)

        let membersNib = UINib(nibName: MembersTableViewCell.identifier, bundle: nil)
        tableView.register(membersNib, forCellReuseIdentifier: MembersTableViewCell.identifier)

        let commentNib = UINib(nibName: GameCommentTableViewCell.identifier, bundle: nil)
        tableView.register(commentNib, forCellReuseIdentifier: GameCommentTableViewCell.identifier)

        let joinOrLeaveNib = UINib(nibName: JoinOrLeaveTableViewCell.identifier, bundle: nil)
        tableView.register(joinOrLeaveNib, forCellReuseIdentifier: JoinOrLeaveTableViewCell.identifier)
    }

    func didExpandWeatherCell() {

        self.isWeatherExpanded = !isWeatherExpanded
        self.tableView.reloadRows(at: [selectedWeatherIndex], with: .automatic)
    }

    func didExpandMapCell() {

        self.isMapExpanded = !isMapExpanded
        self.tableView.reloadRows(at: [selectedMapIndex], with: .automatic)
    }

    func didExpandMemberCell() {

        self.isMemberExpanded = !isMemberExpanded
        self.tableView.reloadRows(at: [selectedMemberIndex], with: .automatic)
    }

    func didExpandCommentCell() {

        self.isCommentExpanded = !isCommentExpanded
        self.tableView.reloadRows(at: [selectedCommentIndex], with: .automatic)
    }

    func getWeather() {

        if game != nil {
            let courtAddress = game!.court.address
            let index = courtAddress.index(courtAddress.startIndex, offsetBy: 5)
            let town = courtAddress.substring(to: index)

            WeatherProvider.shared.getWeather(town: town, completion: { (weather, error) in

                if error == nil {
                    self.weather = weather
                    self.tableView.reloadData()
                } else {
                    print("=== Error in BasketballGameDetailViewController - Get weather")
                }
            })
        } else {
            print("=== Error in BasketballGameDetailViewController getWeather()")
        }
    }

    func getMembersInfo() {

        guard
            game != nil,
            game?.members.count != 0
            else { return }

        MemebersProvider.sharded.getMembers(gameID: (game?.gameID)!) { (members) in

            for member in members {

                UserManager.shared.getUserInfo(currentUserUID: member, completion: { (user, error) in

                    if user != nil {
                        self.members.append(user!)
                    }

                    if member == members[members.count-1] {
                        self.isFinishLoadMembers = true

                        if self.isFinishLoadMembers && self.isFinishLoadComments {
                            self.tableView.reloadData()
                            self.loadingIndicator.stop()
                        }
                    }

                    if error != nil {
                        print("=== Error: \(String(describing: error))")
                        self.loadingIndicator.stop()
                    }
                })
            }
        }
    }

    // todo: 可以把function裡頭的東西拉開, 剛加入game的人無法顯示大頭照在第一次留言時
    func getGameComments() {

        guard
            game != nil
            else { return }

        var commentOwners = Set<String>()
        var totalCommentOwners = 0

        GameCommentProvider.sharded.getComments(gameID: (game?.gameID)!) { (gameComments) in

            if gameComments.count == 0 {

                UserManager.shared.getUserInfo(currentUserUID: self.currentUserUid, completion: { (user, error) in
                    DispatchQueue.global().async {
                        if let imageUrl = URL(string: (user?.photoURL)!) {
                            do {
                                let imageData = try Data(contentsOf: imageUrl)
                                if let image = UIImage(data: imageData) {
                                    self.commentOwnersPhoto.updateValue(image, forKey: self.currentUserUid)

                                    if totalCommentOwners == commentOwners.count {

                                        self.isFinishLoadComments = true

                                        if self.isFinishLoadMembers && self.isFinishLoadComments {

                                            DispatchQueue.main.async {

                                                self.tableView.reloadData()
                                                self.loadingIndicator.stop()
                                            }
                                        }
                                    }
                                }
                            } catch {
                                print("=== Error: \(error)")
                                self.loadingIndicator.stop()
                            }
                        }
                    }
                })
            } else {

                self.comments = gameComments

                for comment in self.comments {
                    commentOwners.insert(comment.commentOwner)
                }

                for commentOwner in commentOwners {
                    UserManager.shared.getUserInfo(currentUserUID: commentOwner, completion: { (user, error) in

                        if user != nil {
                            DispatchQueue.global().async {
                                if let imageUrl = URL(string: (user?.photoURL)!) {
                                    do {
                                        let imageData = try Data(contentsOf: imageUrl)
                                        if let image = UIImage(data: imageData) {
                                            totalCommentOwners += 1
                                            self.commentOwnersPhoto.updateValue(image, forKey: commentOwner)

                                            if totalCommentOwners == commentOwners.count {

                                                self.isFinishLoadComments = true

                                                if self.isFinishLoadMembers && self.isFinishLoadComments {

                                                    DispatchQueue.main.async {

                                                        self.tableView.reloadData()
                                                        self.loadingIndicator.stop()
                                                    }
                                                }
                                            }
                                        }
                                    } catch {
                                        print("=== Error: \(error)")
                                        self.loadingIndicator.stop()
                                    }
                                }
                            }
                        }

                        if error != nil {
                            print("=== Error: \(String(describing: error))")
                            self.loadingIndicator.stop()
                        }
                    })
                }

            }

        }
    }
}

extension BasketballGameDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return components.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch components[section] {
        case .weather, .map, .members, .comment, .joinOrLeave:

            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast

        let component = components[indexPath.section]

        switch component {
        case .weather:

            let identifier = WeatherTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WeatherTableViewCell

            return setWeatherCell(cell)

        case .map:

            let identifier = MapTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MapTableViewCell

            return setMapCell(cell)

        case .members:

            let identifier = MembersTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MembersTableViewCell

            return setMemberCell(cell)

        case .comment:

            let identifier = GameCommentTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GameCommentTableViewCell

            return setCommentCell(cell)

        case .joinOrLeave:

            let identifier = JoinOrLeaveTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! JoinOrLeaveTableViewCell

            return setJoinOrLeaveTableViewCell(cell)
        }

        // swiftlint:enable force_cast
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch components[indexPath.section] {
        case .weather:

            return isWeatherExpanded ?
                WeatherTableViewCell.gameCellHeight :
                WeatherTableViewCell.gameDefaultHeight

        case .map:

            let cellWidth = view.bounds.size.width
            let height = cellWidth / MapTableViewCell.aspectRatio

            return isMapExpanded ? height+30 : MapTableViewCell.gameDefaultHeight

        case .members:

            return isMemberExpanded ?
                MembersTableViewCell.height :
                MembersTableViewCell.defaultHeight

        case .comment:

            return isCommentExpanded ?
                GameCommentTableViewCell.height :
                GameCommentTableViewCell.defaultHeight

        case .joinOrLeave:

            return JoinOrLeaveTableViewCell.height
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = components[indexPath.section]

        switch component {
            case .weather:
                self.selectedWeatherIndex = indexPath
                self.didExpandWeatherCell()

            case .map:
                self.selectedMapIndex = indexPath
                self.didExpandMapCell()

            case .members:
                self.selectedMemberIndex = indexPath
                self.didExpandMemberCell()

            case .comment:
                self.selectedCommentIndex = indexPath
                self.didExpandCommentCell()

            case .joinOrLeave: break
        }
    }
}

// MARK: - Set cell
extension BasketballGameDetailViewController {

    func getGameDBRef() -> DatabaseReference {

        let ref = Database.database().reference()
                    .child(Constant.FirebaseGame.nodeName)
                    .child((game?.gameID)!)

        return ref
    }

    func setUserGameList(isJoined: Bool) {

        let ref = Database.database().reference()
            .child(Constant.FirebaseUserGameList.nodeName)
            .child(currentUserUid)

        if isJoined {

            let value: [String: Int] = [(game?.gameID)!: 1]
            ref.updateChildValues(value) { (error, _) in

                if error != nil {
                    print("=== Error in BasketballGameDetailViewController setUserGameList() - join")
                }
            }
        } else {

            ref.child((game?.gameID)!).removeValue(completionBlock: { (error, _) in

                if error != nil {
                    print("=== Error in BasketballGameDetailViewController setUserGameList() - delete")
                }
            })
        }
    }

    func setWeatherCell(_ cell: WeatherTableViewCell) -> WeatherTableViewCell {

        setCellBasicStyle(cell)

        if !isWeatherExpanded {
            cell.weatherImage.isHidden = true
            cell.weatherLabel.isHidden = true
            cell.temperatureLabel.isHidden = true
            cell.updateTimeLabel.isHidden = true
            cell.weatherCellTitle.text = "▶︎ 天氣資訊"

        } else {

            cell.weatherImage.isHidden = false
            cell.weatherLabel.isHidden = false
            cell.temperatureLabel.isHidden = false
            cell.updateTimeLabel.isHidden = false
            cell.weatherCellTitle.text = "▼ 天氣資訊"
        }

        if let desc = weather?.desc,
            let weatherPicName = weather?.weatherPicName,
            let temperature = weather?.temperature,
            let time = weather?.time {

            cell.weatherImage.image = UIImage(named: weatherPicName)
            cell.weatherLabel.text = "\(desc)"
            cell.temperatureLabel.text = "氣溫 : \(temperature) 度"
            cell.updateTimeLabel.text = "更新時間 : \n\(time)"

        } else {

            //cell.weatherImage.image = UIImage(named: Constant.ImageName.fixing)
            cell.weatherLabel.text = ""
            cell.temperatureLabel.text = "天氣即時資訊更新維護中..."
            cell.updateTimeLabel.text = ""
        }

        return cell
    }

    func setMapCell(_ cell: MapTableViewCell) -> MapTableViewCell {

        setCellBasicStyle(cell)

        if !isMapExpanded {
            cell.mapView.isHidden = true
            cell.mapCellTitle.text = "▶︎ 球場位置"
        } else {
            cell.mapView.isHidden = false
            cell.mapCellTitle.text = "▼ 球場位置"
        }

        if let latitudeString = game?.court.latitude,
            let longitudeString = game?.court.longitude {

            let latitude = (latitudeString as NSString).doubleValue
            let longitude = (longitudeString as NSString).doubleValue

            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            cell.mapView.addAnnotation(annotation)

            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)

            cell.mapView.setRegion(region, animated: true)
            cell.mapView.mapType = .standard
        }

        return cell
    }

    func setMemberCell(_ cell: MembersTableViewCell) -> MembersTableViewCell {

        setCellBasicStyle(cell)

        if !isMemberExpanded {
            cell.collectionView.isHidden = true
            cell.memberCellTitle.text = "▶︎ 球賽成員"
        } else {
            cell.collectionView.isHidden = false
            cell.memberCellTitle.text = "▼ 球賽成員"
        }

        cell.game = game
        cell.members = members
        cell.collectionView.reloadData()

        return cell
    }

    func setCommentCell(_ cell: GameCommentTableViewCell) -> GameCommentTableViewCell {

        setCellBasicStyle(cell)

        if !isCommentExpanded {
            cell.commentTableView.isHidden = true
            cell.commentTextField.isHidden = true
            cell.commentButton.isHidden = true
            cell.commentTitleLabel.text = "▶︎ 球賽留言板"
        } else {

            cell.commentTableView.isHidden = false
            cell.commentTextField.isHidden = false
            cell.commentButton.isHidden = false
            cell.commentTitleLabel.text = "▼ 球賽留言板"
        }

        cell.game = game
        cell.members = members
        cell.comments = comments
        cell.commentOwnersPhoto = commentOwnersPhoto
        cell.commentDelegate = self
        cell.commentTableView.reloadData()

        return cell
    }

    func setJoinOrLeaveTableViewCell(_ cell: JoinOrLeaveTableViewCell) -> JoinOrLeaveTableViewCell {

        setCellBasicStyle(cell)

        if currentUserUid != "" && game != nil {
            for member in (game?.members)! {

                var isGameOwner = false

                if game?.owner == currentUserUid {
                    isGameOwner = true
                }

                if member == currentUserUid {
                    isUserInMembers = true
                }

                if isUserInMembers && isGameOwner {
                    // show cancel button
                    cell.joinButton.isHidden = true
                    cell.leaveButton.isHidden = true

                    cell.cancelGameButton.isHidden = false
                    cell.cancelGameButton.addTarget(self, action: #selector(leaveFromGame), for: .touchUpInside)

                } else if isUserInMembers && !isGameOwner {
                    // show leave button
                    cell.joinButton.isHidden = true
                    cell.cancelGameButton.isHidden = true

                    cell.leaveButton.isHidden = false
                    cell.leaveButton.addTarget(self, action: #selector(leaveFromGame), for: .touchUpInside)

                } else {
                    // show join button
                    cell.leaveButton.isHidden = true
                    cell.cancelGameButton.isHidden = true

                    cell.joinButton.isHidden = false
                    cell.joinButton.addTarget(self, action: #selector(joinToGame), for: .touchUpInside)
                }
            }
        } else {
            print("=== Error: Someing is wrong in BasketballGameDetailViewController")
        }

        return cell
    }

    @objc func joinToGame() {

        guard game != nil else { return }

        if isUserInMembers { return }

        var newMemberList: [String] = []
        newMemberList = (game?.members)!
        newMemberList.append(currentUserUid)

        let value = [Constant.FirebaseGame.members: newMemberList]
        getGameDBRef().updateChildValues(value) { (error, _) in

            if error == nil {
                self.getMembersInfo()
                self.setUserGameList(isJoined: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("=== Error in BasketballGameDetailViewController joinToGame()")
            }
        }
    }

    @objc func leaveFromGame() {

        guard game != nil else { return }

        if !isUserInMembers { return }

        var newMemberList: [String] = []

        for member in (game?.members)! {
            if member != currentUserUid {
                newMemberList.append(member)
            }
        }

        let value = [Constant.FirebaseGame.members: newMemberList]
        getGameDBRef().updateChildValues(value) { (error, _) in

            if error == nil {
                self.getMembersInfo()
                self.setUserGameList(isJoined: false)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("=== Error in BasketballGameDetailViewController joinToGame()")
            }
        }
    }

    func setCellBasicStyle(_ cell: UITableViewCell) {

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
    }
}

// MARK: - Show Alert
extension BasketballGameDetailViewController: CommentCallDelegate {

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
