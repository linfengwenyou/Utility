//
//  ViewController.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self .testForUrl()
        //            testForHtml()
    }
    
    // 传入URL
    func testForUrl() {
        let vc = LBKWebController(url: URL(string: "https://m.lbk.world/zh-TC/js-bridge")!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 传入html
    func testForHtml() {
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html"),
           let html = try? String(contentsOfFile: filePath, encoding: .utf8) {
            
            let baseUrl = URL(string: filePath)?.deletingLastPathComponent()
            
            let vc = LBKWebController(html: html,baseURL: baseUrl)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

