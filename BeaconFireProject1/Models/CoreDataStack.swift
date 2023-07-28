//
//  CoreDataStack.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BeaconFireProject1-1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? {
        let context = persistentContainer.viewContext
        return try? context.fetch(request)
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initCoreData() {
        deleteData()
        print("initializing")
        let context = persistentContainer.viewContext
        
        let category1 = Categories(context: context)
        category1.name = "vegetarian"
        
        let category2 = Categories(context: context)
        category2.name = "non-vegetarian"
        
        let category3 = Categories(context: context)
        category3.name = "seafood"
        
        let category4 = Categories(context: context)
        category4.name = "breakfast"
        
        let category5 = Categories(context: context)
        category5.name = "staple food"
        
        let category6 = Categories(context: context)
        category6.name = "soup/porridge"
        
        let category7 = Categories(context: context)
        category7.name = "drink"
        
        let category8 = Categories(context: context)
        category8.name = "dessert"
        
        let recipe1 = Recipes(context: context)
        recipe1.name = "Garlic Shrimp"
        recipe1.descriptions = "Garlic Shrimp is a famous traditional dish in Guangdong Province, which is delicious in color, fragrance and taste."
        recipe1.instructions = """
        1. Use a knife to cut from the middle of the shrimp head to 1 cm from the tail
        2. Spread the garlic sauce in the middle of the shrimp and place on a plate
        3. Pour hot water into the pot, put the plate in the pot, and steam for 3 minutes on high heat
        4. Heat the oil, pour it into the shrimp plate, and pour in the light soy sauce
        """
        recipe1.image = "GarlicShrimp"
        recipe1.isFavorite = false
        
        recipe1.addToIsA(category2)
        category2.addToHasRecipes(recipe1)

        recipe1.addToIsA(category3)
        category3.addToHasRecipes(recipe1)
        
        let recipe2 = Recipes(context: context)
        recipe2.name = "Scotch Eggs"
        recipe2.descriptions = """
        Scotch eggs are made by wrapping eggs with fresh minced meat and frying them in oil until they are golden.
        
        Easy Scotch Eggs are made with a cheese bacon custard egg wrapped in a finger pie crust and fried in oil until golden brown, about 20-30 minutes.
        """
        recipe2.instructions = """
        1. Boil for 3 minutes under cold water and remove
        2. Take the eggs out and put them in ice water to peel the shells more quickly and completely
        3. Eggs wrapped in cheese slices
        4. Bacon Wrapped Eggs
        5. The two ends of the finger cake are cut off and the egg is wrapped in a rectangle
        6. Put the oil in the pot at 60% temperature (the oil surface fluctuates, there is green smoke, and the chopsticks are inserted into the oil and bubbles appear around the 60% temperature) Fry until golden
        7. Air fryer 160 degrees for 15 minutes
        8. cut and eat
        """
        recipe2.image = "ScotchEggs"
        recipe2.isFavorite = false
        
        recipe2.addToIsA(category2)
        category2.addToHasRecipes(recipe2)

        recipe2.addToIsA(category4)
        category4.addToHasRecipes(recipe2)
        
        let recipe3 = Recipes(context: context)
        recipe3.name = "Miso Soba Noodles"
        recipe3.descriptions = "Soba noodles with sauce are nutritious, sweet and sour"
        recipe3.instructions = """
        1. Cook the buckwheat noodles in cold water for 8-10 minutes, remove and drain for later use
        2. cucumber, radish cut into small strips
        3. Put the buckwheat noodles, cucumber, and radish on the plate, put Laoganma on it, and stir
        """
        recipe3.image = "MisoSobaNoodles"
        recipe3.isFavorite = false
        
        recipe3.addToIsA(category1)
        category1.addToHasRecipes(recipe3)

        recipe3.addToIsA(category5)
        category5.addToHasRecipes(recipe3)
        
        let recipe4 = Recipes(context: context)
        recipe4.name = "Millet Porridge"
        recipe4.descriptions = "Millet contains a variety of vitamins, amino acids, fats and carbohydrates, and has high nutritional value. Every 100 grams of millet contains 9.7 grams of protein and 3.5 grams of fat, no less than rice and wheat."
        recipe4.instructions = """
        1. 100 grams of millet, put it in a bowl, wash it with water (stir it with your hands, pour off the water, just remove the floating ash on the outside, do not scrub!!!)
        2. Boil the water, make sure it boils! ! !
        3. When the water boils, pour the millet into the pot. (A very important link that is easily overlooked)
        4. Stir so that the millet will not stick to the bottom of the pot, and continue to boil for 6-10 minutes on high heat, paying attention to stirring several times in the middle.
        5. Change to medium heat and simmer for 15-20 minutes. The lid of the pot should be staggered by a seam. Don’t let the millet oil slip away. Continue to stir a few times in the middle to avoid sticking to the bottom of the pot
        """
        recipe4.image = "MilletPorridge"
        recipe4.isFavorite = false
        
        recipe4.addToIsA(category1)
        category1.addToHasRecipes(recipe4)

        recipe4.addToIsA(category6)
        category6.addToHasRecipes(recipe4)
        
        let recipe5 = Recipes(context: context)
        recipe5.name = "Gin Fizz"
        recipe5.descriptions = "A \"fizz\" is a mixed drink variation on the older sours family of cocktail."
        recipe5.instructions = """
        1. Choose a glass, it is recommended to use a transparent glass with a capacity of 350~400ml
        2. Pour ice cubes, gin, lemon juice, and sucrose syrup into a shaker, and shake evenly
        3. Pour a full shake of the product into a glass (if the ice inside is too broken, you can choose to filter the ice and add ice cubes to the glass again)
        4. Place a slice of lemon prepared earlier
        5. Slowly pour soda sparkling water along the wall of the glass until the glass is full (do not pour it on the ice to avoid loss of foam)
        6. Use a spoon to gently pull up and down to stir the liquid evenly (do not rotate and stir to avoid foaming and loss)
        7. Top the liquid with green leaves for garnish (optional)
        """
        recipe5.image = "GinFizz"
        recipe5.isFavorite = false
        
        recipe5.addToIsA(category7)
        category7.addToHasRecipes(recipe5)
        
        let recipe6 = Recipes(context: context)
        recipe6.name = "Sweet Fried Taro Chips"
        recipe6.descriptions = "Sweet Fried Taro Chips is a famous Chaoshan snack, afternoon tea, it is very convenient to make, ~ estimated time to make is 20 minutes"
        recipe6.instructions = """
        1. Cut the taro into long strips (slightly larger, so that it is not easy to rot during the stir-fry process)
        2. Add the oil that can cover the taro, and wait for the oil to warm up (insert chopsticks to make small bubbles)
        3. Put the taro into the oil, and fry until the taro floats, usually slightly yellowed and can be easily poked with chopsticks
        4. Don't waste the oil for frying taro, it can be used for cooking later
        5. The next key step is to heat sugar (30g) and water (15g) in a ratio of 2:1 until it does not change color and bubbles
        6. Pour in chopped green onion and taro, turn off the heat and stir fry. At this time, when the temperature comes down, the sugar will have the effect of anti-sand
        7. Plate and serve!
        """
        recipe6.image = "SweetFriedTaroChips"
        recipe6.isFavorite = false
        
        recipe6.addToIsA(category8)
        category8.addToHasRecipes(recipe6)
        
        let ingredient1 = Ingredients(context: context)
        ingredient1.name = "shrimp"
        ingredient1.image = "Shrimp"
        ingredient1.unit = ""
        
        let ingredient2 = Ingredients(context: context)
        ingredient2.name = "garlic sauce"
        ingredient2.image = "GarlicSauce"
        ingredient2.unit = "g"
        
        let ingredient3 = Ingredients(context: context)
        ingredient3.name = "cooking oil"
        ingredient3.image = "CookingOil"
        ingredient3.unit = "mL"
        
        let ingredient4 = Ingredients(context: context)
        ingredient4.name = "soy sauce"
        ingredient4.image = "SoySauce"
        ingredient4.unit = "mL"
        
        let recipeIng1 = RecipeIngredients(context: context)
        recipeIng1.recipe = recipe1
        recipeIng1.ingredient = ingredient1
        recipeIng1.quantity = 8
        recipe1.addToUses(recipeIng1)
        ingredient1.addToUsedBy(recipeIng1)
        
        let recipeIng2 = RecipeIngredients(context: context)
        recipeIng2.recipe = recipe1
        recipeIng2.ingredient = ingredient2
        recipeIng2.quantity = 50
        recipe1.addToUses(recipeIng2)
        ingredient2.addToUsedBy(recipeIng2)
        
        let recipeIng3 = RecipeIngredients(context: context)
        recipeIng3.recipe = recipe1
        recipeIng3.ingredient = ingredient3
        recipeIng3.quantity = 20
        recipe1.addToUses(recipeIng3)
        ingredient3.addToUsedBy(recipeIng3)
        
        let recipeIng4 = RecipeIngredients(context: context)
        recipeIng4.recipe = recipe1
        recipeIng4.ingredient = ingredient4
        recipeIng4.quantity = 5
        recipe1.addToUses(recipeIng4)
        ingredient4.addToUsedBy(recipeIng4)
        
        let ingredient5 = Ingredients(context: context)
        ingredient5.name = "egg"
        ingredient5.image = "Egg"
        ingredient5.unit = ""
        
        let ingredient6 = Ingredients(context: context)
        ingredient6.name = "shredded pancake"
        ingredient6.image = "ShreddedPancake"
        ingredient6.unit = ""
        
        let ingredient7 = Ingredients(context: context)
        ingredient7.name = "cheese slices"
        ingredient7.image = "CheeseSlices"
        ingredient7.unit = ""
        
        let ingredient8 = Ingredients(context: context)
        ingredient8.name = "bacon slices"
        ingredient8.image = "BaconSlices"
        ingredient8.unit = ""
        
        let recipeIng5 = RecipeIngredients(context: context)
        recipeIng5.recipe = recipe2
        recipeIng5.ingredient = ingredient5
        recipeIng5.quantity = 1
        recipe2.addToUses(recipeIng5)
        ingredient5.addToUsedBy(recipeIng5)
        
        let recipeIng6 = RecipeIngredients(context: context)
        recipeIng6.recipe = recipe2
        recipeIng6.ingredient = ingredient6
        recipeIng6.quantity = 2
        recipe2.addToUses(recipeIng6)
        ingredient6.addToUsedBy(recipeIng6)
        
        let recipeIng7 = RecipeIngredients(context: context)
        recipeIng7.recipe = recipe2
        recipeIng7.ingredient = ingredient7
        recipeIng7.quantity = 2
        recipe2.addToUses(recipeIng7)
        ingredient7.addToUsedBy(recipeIng7)
        
        let recipeIng8 = RecipeIngredients(context: context)
        recipeIng8.recipe = recipe2
        recipeIng8.ingredient = ingredient8
        recipeIng8.quantity = 2
        recipe2.addToUses(recipeIng8)
        ingredient8.addToUsedBy(recipeIng8)
        
        let ingredient9 = Ingredients(context: context)
        ingredient9.name = "soba noodles"
        ingredient9.image = "SobaNoodles"
        ingredient9.unit = "g"
        
        let ingredient10 = Ingredients(context: context)
        ingredient10.name = "cucumber"
        ingredient10.image = "Cucumber"
        ingredient10.unit = ""
        
        let ingredient11 = Ingredients(context: context)
        ingredient11.name = "chili sauces"
        ingredient11.image = "ChiliSauces"
        ingredient11.unit = "mL"
        
        let ingredient12 = Ingredients(context: context)
        ingredient12.name = "carrot"
        ingredient12.image = "Carrot"
        ingredient12.unit = ""
        
        let recipeIng9 = RecipeIngredients(context: context)
        recipeIng9.recipe = recipe3
        recipeIng9.ingredient = ingredient9
        recipeIng9.quantity = 100
        recipe3.addToUses(recipeIng9)
        ingredient9.addToUsedBy(recipeIng9)
        
        let recipeIng10 = RecipeIngredients(context: context)
        recipeIng10.recipe = recipe3
        recipeIng10.ingredient = ingredient10
        recipeIng10.quantity = 0.5
        recipe3.addToUses(recipeIng10)
        ingredient10.addToUsedBy(recipeIng10)
        
        let recipeIng11 = RecipeIngredients(context: context)
        recipeIng11.recipe = recipe3
        recipeIng11.ingredient = ingredient11
        recipeIng11.quantity = 20
        recipe3.addToUses(recipeIng11)
        ingredient11.addToUsedBy(recipeIng11)
        
        let recipeIng12 = RecipeIngredients(context: context)
        recipeIng12.recipe = recipe3
        recipeIng12.ingredient = ingredient12
        recipeIng12.quantity = 0.5
        recipe3.addToUses(recipeIng12)
        ingredient12.addToUsedBy(recipeIng12)
        
        let ingredient13 = Ingredients(context: context)
        ingredient13.name = "millet"
        ingredient13.image = "Millet"
        ingredient13.unit = "g"
        
        let ingredient14 = Ingredients(context: context)
        ingredient14.name = "water"
        ingredient14.image = "Water"
        ingredient14.unit = "mL"
        
        let recipeIng13 = RecipeIngredients(context: context)
        recipeIng13.recipe = recipe4
        recipeIng13.ingredient = ingredient13
        recipeIng13.quantity = 100
        recipe4.addToUses(recipeIng13)
        ingredient13.addToUsedBy(recipeIng13)
        
        let recipeIng14 = RecipeIngredients(context: context)
        recipeIng14.recipe = recipe4
        recipeIng14.ingredient = ingredient14
        recipeIng14.quantity = 2000
        recipe4.addToUses(recipeIng14)
        ingredient14.addToUsedBy(recipeIng14)
        
        let ingredient15 = Ingredients(context: context)
        ingredient15.name = "gin"
        ingredient15.image = "Gin"
        ingredient15.unit = "mL"
        
        let ingredient16 = Ingredients(context: context)
        ingredient16.name = "sparkling water"
        ingredient16.image = "SparklingWater"
        ingredient16.unit = "mL"
        
        let ingredient17 = Ingredients(context: context)
        ingredient17.name = "lemon"
        ingredient17.image = "Lemon"
        ingredient17.unit = ""
        
        let ingredient18 = Ingredients(context: context)
        ingredient18.name = "sucrose syrup"
        ingredient18.image = "SucroseSyrup"
        ingredient18.unit = "g"

        let ingredient19 = Ingredients(context: context)
        ingredient19.name = "ice"
        ingredient19.image = "Ice"
        ingredient19.unit = "g"
        
        let recipeIng15 = RecipeIngredients(context: context)
        recipeIng15.recipe = recipe5
        recipeIng15.ingredient = ingredient15
        recipeIng15.quantity = 30
        recipe5.addToUses(recipeIng15)
        ingredient15.addToUsedBy(recipeIng15)
        
        let recipeIng16 = RecipeIngredients(context: context)
        recipeIng16.recipe = recipe5
        recipeIng16.ingredient = ingredient16
        recipeIng16.quantity = 300
        recipe5.addToUses(recipeIng16)
        ingredient16.addToUsedBy(recipeIng16)
        
        let recipeIng17 = RecipeIngredients(context: context)
        recipeIng17.recipe = recipe5
        recipeIng17.ingredient = ingredient17
        recipeIng17.quantity = 1
        recipe5.addToUses(recipeIng17)
        ingredient17.addToUsedBy(recipeIng17)
        
        let recipeIng18 = RecipeIngredients(context: context)
        recipeIng18.recipe = recipe5
        recipeIng18.ingredient = ingredient18
        recipeIng18.quantity = 30
        recipe5.addToUses(recipeIng18)
        ingredient18.addToUsedBy(recipeIng18)
        
        let recipeIng19 = RecipeIngredients(context: context)
        recipeIng19.recipe = recipe5
        recipeIng19.ingredient = ingredient19
        recipeIng19.quantity = 100
        recipe5.addToUses(recipeIng19)
        ingredient19.addToUsedBy(recipeIng19)
        
        let ingredient20 = Ingredients(context: context)
        ingredient20.name = "taro"
        ingredient20.image = "Taro"
        ingredient20.unit = "g"
        
        let ingredient21 = Ingredients(context: context)
        ingredient21.name = "white sugar"
        ingredient21.image = "WhiteSugar"
        ingredient21.unit = "g"
        
        let recipeIng20 = RecipeIngredients(context: context)
        recipeIng20.recipe = recipe6
        recipeIng20.ingredient = ingredient20
        recipeIng20.quantity = 200
        recipe6.addToUses(recipeIng20)
        ingredient20.addToUsedBy(recipeIng20)
        
        let recipeIng21 = RecipeIngredients(context: context)
        recipeIng21.recipe = recipe6
        recipeIng21.ingredient = ingredient21
        recipeIng21.quantity = 30
        recipe6.addToUses(recipeIng21)
        ingredient21.addToUsedBy(recipeIng21)
        
        let recipeIng22 = RecipeIngredients(context: context)
        recipeIng22.recipe = recipe6
        recipeIng22.ingredient = ingredient14
        recipeIng22.quantity = 15
        recipe6.addToUses(recipeIng22)
        ingredient14.addToUsedBy(recipeIng22)
        
        saveContext()
    }
    
    func deleteData() {
        let entities = ["Recipes", "Categories", "Ingredients", "RecipeIngredients"]
        
        for entity in entities {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            
            do {
                let fetchedObjects = try persistentContainer.viewContext.fetch(fetchRequest)
                
                for object in fetchedObjects {
                    if let managedObject = object as? NSManagedObject {
                        persistentContainer.viewContext.delete(managedObject)
                    }
                }
                try persistentContainer.viewContext.save()
            } catch {
                print(error)
            }
        }

    }
}
