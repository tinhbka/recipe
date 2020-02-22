//
//  Recipe.swift
//  Recipe
//
//  Created by Tinh Vu on 2/21/20.
//  Copyright © 2020 alatin std. All rights reserved.
//

import Foundation

class Recipe: NSObject, NSCoding {

    var id: String
    var ingredients: String
    var steps: String
    var typeId: String
    var imageName: String

    init(id: String, ingredients: String, steps: String, typeId: String, imageName: String) {
        self.id = id
        self.ingredients = ingredients
        self.steps = steps
        self.typeId = typeId
        self.imageName = imageName
    }

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(ingredients, forKey: "ingredients")
        coder.encode(steps, forKey: "steps")
        coder.encode(typeId, forKey: "typeId")
        coder.encode(imageName, forKey: "imageName")
    }

    required init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: "id") as? String ?? ""
        self.ingredients = coder.decodeObject(forKey: "ingredients") as? String ?? ""
        self.steps = coder.decodeObject(forKey: "steps") as? String ?? ""
        self.imageName = coder.decodeObject(forKey: "imageName") as? String ?? ""
        self.typeId = coder.decodeObject(forKey: "typeId") as? String ?? ""
    }
}
