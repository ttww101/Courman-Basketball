//
//  Constant.swift
//  SportBuddy
//
//  Created by steven.chou on 2017/3/20.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct Constant {

    struct AppName {

        static let appName = NSLocalizedString("SportBuddy", comment: "")
    }

    struct SportItem {

        static let basketball = "Basketball"
    }

    struct Storyboard {

        static let login = "Login"
        static let signUp = "SignUp"
        static let sportItems = "SportItems"
        static let editProfile = "EditProfile"
        static let chooseLevel = "ChooseLevel"
        static let basketball = "Basketball"
        static let basketballCourtDetail = "BasketballCourtDetail"
        static let newBasketballGame = "NewBasketballGame"
        static let basketballGameDetail = "BasketballGameDetail"
    }

    struct Controller {

        static let login = "LoginViewController"
        static let signUp = "SignUpViewController"
        static let sportItems = "SportItemsViewController"
        static let editProfile = "EditProfileViewController"
        static let chooseLevel = "ChooseLevelViewController"
        static let basketballTabbar = "BasketballTabbarViewController"
        static let basketballGames = "BasketballGamesViewController"
        static let basketballCourt = "BasketballCourtsViewController"
        static let basketballProfile = "BasketballProfileViewController"
        static let basketballCourtDetail = "BasketballCourtDetailViewController"
        static let newBasketballGame = "NewBasketballGameViewController"
        static let basketballGameDetail = "BasketballGameDetailViewController"
    }

    struct BackgroundName {

        static let login = "BG_Login"
        static let basketball = "BG_Basketball"
    }

    struct Gender {

        static let male = "Male"
        static let female = "Female"
    }

    struct Firebase {

        static let dbUrl = "https://agt-basketball-courtman.firebaseio.com"
    }

    struct FirebaseUser {

        static let nodeName = "Users/"
        static let email = "Email"
        static let name = "Name"
        static let gender = "Gender"
        static let photoURL = "PhotoURL"
        static let playedGamesCount = "PlayedGamesCount"
        static let lastTimePlayedGame = "LastTimePlayedGame"
    }

    struct FirebaseUserGameList {

        static let nodeName = "UserGameList"
    }

    struct FirebaseLevel {

        static let nodeName = "Levels"
        static let basketball = "Basketball"
        static let baseball = "Baseball"
        static let jogging = "Jogging"
    }

    struct FirebaseGame {

        static let nodeName = "Games"
        static let gameID = "GameID"
        static let owner = "Owner"
        static let itme = "Item"
        static let name = "Name"
        static let time = "Time"
        static let court = "Court"
        static let level = "Level"
        static let members = "Members"
    }

    struct FirebaseGameMessage {

        static let nodeName = "GameMessages"
        static let gameID = "GameID"
        static let userID = "UserID"
        static let comment = "Comment"
    }

    struct FirebaseStorage {

        static let userPhoto = "UserPhoto"
    }

    struct Cell {

        static let game = "GameTableViewCell"
        static let gameDefault = "GameDefaultTableViewCell"
        static let court = "CourtTableViewCell"
    }

    struct CourtInfo {

        static let courtID = "GymID"
        static let name = "Name"
        static let tel = "OperationTel"
        static let address = "Address"
        static let rate = "Rate"
        static let rateCount = "RateCount"
        static let gymFuncList = "GymFuncList"
        static let latitude = "Latitude"
        static let longitude = "Longitude"
    }

    struct CourtAPIKey {

        static let courtID = "GymID"
        static let name = "Name"
        static let tel = "OperationTel"
        static let address = "Address"
        static let rate = "Rate"
        static let rateCount = "RateCount"
        static let gymFuncList = "GymFuncList"
        static let latlng = "LatLng"
    }

    struct ObjectValue {

        static let navigationBarBackItemTitle = "Sport Items"
    }

    struct CurrentCity {

        static var cityIndex = 0
        static var cityName = "臺北市"
    }

    struct GymType {

        static let basketball = "籃球場"
    }

    struct WeatherDecs {

        static let clear = "晴"
        static let cloudy = "雲"
        static let rainy = "雨"
    }

    struct ImageName {

        // User
        static let userDefaultPhoto = "Default_User_Photo"

        // Weather
        static let weatherClear = "Weather_Clear"
        static let weatherCloudy = "Weather_Cloudy"
        static let weatherPartlyClear = "Weather_PartlyClear"
        static let weatherRainy = "Weather_Rainy"
        static let weatherStorm = "Weather_Storm"

        // Fixing
        static let fixing = "Fixing"
    }

    struct UserNotifacationIdentifier {

        static let comeBackToPlayGame = "comeBackToPlayGame"
    }

    struct UserNotifacationContent {

        static let title = "該運動囉!"
        static let body = "距離上次運動已經有一陣子了吧? 事務繁忙也得重視一下自己的健康, 不少運動夥伴們正等著您的加入他們呢! 快來一起運動吧!"
    }
}
