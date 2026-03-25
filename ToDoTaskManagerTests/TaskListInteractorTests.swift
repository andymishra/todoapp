//
//  TaskListInteractorTests.swift
//  ToDoTaskManagerTests
//
//  Created by Anand.Mishra on 24/03/26.
//

import Foundation
import Testing

@testable import ToDoTaskManager

@MainActor
struct TaskListInteractorTests {
	
	// MARK: - Success Cases
	
	@Test func fetchTasks_deliversTasksToOutput() async {
		let mockRepo = MockTaskRepository()
		mockRepo.stubbedTasks = [
			ToDoTask(title: "Task 1", description: "Desc 1", category: "Work", createdAt: Date(), priority: .high, dueDate: Date(), isCompleted: false),
			ToDoTask(title: "Task 2", description: "Desc 2", category: "Personal", createdAt: Date(), priority: .low, dueDate: Date(), isCompleted: true)
		]
		let interactor = TaskListInteractor(repository: mockRepo)
		let spy = TaskListPresenterSpy()
		interactor.output = spy
				
		interactor.fetchTasks()
		
		await spy.waitTasks()
		
		#expect(spy.receivedTasks.count == 2)
		#expect(spy.receivedTasks[0].title == "Task 1")
		#expect(spy.receivedTasks[1].title == "Task 2")
		#expect(spy.didFailCalled == false)
	}
	
	@Test func fetchTasks_deliversEmptyArrayWhenRepoReturnsEmpty() async {
		let mockRepo = MockTaskRepository()
		mockRepo.stubbedTasks = []
		let interactor = TaskListInteractor(repository: mockRepo)
		let spy = TaskListPresenterSpy()
		interactor.output = spy
		
		interactor.fetchTasks()
		await spy.waitTasks()

		#expect(spy.receivedTasks.isEmpty)
		#expect(spy.didFailCalled == false)
	}
	
	// MARK: - Failure Cases
	
	@Test func fetchTasks_deliversErrorToOutputOnFailure() async {
		let mockRepo = MockTaskRepository()
		mockRepo.stubbedError = NSError(domain: "TestError", code: 42, userInfo: nil)
		let interactor = TaskListInteractor(repository: mockRepo)
		let spy = TaskListPresenterSpy()
		interactor.output = spy
		
		interactor.fetchTasks()
		
		await spy.waitTasks()
		
		#expect(spy.didFailCalled == true)
		#expect((spy.receivedError as? NSError)?.code == 42)
		#expect(spy.receivedTasks.isEmpty)
	}
	
	// MARK: - Output Not Set
	
	@Test func fetchTasks_doesNotCrashWhenOutputIsNil() async throws {
		let mockRepo = MockTaskRepository()
		mockRepo.stubbedTasks = [
			ToDoTask(title: "Task", description: "Desc", category: "Work", createdAt: Date(), priority: .medium, dueDate: Date())
		]
		let interactor = TaskListInteractor(repository: mockRepo)
		// output is nil — should not crash
		interactor.fetchTasks()
		
		// Give the internal Task time to complete
		try await Task.sleep(nanoseconds: 200_000_000)
		// No crash = pass
	}
	
	// MARK: - Multiple Fetches
	
	@Test func fetchTasks_canBeCalledMultipleTimes() async {
		let mockRepo = MockTaskRepository()
		mockRepo.stubbedTasks = [
			ToDoTask(title: "First", description: "Desc", category: "Work", createdAt: Date(), priority: .high, dueDate: Date())
		]
		let interactor = TaskListInteractor(repository: mockRepo)
		let spy = TaskListPresenterSpy()
		interactor.output = spy
		
		// First fetch
		interactor.fetchTasks()
		
		await spy.waitTasks()
		
		#expect(spy.receivedTasks.count == 1)
		#expect(spy.receivedTasks[0].title == "First")
		
		// Update stub and fetch again
		mockRepo.stubbedTasks = [
			ToDoTask(title: "Second", description: "Desc", category: "Personal", createdAt: Date(), priority: .low, dueDate: Date()),
			ToDoTask(title: "Third", description: "Desc", category: "Personal", createdAt: Date(), priority: .medium, dueDate: Date())
		]
		
		interactor.fetchTasks()
		
		await spy.waitTasks()
		
		#expect(spy.receivedTasks.count == 2)
		#expect(spy.receivedTasks[0].title == "Second")
	}
}

// MARK: - Mocks

class MockTaskRepository: TaskRepositoryProtocol {
	
	var stubbedTasks: [ToDoTask] = []
	var stubbedError: Error?
	
	func getTasks() async throws -> [ToDoTask] {
		if let error = stubbedError {
			throw error
		}
		return stubbedTasks
	}
}

class TaskListPresenterSpy: TaskListInteractorOutputProtocol {
	
	var receivedTasks: [ToDoTask] = []
	var didFailCalled = false
	var receivedError: Error?
	
	private var continuation: CheckedContinuation<Void, Never>?
	
	func didFetchTasks(_ tasks: [ToDoTask]) {
		receivedTasks = tasks
		continuation?.resume() // Wake up the test!
		continuation = nil
	}
	
	func waitTasks() async {
		await withCheckedContinuation { continuation in
			self.continuation = continuation
		}
	}
	
	func didFailToFetchTasks(withError error: Error) {
		didFailCalled = true
		receivedError = error
		continuation?.resume() // Wake up the test!
		continuation = nil
	}
}





