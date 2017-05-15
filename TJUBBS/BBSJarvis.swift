//
//  BBSJarvis.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

struct BBSJarvis {
    
    static func login(username: String, password: String, failure: ((Error)->())? = nil, success:@escaping ()->()) {
        let para: [String : String] = ["username": username, "password": password]
        BBSBeacon.request(withType: .post, url: BBSAPI.login, parameters: para) { dict in
            if let data = dict["data"] as? [String: Any] {
                BBSUser.shared.uid = data["uid"] as? Int
                BBSUser.shared.group = data["group"] as? Int
                BBSUser.shared.token = data["token"] as? String
                BBSUser.shared.username = username
                // 用 UserDefaults 存起来 BBSUser.shared
                BBSUser.save()
            }
            success()
        }
    }
    
    static func register(parameters: [String : String], failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .post, url: BBSAPI.register, parameters: parameters, failure: failure, success: success)
    }
    
    static func getHome(success: (()->())?, failure: @escaping ()->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.home, parameters: nil) { dict in
            if let data = dict["data"] as? [String: Any],
                let name = data["name"],
                let nickname = data["nickname"],
                //                let real_name = data["real_name"],
                let signature = data["signature"],
                let post_count = data["c_post"],
                let unread_count = data["c_unread"],
                let points = data["points"],
                let level = data["level"],
                let c_online = data["c_online"],
                let group = data["group"] {
                BBSUser.shared.username = name as? String
                BBSUser.shared.nickname = nickname as? String
                //                BBSUser.shared.realName = real_name as? String
                BBSUser.shared.signature = signature as? String
                BBSUser.shared.postCount = post_count as? Int
                BBSUser.shared.unreadCount = unread_count as? Int
                BBSUser.shared.points = points as? Int
                BBSUser.shared.level = level as? Int
                BBSUser.shared.cOnline = c_online as? Int
                BBSUser.shared.group = group as? Int
                BBSUser.save()
            } else if let err = dict["err"] as? Int, err == 0 {
                failure()
            }
        }
    }
    
    static func getAvatar(success:@escaping (UIImage)->(), failure: @escaping ()->()) {
        BBSBeacon.requestImage(url: BBSAPI.avatar, success: success)
    }
    
    static func setAvatar(image: UIImage, success:@escaping ()->(), failure: @escaping (Error)->()) {
        BBSBeacon.uploadImage(url: BBSAPI.setAvatar, image: image, failure: failure, success: success)
    }
    
    static func getForumList(failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.forumList, token: nil, parameters: nil, failure: failure, success: success)
    }
    
    static func getBoardList(forumID: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.boardList(forumID: forumID), token: nil, parameters: nil, failure: failure, success: success)
    }
    
    static func getThreadList(boardID: Int, page: Int, type: String = "", failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        print("API:\(BBSAPI.threadList(boardID: boardID, page: page, type: type))")
        BBSBeacon.request(withType: .get, url: BBSAPI.threadList(boardID: boardID, page: page, type: type), parameters: nil, success: success)
    }

    //TODO: cache Homepage
    static func getIndex(failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.index, parameters: nil, success: success)
    }
    
    static func getThread(threadID: Int, page: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.thread(threadID: threadID, page: page), parameters: nil, success: success)

    static func setPersonalInfo(para: [String : String], success: ()->(), failure: ()->()) {
        
    }
    
    static func postThread(boardID: Int, title: String, content: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = [
            "title": title,
            "content": content
        ]
        print("API:\(BBSAPI.postThread(boardID: boardID))")
        print(parameters)
        BBSBeacon.request(withType: .post, url: BBSAPI.postThread(boardID: boardID), parameters: parameters, success: success)
    }
}