//
//  BasketballGamesViewController.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/4/13.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class BasketballGamesViewController: BaseViewController {

    @IBOutlet weak var gamesTableView: UITableView!

    let loadingIndicator = LoadingIndicator()
    var menuView: BTNavigationDropdownMenu?

    var gamesList: [BasketballGame] = []

    var isShowDefaultCell = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getGames()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if menuView != nil {
            menuView?.hide()
        }
    }

    func setView() {

        setBackground(imageName: Constant.BackgroundName.basketball)

        setNavigationBar()
        setTableView()
    }

    func setTableView() {

        self.automaticallyAdjustsScrollViewInsets = false

        let gameNib = UINib(nibName: Constant.Cell.game, bundle: nil)
        gamesTableView.register(gameNib, forCellReuseIdentifier: Constant.Cell.game)

        let gameDefaultNib = UINib(nibName: Constant.Cell.gameDefault, bundle: nil)
        gamesTableView.register(gameDefaultNib, forCellReuseIdentifier: Constant.Cell.gameDefault)

        // Separator
        gamesTableView.separatorStyle = .none
    }

    func setNavigationBar() {

        transparentizeNavigationBar(navigationController: self.navigationController)

        let backButton = createBackButton(action: #selector(backToSportItemsView))
        self.navigationItem.leftBarButtonItem = backButton

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Button_New"), style: .done, target: self, action: #selector(createNewBasketballGameGame))

        setNavigationDropdownMenu()

        /*
        // todo: 看要不要調整 bar left button的位子
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.navigationItem.setLeftBarButtonItems([flexible, backButton, flexible, flexible], animated: false)
         */
    }

    func setNavigationDropdownMenu() {

        menuView = BTNavigationDropdownMenu(title: items[Constant.CurrentCity.cityIndex], items: items as [AnyObject])
        self.navigationItem.titleView = menuView

        menuView?.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> Void in

            if let city = self?.items[indexPath] {
                Constant.CurrentCity.cityIndex = indexPath
                Constant.CurrentCity.cityName = city
            }

            self?.getGames()
        }

        menuView?.menuTitleColor = .white
        menuView?.cellTextLabelColor = .white
        menuView?.cellSelectionColor = .white
        menuView?.cellSeparatorColor = .white
        menuView?.cellBackgroundColor = .black
    }

    func getGames() {

        loadingIndicator.start()

        let ref = FIRDatabase.database().reference().child(Constant.FirebaseGame.nodeName)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.exists() {

                self.gamesList.removeAll()

                // todo: 拉出來成一個game provider
                if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snaps {

                        let gameParser = BasketballGameParser()

                        guard
                            let game = gameParser.parserGame(snap)
                            else {
                                self.loadingIndicator.stop()
                                continue
                            }

                        let isOverTime = self.checkGameTime(game)
                        let isNotRepetition = self.checkGameRepeted(game)
                        let isInCurrentCity = self.checkGameInCurrentCity(game)
                        let isOwnerInGame = self.checkOwnerInGame(game)

                        if isOverTime &&
                            isNotRepetition &&
                            isInCurrentCity &&
                            isOwnerInGame {

                            self.gamesList.append(game)
                        }
                    }

                    self.gamesList.sort { $0.time < $1.time }

                    self.gamesTableView.reloadData()

                } else {
                    print("=== Parser is having question in BasketballGamesViewController")
                }

                self.loadingIndicator.stop()

            } else {
                print("=== snapshot does not exist")
                self.loadingIndicator.stop()
            }
        })
    }

    // MARK: - Filter court by time
    func checkGameTime(_ game: BasketballGame) -> Bool {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale.current

        let currectTime = formatter.string(from: Date())

        return game.time > currectTime
    }

    // MARK: - Filter court by Having same item or not
    func checkGameRepeted(_ game: BasketballGame) -> Bool {

        var isNotRepetition = true

        for gameData in self.gamesList {
            if gameData.court.name == game.court.name &&
                gameData.name == game.name &&
                gameData.owner == game.owner &&
                gameData.time == game.time {
                isNotRepetition = false
            }
        }

        return isNotRepetition
    }

    // MARK: - Filter court by city
    func checkGameInCurrentCity(_ game: BasketballGame) -> Bool {

        let courtAddress = game.court.address
        let index = courtAddress.index(courtAddress.startIndex, offsetBy: 3)
        let city = courtAddress.substring(to: index)

        return (Constant.CurrentCity.cityName == city)
    }

    // MARK: - Filter court by is Owner in game
    func checkOwnerInGame(_ game: BasketballGame) -> Bool {

        var isOwnerInGame = true

        let owner = game.members.filter({ (member) -> Bool in
            member == game.owner
        })

        if owner.count == 0 {
            isOwnerInGame = false
        }

        return isOwnerInGame
    }

    func createNewBasketballGameGame() {
        let storyBoard = UIStoryboard(name: Constant.Storyboard.newBasketballGame, bundle: nil)
        guard let newBasketballGameViewController = storyBoard.instantiateViewController(withIdentifier: Constant.Controller.newBasketballGame) as? NewBasketballGameViewController else { return }

        self.navigationController?.pushViewController(newBasketballGameViewController, animated: true)
    }
}

// MARK: TableView
extension BasketballGamesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if gamesList.count == 0 {
            tableView.rowHeight = GameDefaultTableViewCell.height
        } else {
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }

        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if gamesList.count == 0 {
            isShowDefaultCell = true
            return 1
        } else {
            isShowDefaultCell = false
            return gamesList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isShowDefaultCell {
            return setDefaultTableViewCell(tableView: tableView, indexPath: indexPath)
        } else {
            return setGameTableViewCell(tableView: tableView, indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isShowDefaultCell {

            self.createNewBasketballGameGame()

        } else {

            let storyBoard = UIStoryboard(name: Constant.Storyboard.basketballGameDetail, bundle: nil)

            guard
                let basketballGameDetailViewController = storyBoard.instantiateViewController(withIdentifier: Constant.Controller.basketballGameDetail) as? BasketballGameDetailViewController
                else { return }

            basketballGameDetailViewController.game = gamesList[indexPath.row]

            self.navigationController?.pushViewController(basketballGameDetailViewController, animated: true)
        }
    }

}

// MARK: TableView - Set Cell
extension BasketballGamesViewController {

    func setDefaultTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.gameDefault,
                                                     for: indexPath) as? GameDefaultTableViewCell
            else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        return cell
    }

    func setGameTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.game,
                                                     for: indexPath) as? GameTableViewCell
            else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let game = gamesList[indexPath.row]

        cell.location.text = game.court.name
        cell.name.text = game.name
        cell.peopleNum.text = String(game.members.count)
        cell.time.text = game.time

        switch game.level {

        case "A":
            cell.levelImage.image = #imageLiteral(resourceName: "Level_A")
        case "B":
            cell.levelImage.image = #imageLiteral(resourceName: "Level_B")
        case "C":
            cell.levelImage.image = #imageLiteral(resourceName: "Level_C")
        case "D":
            cell.levelImage.image = #imageLiteral(resourceName: "Level_D")
        case "E":
            cell.levelImage.image = #imageLiteral(resourceName: "Level_E")

        default:
            cell.levelImage.image = #imageLiteral(resourceName: "Level_C")
        }

        return cell
    }
}
