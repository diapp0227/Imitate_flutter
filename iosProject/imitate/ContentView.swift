//
//  ContentView.swift
//  imitate
//
//  Created by garigari0118 on 2025/08/17.
//

import SwiftUI
import Flutter

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text(viewModel.helloWorldText)
            Button("update") {
                viewModel.loadHelloWorld(appDelegate)
            }
        }
        .padding()
    }
}

class ContentViewModel: ObservableObject {
    @Published var helloWorldText = "initial Hello World"
    private let hellowWorldRepository = HellowWorldRepository()
    
    func loadHelloWorld(_ appDelegate: AppDelegate) {
        hellowWorldRepository.fetch { result in
            self.helloWorldText = result
        }
    }
}

class HellowWorldRepository {
    
    func fetch(completion: @escaping ((String) -> Void)) {
        FlutterEngineManager.shared.channel?.invokeMethod("fetch", arguments: nil) { result in
            var helloWorldString = ""
            
            if let error = result as? FlutterError {
                helloWorldString = "Error: \(error.message ?? "Unknown error")"
            } else if result == nil {
                helloWorldString = "No result returned"
            } else if let resultString = result as? String {
                helloWorldString = resultString
            } else {
                helloWorldString = "failed loadHelloWorld()"
            }
            
            completion(helloWorldString)
        }
    }
}

#Preview {
    ContentView()
}
