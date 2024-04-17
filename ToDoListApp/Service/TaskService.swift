//
//  TaskService.swift
//  ToDoListApp
//
//  Created by Caner Karabulut on 25.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TaskService {
    
    static private var pastTasks = [TaskModel]()
    
    static func sendItem(taskText: String, headerText: String, calendar: [String : Any],endDate: Date?, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let taskID = NSUUID().uuidString
        var data = [
            "header": headerText,
            "text": taskText,
            "timestamp": Timestamp(date: Date()),
            "taskID": taskID
        ] as [String : Any]
        data["calendar"] = calendar
        if let endDate = endDate {
            data["endDate"] = endDate
        }
        Firestore.firestore().collection("tasks").document(currentUid).collection("ongoing_tasks").document(taskID).setData(data, completion: completion)
    }
    static func fetchUser(uid: String, completion: @escaping (UserModel) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let user = UserModel(data: data)
            completion(user)
        }
    }
    static func fetchTask(uid: String, completion: @escaping ([TaskModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var tasks = [TaskModel]()
        Firestore.firestore().collection("tasks").document(uid).collection("ongoing_tasks").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ value in
                if value.type == .added {
                    let data = value.document.data()
                    tasks.append(TaskModel(data: data))
                    completion(tasks)
                }
            })
        }
    }
    static func deleteTask(task: TaskModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            var data = [
                "header": task.header,
                "text": task.text,
                "timestamp": Timestamp(date: Date()),
                "taskID": task.taskId,
            ] as [String : Any]
            data["calendar"] = task.calendar
        Firestore.firestore().collection("tasks").document(uid).collection("deleted_tasks").document(task.taskId).setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
                return
            }
            Firestore.firestore().collection("tasks").document(uid).collection("ongoing_tasks").document(task.taskId).delete { error in
                completion(error)
            }
        }
    }
    static func fetchPastTask(uid: String, completion: @escaping ([TaskModel]) -> Void) {
        Firestore.firestore().collection("tasks").document(uid).collection("deleted_tasks").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            var deletedTasks = [TaskModel]()
            if let documents = snapshot?.documents {
                documents.forEach { document in
                    let data = document.data()
                    deletedTasks.append(TaskModel(data: data))
                }
            }
            completion(deletedTasks)
        }
    }
    static func markTaskAsCompleted(task: TaskModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("tasks").document(uid).collection("ongoing_tasks").document(task.taskId).delete { error in
            if let error = error {
                completion(error)
                return
            }
            var updatedTask = task
            updatedTask.isCompleted = true
            Firestore.firestore().collection("tasks").document(uid).collection("completed_tasks").document(task.taskId).setData(updatedTask.dictionary) { error in
                completion(error)
            }
        }
    }
    static func fetchCompletedTasks(uid: String, completion: @escaping ([TaskModel]) -> Void) {
        Firestore.firestore().collection("tasks").document(uid).collection("completed_tasks").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            var completedTasks = [TaskModel]()
            if let documents = snapshot?.documents {
                documents.forEach { document in
                    let data = document.data()
                    completedTasks.append(TaskModel(data: data))
                }
            }
            completion(completedTasks)
        }
    }
}
