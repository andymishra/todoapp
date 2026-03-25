//
//  ToDoTaskManagerApp.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import SwiftUI

@main
struct ToDoTaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            TaskModuleBuilder.build()
        }
    }
}
