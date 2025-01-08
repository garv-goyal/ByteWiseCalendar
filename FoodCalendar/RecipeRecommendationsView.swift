import SwiftUI

struct RecipeRecommendationsView: View {
    @Binding var foodItems: [FoodItem]
    @Binding var isDarkMode: Bool
    
    let recipes = [
        Recipe(title: "Apple Pie", ingredients: ["Apple", "Flour", "Sugar", "Butter"], imageName: "applepie"),
        Recipe(title: "Caeser Salad", ingredients: ["Chicken", "Lettuce", "Tomato"], imageName: "caesarsalad"),
        Recipe(title: "Banana Smoothie", ingredients: ["Banana", "Milk", "Honey"], imageName: "bananasmoothie"),
        Recipe(title: "Carrot Shake", ingredients: ["Carrot", "Milk", "Honey"], imageName: "carrotjuice"),
        Recipe(title: "French Toast", ingredients: ["Eggs", "Milk", "Banana"], imageName: "frenchtoast"),
        Recipe(title: "Mixed Juice", ingredients: ["Banana", "Orange", "Apple"], imageName: "mixedjuice"),
        Recipe(title: "Chocolate Pancakes", ingredients: ["Chocolate", "Flour", "Milk", "Eggs"], imageName: "chocolatepancake"),
        Recipe(title: "GreeknSalad", ingredients: ["Cucumber", "Tomato", "Feta Cheese", "Olives"], imageName: "greensalad"),
        Recipe(title: "Lemon Chicken", ingredients: ["Chicken", "Lemon", "Garlic"], imageName: "lemonchicken"),
        Recipe(title: "Spaghetti Carbonara", ingredients: ["Spaghetti", "Eggs", "Bacon", "Parmesan"], imageName: "spaghetticarbonara"),
        Recipe(title: "Mango Sorbet", ingredients: ["Mango", "Sugar", "Lime", "Orange"], imageName: "mangosorbet"),
        Recipe(title: "Stuffed Bell Peppers", ingredients: ["Bell Peppers", "Rice", "Cheese", "Tomato"], imageName: "stuffedbellpeppers"),
        Recipe(title: "Spinach Smoothie", ingredients: ["Spinach", "Banana", "Almond Milk"], imageName: "spinachsmoothie"),
        Recipe(title: "Pumpkin Soup", ingredients: ["Pumpkin", "Cream", "Cinnamon", "Apple"], imageName: "pumpkinsoup"),
        Recipe(title: "Beef Tacos", ingredients: ["Beef", "Chicken", "Tortilla", "Lettuce", "Cheese"], imageName: "beeftacos"),
        // to add more recipes
    ]
    
    @State private var selectedRecipe: Recipe? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode
                                       ? [Color.purple.opacity(0.5), Color.blue.opacity(0.3)]
                                       : [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 775, height: 200)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
                .padding([.leading, .bottom, .trailing], 16)
                
                
                VStack(spacing: 10) {
                    Image(systemName: "book.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isDarkMode ? Color.purple : Color.purple.opacity(1.5))
                        .shadow(radius: 5)
                    
                    Text("Recommended Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                        .foregroundColor(.white)
                    
                    Text("Discover new dishes based on your ingredients.")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 30)

            }
            .padding(.top, 2)
            .padding(.bottom, -10)
            
            Divider()
                .padding(.bottom, 20)
                .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 18)], spacing: 12) {
                    ForEach(filteredRecipes()) { recipe in
                        RecipeCard(recipe: recipe, isDarkMode: isDarkMode)
                            .onTapGesture {
                                selectedRecipe = recipe
                            }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.trailing, 18)
            }
            .padding(.leading, 20)
            .background(isDarkMode ? Color.black.opacity(0.05) : Color.white)
        }
        .background(
            Group {
                if isDarkMode {
                    Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                } else {
                    LinearGradient(colors: [Color.purple.opacity(0.05), Color.white],
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
        
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipe: recipe, isDarkMode: isDarkMode, foodItems: foodItems)
        }
    }
    
    func filteredRecipes() -> [Recipe] {
        let matched = recipes.filter { recipe in
            recipe.ingredients.contains { ingredient in
                foodItems.contains { $0.name.lowercased() == ingredient.lowercased() }
            }
        }
        return matched.isEmpty ? recipes : matched
    }

}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let ingredients: [String]
    let imageName: String
}
