//
//  SettingHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct SettingHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("データ管理") {
                    NavigationLink {
                        CategoryManagementView()
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("カテゴリ管理")
                                .font(.headline)
                            Text("収入・支出のカテゴリを追加・編集・削除できます")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("設定")
            .logScreenAppeared()
        }
    }
}

#Preview {
    SettingHomeView()
}
