//
//  ToDoTask.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

struct ToDoTask: Identifiable {
	var id: UUID = UUID()
	var title: String
	var description: String
	var category: String
	var createdAt: Date
	var priority: Priority
	var dueDate: Date
	var isCompleted: Bool = false
}

enum Priority: String {
	case low = "Low"
	case medium = "Medium"
	case high = "High"	
}
