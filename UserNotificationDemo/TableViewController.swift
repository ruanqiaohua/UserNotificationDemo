//
//  TableViewController.swift
//  UserNotificationDemo
//
//  Created by 阮巧华 on 2017/3/6.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 请求通知权限
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        center.delegate = self

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            showMessage()
        case 1:
            showImage()
        case 2:
            showVideo()
        default:
            break
        }
    }
    // 显示文字
    func showMessage() {
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        // title 和 body 要写才能弹出
        content.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello World !", arguments: nil)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Hello", content: content, trigger: trigger)
        center.add(request)
    }
    // 显示图片
    func showImage() {
    
        // 网络图片地址，可能失效
        let webImageUrl = URL(string:"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488778145204&di=7d510f8ba555ce7d5a250649fcf2c957&imgtype=0&src=http%3A%2F%2Fimg.sj33.cn%2Fuploads%2Fallimg%2F201503%2F7-150303234610.jpg")
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        // title 和 body 要写才能弹出
        content.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello World !", arguments: nil)

        downloadAndSave(url: webImageUrl!) { [weak self] (url) in
            guard ((url) != nil) else {
                return
            }
            do {
                let attachment = try UNNotificationAttachment(identifier: "image_downloaded", url: url!, options: nil)
                content.attachments = [attachment]
            } catch {
                print(error)
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "image", content: content, trigger: trigger)
            self?.center.add(request)
        }
    }
    // 显示视频
    func showVideo() {
        
        // 网络视频地址，可能失效
        let webVideoUrl = URL(string:"http://www.w3school.com.cn/example/html5/mov_bbb.mp4");
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        // title 和 body 要写才能弹出
        content.title = NSString.localizedUserNotificationString(forKey: "Hello", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello World !", arguments: nil)

        downloadAndSave(url: webVideoUrl!) { [weak self] (url) in
            guard ((url) != nil) else {
                return
            }
            do {
                let attachment = try UNNotificationAttachment(identifier: "video_downloaded", url: url!, options: nil)
                content.attachments = [attachment]
            } catch {
                print(error)
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "video", content: content, trigger: trigger)
            self?.center.add(request)
        }
    }
    // 缓存资源 (block回调 返回值localURL是可选型，所以需要判断nil)
    private func downloadAndSave(url: URL, handler: @escaping (_ localURL: URL?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, res, error in
            var localURL: URL? = nil
            if let data = data {
                let ext = (url.absoluteString as NSString).pathExtension
                let cacheURL = URL(fileURLWithPath: NSTemporaryDirectory())
                let imageName = arc4random_uniform(1000)// 随机文件名
                let url = cacheURL.appendingPathComponent(String(imageName)).appendingPathExtension(ext)
                if let _ = try? data.write(to: url) {
                    localURL = url
                }
            }
            handler(localURL)
        })
        task.resume()
    }

    // MARK - UNUserNotificationCenterDelegate
    // 需要前台展示的时候才需要实现代理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    
    
}
