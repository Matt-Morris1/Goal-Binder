//
//  ViewController.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/1/22.
//

import UIKit

protocol ListGoalsDelegate: AnyObject {
    func refreshGoals()
    func deleteGoal(with id: UUID)
}

class TableViewController: UITableViewController {
    
    private var allGoals: [Goal] = [] {
        didSet {
            filteredGoals = allGoals
        }
    }
    
    private var filteredGoals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Goals"
        view.backgroundColor = UIColor(white: 0.94, alpha: 1)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Goal", style: .done, target: self, action: #selector(addGoal))
        
        tableView.rowHeight = 74
        tableView.separatorColor = .gray
        
        fetchGoalsFromStorage()
    }
    
    private func indexForGoal(id: UUID, in list: [Goal]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    //MARK: -Implementation Methods
    
    private func goToEditGoal(_ goal: Goal) {
        let controller = storyboard?.instantiateViewController(identifier: "GoalViewController") as! GoalViewController
        controller.goal = goal
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func fetchGoalsFromStorage() {
        allGoals = CoreDataManager.shared.fetchGoals()
    }
    
    func deleteGoalFromStorage(_ goal: Goal) {
        deleteGoal(with: goal.id)
        CoreDataManager.shared.deleteGoal(goal)
    }
    
    @objc func addGoal() {
        goToEditGoal(createGoal())
    }
    
    func createGoal() -> Goal {
        let goal = CoreDataManager.shared.createGoal()
        
        allGoals.insert(goal, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        return goal
    }

    
    //MARK: - TableView Setup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGoals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
//        cell.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        cell.backgroundColor = .systemPurple.withAlphaComponent(0.6)
        cell.setUp(goal: filteredGoals[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditGoal(filteredGoals[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteGoalFromStorage(filteredGoals[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//MARK: - ListGoals Delegate

extension TableViewController: ListGoalsDelegate {
    
    func refreshGoals() {
        allGoals = allGoals.sorted { $0.lastUpdated > $1.lastUpdated }
        tableView.reloadData()
    }
    
    func deleteGoal(with id: UUID) {
        let indexPath = indexForGoal(id: id, in: filteredGoals)
        filteredGoals.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        // just so that it doesn't come back when we search from the array
        allGoals.remove(at: indexForGoal(id: id, in: allGoals).row)
        print("Goal deleted")
    }
}
