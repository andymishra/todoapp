//
//  TaskModuleBuilder.swift
//  ToDoTaskManager
//
//  Created by Anand.Mishra on 24/03/26.
//

import SwiftUI

struct TaskModuleBuilder {
	
	static func build() -> some View {
		let repository = TaskRepository()
		
		let interactor = TaskListInteractor(repository: repository)
		
		let presenter = TaskListPresenter()
		presenter.interactor = interactor
		
		interactor.output = presenter
		
		let view = TaskListView(presenter: presenter)
		
		return view
	}
		
}
