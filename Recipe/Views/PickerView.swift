//
//  PickerView.swift
//  Recipe
//
//  Created by Tinh Vu on 2/21/20.
//  Copyright © 2020 alatin std. All rights reserved.
//

import UIKit

class PickerView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var textField: UITextField!

    private var recipeTypes: [RecipeType] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    private var selectedType: RecipeType? {
        didSet {
            textField.text = selectedType?.title
        }
    }

    var selectTypeHandler: (RecipeType?) -> Void = {_ in}

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .clear

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)

        addToolBar(textField: textField)
        textField.inputView = pickerView
    }

    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }

    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.inputAccessoryView = toolBar
    }

    @objc func donePressed(){
        view.endEditing(true)
        selectTypeHandler(selectedType)
    }
    @objc func cancelPressed(){
        view.endEditing(true)
    }

    func reloadData(_ types: [RecipeType], selectedType: RecipeType? = nil) {
        recipeTypes = types
        self.selectedType = selectedType
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = recipeTypes[row]
        if type.id == selectedType?.id {
            return
        }
        selectedType = type
    }
}
