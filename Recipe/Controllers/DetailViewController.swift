//
//  DetailViewController.swift
//  Recipe
//
//  Created by Tinh Vu on 2/21/20.
//  Copyright © 2020 alatin std. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var pickerView: PickerView!

    private var selectedType: RecipeType?
    private var imageName: String?
    var recipeTypes: [RecipeType] = []

    var recipe: Recipe?

    private var isNew: Bool {
        return recipe == nil
    }

    var doneHandler: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupPickerView()
    }

    private func initData() {
        if let _recipe = recipe {
            selectedType = recipeTypes.first(where: {$0.id == _recipe.typeId})
            imageName = _recipe.imageName
            ingredientsTextField.text = _recipe.ingredients
            stepsTextField.text = _recipe.steps
            imageView.image = DataManager.shared.loadImage(_recipe.imageName)
        }
    }

    private func setupPickerView() {
        pickerView.reloadData(recipeTypes, selectedType: selectedType)
        pickerView.selectTypeHandler = { [weak self] recipeType in
            self?.selectedType = recipeType
        }
    }

    private func isReadyToDone() -> Bool {
        if selectedType == nil {
            self.showMessage("Please choose a recipe type")
            return false
        } else if (ingredientsTextField.text?.isEmpty == true) {
            self.showMessage("Please enter ingredients")
            return false
        } else if (stepsTextField.text?.isEmpty == true) {
            self.showMessage("Please enter steps")
            return false
        } else if (imageView.image == nil) {
            self.showMessage("Please choose image")
            return false
        }

        return true
    }

    @IBAction func doneTapped(_ sender: Any) {

        guard isReadyToDone() else {
            return
        }

        var _recipe = recipe
        if _recipe == nil {
            _recipe = Recipe(id: UUID().uuidString, ingredients: ingredientsTextField.text ?? "", steps: stepsTextField.text ?? "", typeId: selectedType?.id ?? "", imageName: imageName ?? "")
        } else {
            _recipe?.ingredients = ingredientsTextField.text ?? ""
            _recipe?.steps = stepsTextField.text ?? ""
            _recipe?.typeId = selectedType?.id ?? ""
            _recipe?.imageName = imageName ?? ""
        }

        DataManager.shared.saveRecipe(_recipe!)
        DataManager.shared.saveImage(imageView.image!, name: _recipe!.imageName)

        if isNew {
            doneHandler()
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func addImageTapped(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary

        self.present(myPickerController, animated: true, completion: nil)
    }

}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let imgUrl = info[.imageURL] as? URL, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageName = imgUrl.lastPathComponent
            imageView.image = image
            imageView.backgroundColor = UIColor.clear
        }

        dismiss(animated: true, completion: nil)
    }
}
