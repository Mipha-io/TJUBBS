//
//  SetInfoViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class SetInfoViewController: UIViewController {
    var tableView: UITableView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑资料"
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SetInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 80
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                let imgView = UIImageView(frame: CGRect(x: 15, y: 9, width: 60, height: 60))
                cell.addSubview(imgView)
                imgView.image = BBSUser.shared.avatar ?? UIImage(named: "头像")
                imgView.layer.cornerRadius = 30
                imgView.layer.masksToBounds = true
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = "编辑头像"
                return cell
            case 1:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                cell.textLabel?.text = "昵称"
                cell.detailTextLabel?.text = BBSUser.shared.nickname
                cell.accessoryType = .disclosureIndicator
                return cell
            case 2:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                cell.textLabel?.text = "签名"
                cell.detailTextLabel?.text = BBSUser.shared.signature
                cell.accessoryType = .disclosureIndicator
                return cell
            default:
                break
            }
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
            cell.textLabel?.text = "修改密码"
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.modalPresentationStyle = .overCurrentContext
                let alertVC = UIAlertController()
                alertVC.view.tintColor = UIColor.black
                
                let pictureAction = UIAlertAction(title: "从相册中选择图片", style: .default) { _ in
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.allowsEditing = true
                        imagePicker.sourceType = .savedPhotosAlbum
                        self.present(imagePicker, animated: true) {
                            
                        }
                    } else {
                        HUD.flash(.label("相册不可用🤒请在设置中打开 BBS 的相册权限"), delay: 2.0)
                    }
                }
                let photoAction = UIAlertAction(title: "拍照", style: .default) { _ in
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.allowsEditing = true
                        imagePicker.sourceType = .camera
                        self.present(imagePicker, animated: true) {
                            
                        }
                    } else {
                        HUD.flash(.label("相机不可用🤒请在设置中打开 BBS 的相机权限"), delay: 2.0)
                    }
                }
                let detailAction = UIAlertAction(title: "查看大图", style: .default) { _ in
                    // TODO: 默认头像 or 错误
                    let detailVC = ImageDetailViewController(image: BBSUser.shared.avatar ?? UIImage(named: "头像")!)
                        
                    self.modalPresentationStyle = .overFullScreen
                    self.present(detailVC, animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertVC.addAction(pictureAction)
                alertVC.addAction(photoAction)
                alertVC.addAction(detailAction)
                alertVC.addAction(cancelAction)
                self.present(alertVC, animated: true) {
                    print("foo")
                }
            case 1:
                let setUsernameVC = InfoModifyController(title: "编辑昵称", items: [" - -nickname"], style: .rightTop, handler: nil)
                setUsernameVC.handler = { [weak setUsernameVC] result in
                    BBSJarvis.setInfo(para: result as! [String : String], success: {
                        BBSUser.shared.nickname = (result as! [String : String])["nickname"]
                        HUD.flash(.label("修改成功🎉"), delay: 1.0)
                    }, failure: { _ in
//                        HUD.flash(.labeledError(title: "修改失败...请稍后再试", subtitle: nil), delay: 1.0)
                    })
                    let _ = setUsernameVC?.navigationController?.popViewController(animated: true)
                }
                setUsernameVC.headerMsg = "请输入新昵称"
                self.navigationController?.pushViewController(setUsernameVC, animated: true)
            case 2:
                let setSignatureVC = InfoModifyController(title: "编辑签名", style: .custom, handler: nil)
                setSignatureVC.handler = { [weak setSignatureVC] str in
                    let para = ["signature": str as! String]
                    BBSJarvis.setInfo(para: para, success: {
                        BBSUser.shared.signature = str as? String
                        HUD.flash(.label("修改成功🎉"), delay: 1.0)
                    }, failure: { _ in
//                        HUD.flash(.labeledError(title: "修改失败...请稍后再试", subtitle: nil), delay: 1.0)
                    })
                    let _ = setSignatureVC?.navigationController?.popViewController(animated: true)
                }
                let contentView = UIView()
                contentView.backgroundColor = UIColor.white
                let textView = UITextView()
                contentView.addSubview(textView)
                textView.snp.makeConstraints { make in
                    make.top.equalTo(contentView).offset(18)
                    make.left.equalTo(contentView).offset(20)
                    make.right.equalTo(contentView).offset(-20)
                    make.height.equalTo(100)
                }
                
                let label = UILabel()
                label.text = "0/50字"
                label.font = UIFont.systemFont(ofSize: 13)
                contentView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.top.equalTo(textView.snp.bottom).offset(10)
                    make.right.equalTo(contentView).offset(-20)
                    make.bottom.equalTo(contentView).offset(-10)
                }
                contentView.snp.makeConstraints { make in
                    make.width.equalTo(UIScreen.main.bounds.size.width)
//                    make.height.equalTo(150)
                }
                textView.delegate = setSignatureVC
                setSignatureVC.customView = contentView
                setSignatureVC.customCallback = { count in
                    if let count = count as? Int {
                        label.text = "\(count)/50字"
                    }
                }
                self.navigationController?.pushViewController(setSignatureVC, animated: true)
            default:
                return
            }
        case 1:
            let setPasswordVC = InfoModifyController(title: "修改密码", items: ["旧密码-请输入旧密码-old_password-s", "新密码-请输入新密码-password-s", "确认密码-请输入新密码-repass-s"], style: .rightTop, handler: nil)
            let check: ([String : String])->(Bool) = { result in
                guard result["repass"] == result["password"] else {
                    HUD.flash(.label("两次密码不符！请重新输入👀"), delay: 1.2)
                    return false
                }
                return true
            }
            setPasswordVC.handler = { [weak setPasswordVC] result in
                if let result = result as? [String : String]{
                    if check(result) == true {
                        var para = result
                        para.removeValue(forKey: "repass")
                        BBSJarvis.setInfo(para: para, success: {
                            HUD.flash(.label("修改成功🎉请重新登录"), delay: 1.0)
                            BBSUser.delete()
                            let _ = self.navigationController?.popToRootViewController(animated: false)
                            let loginVC = LoginViewController(para: 1)
                            let loginNC = UINavigationController(rootViewController: loginVC)
                            self.present(loginNC, animated: true, completion: nil)
                        }, failure: { _ in
                            //                        HUD.flash(.labeledError(title: "修改失败...请稍后再试", subtitle: nil), delay: 1.0)
                        })
                    }
                }
                let _ = setPasswordVC?.navigationController?.popViewController(animated: true)

            }
            self.navigationController?.pushViewController(setPasswordVC, animated: true)
        default:
            return
        }
    }
}

extension SetInfoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let smallerImage = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 200, height: 200))
            BBSJarvis.setAvatar(image: smallerImage, success: {
                BBSUser.shared.avatar = smallerImage
                let cacheKey = "\(BBSUser.shared.uid!)" + Date.today
                ImageCache.default.removeImage(forKey: cacheKey)
                self.tableView.reloadData()
                HUD.flash(.label("头像设置成功🎉"), delay: 1.5)
            }, failure: { _ in
//                HUD.flash(.labeledError(title: "头像上传失败👀请稍后重试", subtitle: nil), delay: 1.5)
            })
            picker.dismiss(animated: true, completion: nil)
        } else {
            HUD.flash(.labeledError(title: "选择失败，请重试", subtitle: nil), onView: self.view)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SetInfoViewController: UINavigationControllerDelegate {
    
}

