//
//  TaskListInteractor.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

protocol TaskListInteractorProtocol {
	func fetchTasks()
}

protocol TaskListInteractorOutputProtocol: AnyObject {
	func didFetchTasks(_ tasks: [ToDoTask])
	func didFailToFetchTasks(withError error: Error)
}


class TaskListInteractor: TaskListInteractorProtocol {
	weak var output: TaskListInteractorOutputProtocol?
	
	private let repository: TaskRepositoryProtocol
	
	init(repository: TaskRepositoryProtocol) {
		self.repository = repository
	}
	
	func fetchTasks() {
		// Simulating fetching tasks from a data source
		Task {
			do {
				let tasks = try await repository.getTasks()
				// Filtering logic remains pure and easy to read
				output?.didFetchTasks(tasks)
			} catch {
				output?.didFailToFetchTasks(withError: error)
			}
		}
	}
}


