//
//  LBKWebMessageModel.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation

// native->JS使用的模型
struct LBKSendMessageMode {
    let code: Int
    let cmd: String
    let clientcallid: String?
    let message: String?
    var data: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "code": code,
            "cmd": cmd,
            "data": data
        ]
        if let clientcallid = clientcallid {
            dict["clientcallid"] = clientcallid
        }
        if let message = message {
            dict["message"] = message
        }
        
        return dict
    }
    
    func toJSONString() -> String? {
        var dict: [String: Any] = [
            "code": code,
            "message": message,
            "cmd": cmd,
            "data": data
        ]
        if let clientcallid = clientcallid {
            dict["clientcallid"] = clientcallid
        }
        
        return dict.toJsonString()
    }
}

extension Dictionary {
    func toJsonString() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        } else {
            return nil
        }
    }
}


extension String {
    
    // 转换为JSON对象，比如字典
    func jsonObject() -> Any? {
        guard let data = self.data(using: .utf8) else {return nil}
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    
    func jsString() -> String {
        return self
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
    }
}
