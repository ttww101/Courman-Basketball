//
//  BasketballCourtsViewController.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import NVActivityIndicatorView

class BasketballCourtsViewController: BaseViewController {

    @IBOutlet var courtsTableView: UITableView!

    let loadingIndicator = LoadingIndicator()

    var basketballCourts: [BasketballCourt] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCourts()
    }

    func setView() {
        setBackground(imageName: Constant.BackgroundName.basketball)
        setNavigationBar()
        setTableView()
    }

    func setTableView() {
        let nib = UINib(nibName: Constant.Cell.court, bundle: nil)
        courtsTableView.register(nib, forCellReuseIdentifier: Constant.Cell.court)
    }

    func setCourts() {

//        Blah().rest()
        // MARK: Loading indicator
        loadingIndicator.start()

//        BasketballCourtsProvider().getApiData(city: "高雄市", gymType: "籃球場") { (basketballCourts, error) in
//
        BasketballCourtsProvider().getApiData(city: Constant.CurrentCity.cityName, gymType: Constant.GymType.basketball) { (basketballCourts, error) in

            if error == nil {

                self.basketballCourts = basketballCourts!
                self.courtsTableView.reloadData()

            } else {

                // todo: error handling

            }

            self.loadingIndicator.stop()
        }
    }
}

// MARK: NavigationBar
extension BasketballCourtsViewController {

    func setNavigationBar() {

        transparentizeNavigationBar(navigationController: self.navigationController)

        navigationItem.leftBarButtonItem = createBackButton(action: #selector(backToSportMenuViewController))
        setNavigationDropdownMenu()

    }

    func setNavigationDropdownMenu() {
        let menuView = BTNavigationDropdownMenu(title: items[Constant.CurrentCity.cityIndex], items: items as [Any] as! [String])
        self.navigationItem.titleView = menuView

        menuView.didSelectItemAtIndexHandler = { [weak self] (indexPath: Int) -> Void in

            if let city = self?.items[indexPath] {
                Constant.CurrentCity.cityIndex = indexPath
                Constant.CurrentCity.cityName = city

                self?.setCourts()
            }
        }

        menuView.menuTitleColor = .white
        menuView.selectedCellTextLabelColor = .gray
        menuView.cellTextLabelColor = .white
        menuView.cellSelectionColor = .gray
        menuView.cellSeparatorColor = .white
        menuView.cellBackgroundColor = .darkGray
    }
}

// MARK: TableView
extension BasketballCourtsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.basketballCourts.count == 0 {
            let view = UIView()
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = "此地區尚無任何場地"
            label.textColor = .white
            view.addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(10)
            }
            return view
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard basketballCourts.count != 0 else { return 0 }
        return basketballCourts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.court,
                                                     for: indexPath) as? CourtTableViewCell,
            basketballCourts[indexPath.row].name != ""
            else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        cell.courtName.text = basketballCourts[indexPath.row].name
        cell.courtName.textColor = .white
        cell.courtName.adjustsFontSizeToFitWidth = true

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyBoard = UIStoryboard(name: Constant.Storyboard.basketballCourtDetail, bundle: nil)

        guard
            let basketballCourtDetailViewController = storyBoard.instantiateViewController(withIdentifier: Constant.Controller.basketballCourtDetail) as? BasketballCourtDetailViewController
            else { return }

        basketballCourtDetailViewController.basketballCourt = basketballCourts[indexPath.row]
        self.navigationController?.pushViewController(basketballCourtDetailViewController, animated: true)
    }
}
