//
//  LaunchView.swift
//  imitate
//
//  Created by garigari0118 on 2025/08/17.
//

import SwiftUI
import Flutter

struct LaunchView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    @EnvironmentObject var appDelegate: AppDelegate
    
    let items = FunctionList.allCases
    
    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                Text(item.rawValue)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapListFunction(function: item)
                    }
            }
            .listStyle(PlainListStyle())
        }
// Flutter接続は一旦コメントアウト
//        VStack {
//            Text(viewModel.helloWorldText)
//            Button("update") {
//                viewModel.loadHelloWorld(appDelegate)
//            }
//        }
//        .padding()
    }
    
    func tapListFunction(function: FunctionList) {
        print("\(#function): \(function.rawValue)")
        switch function {
        case .helloWorld:
            viewModel.loadHelloWorld(appDelegate)
        default:
            print("todo")
        }
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

enum FunctionList: String, CaseIterable {
    case helloWorld = "HelloWorld"
    case test01
    case test02
    case test03
    case test04
    case test05
}

#Preview {
    LaunchView()
}
