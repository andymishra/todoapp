//
//  TaskViewModel.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation

struct TaskViewModel: Identifiable {
	var id: UUID
	var title: String
	var description: String
	var category: String
	var createdDate: Date
}
	
