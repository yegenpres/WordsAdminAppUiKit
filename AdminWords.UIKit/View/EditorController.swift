//
//  WordRedactorController.swift
//  AdminWords.UIKit
//
//  Created by 111 on 06.09.2022.
//

import Foundation
import UIKit

class EditorController<T>: UIViewController {
    var editor: Editor!
    var data: T
    var confirmButton: UIButton!
    var confirmHandler: (T) -> Void
    
    
    override func viewDidLoad() {
        
        var frame = view.bounds
        frame.size.width = frame.size.width - 50
        editor = initEditor()
        view.addSubview(editor)
        confirmButton = UIButton(type: .system)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchDown)
        confirmButton.setTitle("Update", for: .normal)
        editor.container.addArrangedSubview(confirmButton)
        
        setupLayout()
            }
    
    func initEditor() -> Editor {
      fatalError("Use childsClasses")
    }
    
    init(data: T,  _ confirm: @escaping (T) -> Void) {
        self.data = data
        self.confirmHandler = confirm
        super.init(nibName: nil, bundle: Bundle.main )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func confirm() {
        print("confirm")
        confirmHandler(data)
    }
    
    func setupLayout() {
        editor.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -5).isActive = true

        
        editor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        editor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0).isActive = true
        editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0).isActive = true
    }
}

class WordEditor: EditorController<WordData> {
    override func initEditor() -> Editor {
        Editor(frame: view.frame) {field in
            field.SingleLine("word ID: ", String(data.wordID)) { value in
                guard let id = Int(value) else { return }
                self.data.wordID = id
            }
            
            field.SingleLine("English :", data.english) { value in
                self.data.english = value
            }
            
            field.Toggle("isUpdated", true) { bool in
                print(bool)
            }
          
            
        }
    }
}
