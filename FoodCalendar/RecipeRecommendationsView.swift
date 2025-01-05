import SwiftUI

struct RecipeRecommendationsView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    // Sample recipes data
    let recipes = [
        Recipe(title: "Apple Pie", ingredients: ["Apple", "Flour", "Sugar", "Butter"], imageName: "applepie"),
        Recipe(title: "Chicken Salad", ingredients: ["Chicken", "Lettuce", "Tomato"], imageName: "chickensalad"),
        Recipe(title: "Banana Smoothie", ingredients: ["Banana", "Milk", "Honey"], imageName: "bananasmoothie"),
        // Add more recipes as needed
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredRecipes(), id: \.id) { recipe in
                    RecipeRow(recipe: recipe, isDarkMode: isDarkMode)
                }
            }
            .navigationTitle("Recommended Recipes")
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
        }
        .accentColor(.purple)
    }
    
    // Filter recipes based on available ingredients
    func filteredRecipes() -> [Recipe] {
        recipes.filter { recipe in
            recipe.ingredients.allSatisfy { ingredient in
                foodItems.contains { $0.name.lowercased() == ingredient.lowercased() }
            }
        }
    }
}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let ingredients: [String]
    let imageName: String
}

struct RecipeRow: View {
    let recipe: Recipe
    var isDarkMode: Bool
    
    var body: some View {
        HStack {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? .gray : .secondary)
            }
            .padding(.leading, 5)
        }
        .padding(.vertical, 5)
        .background(isDarkMode ? Color(UIColor.systemGray6) : Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}
