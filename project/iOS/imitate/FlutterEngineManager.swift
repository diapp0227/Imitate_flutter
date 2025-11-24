//
//  FlutterEngineManager.swift
//  imitate
//
//  Created by garigari0118 on 2025/08/17.
//

import Flutter

class FlutterEngineManager {
    
    static let shared = FlutterEngineManager()
    
    private(set) var flutterEngine: FlutterEngine?
    
    private(set) var channel: FlutterMethodChannel?
    
    func initialize() {
        flutterEngine = FlutterEngine(name: "HellowWorldRepository")
        flutterEngine?.run()
        
        setChannel()
    }
    
    func setChannel() {
        guard let flutterEngine = flutterEngine else {
            return
        }
        channel = FlutterMethodChannel(name: "HelloWorldRepository", binaryMessenger: flutterEngine.binaryMessenger)
    }
}
