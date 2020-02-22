//
//  MasterViewController.swift
//  Recipe
//
//  Created by Tinh Vu on 2/21/20.
//  Copyright © 2020 alatin std. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!

    var recipe: Recipe? {
        didSet {
            imgView.image = DataManager.shared.loadImage(recipe?.imageName ?? "")
            ingredientsLabel.text = recipe?.ingredients
            stepsLabel.text = recipe?.steps
        }
    }
}

class MasterViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: PickerView!

    private var recipes: [Recipe] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var recipeTypes: [RecipeType] = []
    private var selectedType: RecipeType? {
        didSet {
            reloadData()
        }
    }

    // XML parse elements
    private var elementName: String = String()
    private var recipeTitle = String()
    private var recipeId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        parseXML()
        setupPickerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    private func initViews() {
        self.title = "Recipe by Type"

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
        navigationItem.rightBarButtonItem = addItem
    }

    private func reloadData() {

        guard let type = selectedType else {
            return
        }
        let listRecipe = DataManager.shared.loadRecipes()

        recipes = listRecipe.filter({$0.typeId == type.id})
    }

    private func parseXML() {
        if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }

    private func setupPickerView() {
        pickerView.reloadData(recipeTypes)
        pickerView.selectTypeHandler = { [weak self] recipeType in
            self?.selectedType = recipeType
        }
    }

    private func gotoRecipeDetail(_ recipe: Recipe? = nil) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.recipe = recipe
        detailVC.recipeTypes = recipeTypes

        if recipe == nil {
            detailVC.doneHandler = { [weak self] in
                self?.reloadData()
            }
            let nav = UINavigationController(rootViewController: detailVC)
            present(nav, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @objc private func addRecipe() {
        gotoRecipeDetail()
    }

}

extension MasterViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == Key.recipe {
            recipeTitle = String()
            recipeId = String()
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == Key.recipe {
            let recipe = RecipeType(title: recipeTitle, id: recipeId)
            recipeTypes.append(recipe)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == Key.title {
                recipeTitle += data
            } else if self.elementName == Key.id {
                recipeId += data
            }
        }
    }
}

extension MasterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as? RecipeTableViewCell else {
            return RecipeTableViewCell()
        }

        cell.recipe = recipes[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        gotoRecipeDetail(recipes[indexPath.row])
    }
}
