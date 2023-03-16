//
//  GetWordsView.swift
//  AdminWords.UIKit
//
//  Created by 111 on 05.09.2022.
//

import Foundation
import UIKit


fileprivate enum Handler {
    case Swither(SwitcherHandler)
    case SingleLine(SingleLineHandler)
    case Multiline(MuiltilineHandler)
}

fileprivate class SwitcherHandler {
    let element: UIView
    let handler: (Bool) -> Void
    
    init(element: UIView, handler: @escaping (Bool) -> Void) {
        self.element = element
        self.handler = handler
    }
}

fileprivate class SingleLineHandler {
    let element: UIView
    let handler: (String) -> Void
    
    init(element: UIView, handler: @escaping (String) -> Void) {
        self.element = element
        self.handler = handler
    }
}

fileprivate class MuiltilineHandler {
    let element: UIView
    let handler: (String) -> Void
    
    init(element: UIView, handler: @escaping (String) -> Void) {
        self.element = element
        self.handler = handler
    }
}


enum TextFields {
    case SingleLine(String, String, (String) -> Void)
    case MultiLine(String, String, (String) -> Void)
    case Toggle(String, Bool, (Bool) -> Void)
}

class Editor: UIScrollView {
    
    fileprivate var handlers = [Handler]()
    
    @resultBuilder
    struct RawBuilder {
        static func buildBlock(_ components: TextFields...) -> [TextFields] {
            components
            }
        }
    var container: UIStackView!
    
    init(frame: CGRect, @RawBuilder columns initColumns: (TextFields.Type) -> [TextFields]) {
        super.init(frame: frame)
        initStack()

        let views = initColumns(TextFields.self)
        views.forEach { row in
                          let label = UILabel()
                          label.translatesAutoresizingMaskIntoConstraints = false
                          label.widthAnchor.constraint(equalToConstant: 100).isActive = true
                          var view: UIView!
          
                          if case let .SingleLine(param, valueText, handler) = row {
                              label.text = param
                              view = singleRaw(valueText)
                              
                              handlers.append(.SingleLine(SingleLineHandler(element: view, handler: handler)))
                          } else if case let .MultiLine(param, valueText, handler) = row {
                              label.text = param
                              view = textArea(valueText)
                              
                              handlers.append(.Multiline(MuiltilineHandler(element: view, handler: handler)))
                          } else if case let .Toggle(param, value, handler) = row {
                              label.text = param
                              view = toggler(value)
                              
                              handlers.append(.Swither(SwitcherHandler(element: view, handler: handler)))
                          }
          
                          let raw = field(label, view)
                          container.addArrangedSubview(raw)
        }

        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false

        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func anyToString(_ any: Any?) -> String {
        if let int = any as? Int {
            return String(int)
        } else if let bool = any as? Bool {
            return String(bool)
        } else if let str = any as? String {
            return str
        } else {
            return String(describing: any)
        }
    }
    
    private func initLayout() {
        let constraints = [
            container.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant:  -20),
           
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initStack() {
        container = UIStackView()
        container.spacing = 5
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .leading
        addSubview(container)
    }
    
    private func singleRaw(_ text: String) -> UIView {
        let field = UITextField()
        field.delegate = self
        field.borderStyle = .roundedRect
        field.text = text
        return field
    }
    
    private func textArea(_ text: String) -> UIView {
        let textView = UITextView()
        textView.delegate = self
        textView.textAlignment = NSTextAlignment.justified
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.textContainer.maximumNumberOfLines = 10
        textView.isScrollEnabled = false
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
                textView.layer.borderWidth = 0.5
                textView.layer.borderColor = borderColor.cgColor
                textView.layer.cornerRadius = 5.0
        return textView
    }
    
    private func toggler(_ value: Bool) -> UIView {
        let toggl = UISwitch()
        toggl.isOn = value
        toggl.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        return toggl
    }
    
    
    @objc private func switchStateDidChange(_ sender:UISwitch!) {
            for view in handlers {
                if case .Swither(let handler) = view {
                    guard handler.element == sender else { continue }
                    handler.handler(sender.isOn)
                }
            }
            
        }
    private func field(_ label: UILabel, _ text: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, text])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
       
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: bounds.width)
            
        ])
        return stack
    }
}

extension Editor: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        for view in handlers {
            print(view)
            if case .SingleLine(let handler) = view {
                guard handler.element == textField else { continue }
                handler.handler(textField.text ?? "")
                print(textField.text ?? "empty")

            }
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        for view in handlers {
            if case .Multiline(let handler) = view {
                guard handler.element == textView else { continue }
                handler.handler(textView.text ?? "")
            }
        }
        
        print(textView.text ?? "empty")
    }
}
