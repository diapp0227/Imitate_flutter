//
//  FlutterEngineManager.swift
//  imitate
//
//  Created by garigari0118 on 2025/08/17.
//

import Flutter
import FlutterPluginRegistrant

class FlutterEngineManager {
    
    static let shared = FlutterEngineManager()
    
    private(set) var flutterEngine: FlutterEngine?
    
    private(set) var channel: FlutterMethodChannel?

    func initialize() {
        flutterEngine = FlutterEngine(name: "")
        flutterEngine?.run()
        setChannel()
    }
    
    func setChannel() {
        guard let flutterEngine = flutterEngine else {
            return
        }
        GeneratedPluginRegistrant.register(with: flutterEngine)
        channel = FlutterMethodChannel(name: "BalanceRecordRepository", binaryMessenger: flutterEngine.binaryMessenger)
    }
}
