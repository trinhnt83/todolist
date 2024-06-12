//
//  ViewController.swift
//  NoStoryBoard
//
//  Created by Trinh Nguyen on 2024/06/10.
//

import UIKit

struct Todo {
    var todo: String
    var date: Date
}

class ViewController: UITableViewController {
    
    fileprivate let cellId = "cellID"
    fileprivate var todos:[Todo] = [
      //  Todo(todo: "This is a todo", date: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .purple
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddTap))
        //retriveTodo()
    }
    
    @objc func handleAddTap() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a todo"
        }
        alert.addAction(UIAlertAction(title: "Add note", style: .default, handler: { (action) in
            guard let textField = alert.textFields?.first else { return }
            guard let text = textField.text else { return }
            guard text != "" else { return }
            self.todos.append(Todo(todo: text, date: Date()))
            self.tableView.beginUpdates()
            let indexPath = IndexPath(row: self.todos.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            self.save()
        }))
            
        present(alert, animated: true)
    }
    
    func save() {
        print("Saving...")
        var todosToBeSaved:[String] = []
        var datesToBeSaved:[Date] = []
        for todo in todos {
            todosToBeSaved.append(todo.todo)
            datesToBeSaved.append(todo.date)
        }
        UserDefaults.standard.setValue(todosToBeSaved, forKey: "todo")
        UserDefaults.standard.setValue(datesToBeSaved, forKey: "date")
    }
    
    func retriveTodo() {
        guard let savedTodos = UserDefaults.standard.object(forKey: "todo") as? [String] else { return }
        guard let savedDates = UserDefaults.standard.object(forKey: "date") as? [String] else { return }
        for i in 1...savedTodos.count {
           // todos.append(Todo(todo: savedTodos[i-1], date: savedDates[i-1]))
        }
    }

    func formatDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = todos[indexPath.row].todo
        cell.detailTextLabel?.text = formatDate(date: todos[indexPath.row].date, format: "dd/MM/yyyy hh:mm:ss")
        return cell
    }
}

