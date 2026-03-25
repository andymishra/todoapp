//
//  TaskDTO.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

struct TaskDTO: Codable {
	let id: String
	let title: String
	let description: String
	let category: String
	let createdDate: String
	let priority: String
	let dueDate: String
	let isCompleted: Bool

	
	func toTask() -> ToDoTask {
		return ToDoTask(
			id: UUID(uuidString: id) ?? UUID(),
			title: title,
			description: description,
			category: category,
			createdAt: ISO8601DateFormatter().date(from: createdDate) ?? Date(),
			priority: Priority(rawValue: priority) ?? .medium,
			dueDate: ISO8601DateFormatter().date(from: dueDate) ?? Date(),
			isCompleted: isCompleted
		)
	}
	
}
