//
//  APITaskDataSource.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

protocol TaskDataSource {
	func fetchRemoteTasks() async throws -> [TaskDTO]
}

class APITaskDataSource: TaskDataSource {
	
	func fetchRemoteTasks() async throws -> [TaskDTO] {
		// In a real app, you'd use URLSession.shared.data(from: url)
		// For now, we simulate a network delay
		try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay
		
		let mockDTO = TaskDTO(id: "1", title: "Mock Task", description: "A mock task", category: "Personal", createdDate: "2026-03-24T12:34:56Z", priority: "High", dueDate: "2026-03-25T12:34:56Z", isCompleted: false)
		return [mockDTO]
	}
	
}

