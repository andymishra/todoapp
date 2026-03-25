//
//  TaskListView.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation
import SwiftUI

struct TaskListView: View {
	@StateObject var presenter: TaskListPresenter
	
	var body: some View {
		NavigationView {
			Group {
				if let errorMessage = presenter.errorMessage {
					Text(errorMessage)
						.foregroundColor(.red)
						.padding()
					
				} else if presenter.tasks.isEmpty {
					Text("No tasks available.")
						.foregroundColor(.gray)
						.padding()
				} else {
					List(presenter.tasks) { task in
						VStack(alignment: .leading) {
							Text(task.title)
								.font(.headline)
							Text(task.description)
								.font(.subheadline)
								.foregroundColor(.secondary)
						}
					}
				}
			}
		}.navigationTitle("Task Manager")
			.onAppear {
				presenter.fetchTasks()
			}
							
	}
}

