//
//  DataManager.swift
//  Recipe
//
//  Created by Tinh Vu on 2/21/20.
//  Copyright © 2020 alatin std. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()

    func saveRecipe(_ recipe: Recipe) {
        var recipes = loadRecipes()

        if let index = recipes.firstIndex(where: {$0.id == recipe.id}) {
            recipes.remove(at: index)
        }

        recipes.append(recipe)

        let recipesData = NSKeyedArchiver.archivedData(withRootObject: recipes)
        UserDefaults.standard.set(recipesData, forKey: Key.recipes)
    }

    func loadRecipes() -> [Recipe] {
        guard let recipesData = UserDefaults.standard.object(forKey: Key.recipes) as? NSData else {
            print("'recipes' not found in UserDefaults")
            return []
        }

        guard let recipeArray = NSKeyedUnarchiver.unarchiveObject(with: recipesData as Data) as? [Recipe] else {
            print("Could not unarchive from recipesData")
            return []
        }

        return recipeArray
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func saveImage(_ image: UIImage, name: String) {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: filename.path) {
            return
        }
        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: filename)
        }
    }

    func loadImage(_ name: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
}
