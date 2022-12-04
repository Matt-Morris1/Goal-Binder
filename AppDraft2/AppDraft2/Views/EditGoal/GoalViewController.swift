//
//  GoalViewController.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/1/22.
//

import UIKit

class GoalViewController: UIViewController {
    var textView: UITextView!
    var date = UIDatePicker()
    var dateLbl = UILabel()
    
    var goal: Goal!
    weak var delegate: ListGoalsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.94, alpha: 1)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18)
        textView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        textView.textColor = .black
        textView.text = goal?.body
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .onDrag


        date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .automatic
        date.backgroundColor = UIColor(red: 0.8, green: 0.6, blue: 1, alpha: 1)
        date.tintColor = .systemPurple.withAlphaComponent(0.8)
        date.layer.masksToBounds = true
        date.minimumDate = Date.now
        date.layer.cornerRadius = 10
        date.date = goal.date
        date.layer.zPosition = 1
        
        dateLbl = UILabel()
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.backgroundColor = UIColor(red: 0.73, green: 0.56, blue: 0.88, alpha: 1)
        dateLbl.text = "    Complete by:"
        dateLbl.layer.masksToBounds = true
        dateLbl.layer.cornerRadius = 10
        dateLbl.font = .systemFont(ofSize: 17)
        
        

        view.addSubview(textView)
        view.addSubview(date)
        view.addSubview(dateLbl)
        
        NSLayoutConstraint.activate([
            
            textView.topAnchor.constraint(equalTo: date.bottomAnchor),
            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            date.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            date.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateLbl.bottomAnchor.constraint(equalTo: textView.topAnchor),
            dateLbl.trailingAnchor.constraint(equalTo: date.trailingAnchor),
            dateLbl.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -120)
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func updateGoal() {
        print("Goal updated")
        goal.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshGoals()
    }
    
    private func deleteGoal() {
        print("Goal deleting")
        delegate?.deleteGoal(with: goal.id)
        CoreDataManager.shared.deleteGoal(goal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        goal.body = textView.text
        goal.date = date.date
        
        if goal.title.isEmpty {
            deleteGoal()
        } else {
        updateGoal()
        }
    }
        
}

//MARK: -Textview Delegate
//extension GoalViewController: UITextViewDelegate {
//
//}
