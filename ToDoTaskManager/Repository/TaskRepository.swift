//
//  TaskRepository.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

protocol TaskRepositoryProtocol {
	func getTasks() async throws -> [ToDoTask]
}

class TaskRepository: TaskRepositoryProtocol {
	
	private let apiSource: APITaskDataSource
	
	init(apiSource: APITaskDataSource = APITaskDataSource()) {
		self.apiSource = apiSource
	}
	
	func getTasks() async throws -> [ToDoTask] {
		let dtos = try await apiSource.fetchRemoteTasks()
		return dtos.map { $0.toTask() }
	}
	
}
	

