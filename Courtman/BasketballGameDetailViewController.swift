//
//  BasketballGameDetailViewController.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
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
    var isWeatherExpanded = true

    var selectedMapIndex: IndexPath = IndexPath()
    var isMapExpanded = true

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
        getMembersInfo({
            print("member ok tableiview reload")
            self.tableView.reloadData()
        })
        getGameComments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            
            WeatherProvider.shared.getWeather(city: items[Constant.CurrentCity.cityIndex], completion: { (weather, error) in

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

    func getMembersInfo(_ completion:(() -> ())? = nil) {

        guard
            game != nil,
            game?.members.count != 0
            else { return }

        self.loadingIndicator.start()
        
        MemebersProvider.sharded.getMembers(gameID: (game?.gameID)!) { (members) in
            
            self.loadingIndicator.stop()

            print("got \(members.count) members")
            
            for member in members {

                UserManager.shared.getUserInfo(currentUserUID: member, completion: { (user, error) in
                    
                    if error != nil {
                        print("=== Error: \(String(describing: error))")
                    }
                    
                    if user != nil {
                        self.members.append(user!)
                    }
                    if member == members[members.count-1] {
                        if let completion = completion {
                            completion()
                        }
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
        
        GameCommentProvider.sharded.getComments(gameID: (game?.gameID)!) { (getComments) in
            
                self.comments = getComments
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
            cell.weatherLabel.isHidden = true
            cell.temperatureLabel.isHidden = true
            cell.rainRateLabel.isHidden = true
            cell.feelLabel.isHidden = true
            cell.weatherCellTitle.text = "▶︎ 天氣資訊"

        } else {
            cell.weatherLabel.isHidden = false
            cell.temperatureLabel.isHidden = false
            cell.rainRateLabel.isHidden = false
            cell.feelLabel.isHidden = false
            cell.weatherCellTitle.text = "▼ 天氣資訊"
        }

        if let weather = weather {

            cell.weatherLabel.text = "\(weather.description)"
            cell.temperatureLabel.text = "氣溫 \(weather.temperature)°C"
            cell.rainRateLabel.text = "降雨機率 \(weather.rainRate)%"
            cell.feelLabel.text = "體感 \(weather.feel)"

        } else {
            cell.weatherLabel.text = ""
            cell.temperatureLabel.text = "無法取得即時天氣資訊"
            cell.rainRateLabel.text = ""
        }

        return cell
    }

    func setMapCell(_ cell: MapTableViewCell) -> MapTableViewCell {

        setCellBasicStyle(cell)

        if !isMapExpanded {
            cell.mapView.isHidden = true
            cell.mapCellTitle.text = "▶︎ 位置"
        } else {
            cell.mapView.isHidden = false
            cell.mapCellTitle.text = "▼ 位置"
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
            cell.memberCellTitle.text = "▶︎ 成員"
        } else {
            cell.collectionView.isHidden = false
            cell.memberCellTitle.text = "▼ 成員"
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
                    cell.eventButton.gradientStartColor = .lightGray
                    cell.eventButton.gradientEndColor = .lightGray
                    cell.eventButton.titleString = "Cancel"
                    cell.eventButton.removeTarget(nil, action: nil, for: .allEvents)
                    cell.eventButton.addTarget(self, action: #selector(leaveFromGame), for: .touchUpInside)

                } else if isUserInMembers && !isGameOwner {
                    // show leave button
                    cell.eventButton.gradientStartColor = .lightGray
                    cell.eventButton.gradientEndColor = .lightGray
                    cell.eventButton.titleString = "Leave"
                    cell.eventButton.removeTarget(nil, action: nil, for: .allEvents)
                    cell.eventButton.addTarget(self, action: #selector(leaveFromGame), for: .touchUpInside)

                } else {
                    // show join button
                    cell.eventButton.gradientStartColor = .init(red: 208/255, green: 108/255, blue: 120/255, alpha: 1.0)
                    cell.eventButton.gradientEndColor = .init(red: 244/255, green: 198/255, blue: 120/255, alpha: 1.0)
                    cell.eventButton.titleString = "Join"
                    cell.eventButton.removeTarget(nil, action: nil, for: .allEvents)
                    cell.eventButton.addTarget(self, action: #selector(joinToGame), for: .touchUpInside)
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
                self.getMembersInfo(nil)
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
                self.getMembersInfo(nil)
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
