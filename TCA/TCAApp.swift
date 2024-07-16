//
//  TCAApp.swift
//  TCA
//
//  Created by toby on 6/18/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct MyApp: App {
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: MyApp.store)
        }
    }
}

// view 면 @State 이거나 static let 이어야할듯
