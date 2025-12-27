//
//  BaseHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct BaseHomeView: View {
    var body: some View {
        TabView {
            TopHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
            }
            
            InputHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
            }

            GameHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
            }
            
            HistoryHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
            }
            
            SettingHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
            }
        }
    }
}

#Preview {
    BaseHomeView()
}
