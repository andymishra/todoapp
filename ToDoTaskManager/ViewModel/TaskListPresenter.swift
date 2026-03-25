//
//  TaskListPresenter.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation
import SwiftUI
import Combine

class TaskListPresenter: ObservableObject, TaskListInteractorOutputProtocol {
	
	@Published var tasks: [TaskViewModel] = []
	@Published var errorMessage: String?
	
	var interactor: TaskListInteractorProtocol?
	
	func fetchTasks() {
		_ = interactor?.fetchTasks()
	}
	
	@MainActor
	func didFetchTasks(_ tasks: [ToDoTask]) {
		self.tasks = tasks.map { task in
			TaskViewModel(
				id: task.id,
				title: task.title,
				description: task.description,
				category: task.category,
				createdDate: task.createdAt
			)
		}
	}
	
	@MainActor
	func didFailToFetchTasks(withError error: Error) {
		self.errorMessage = error.localizedDescription
	}
}
