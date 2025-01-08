import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isDarkMode
                                   ? [Color.purple.opacity(0.7), Color.blue.opacity(0.7)]
                                   : [Color.orange.opacity(0.3), Color.red.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(15)
            .shadow(color: isDarkMode ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 12) {
                if let _ = UIImage(named: recipe.imageName) {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 120)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.6), lineWidth: 2)
                        )
                        .shadow(radius: 4)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 155, height: 120)
                        .clipped()
                        .cornerRadius(10)
                        .foregroundColor(.gray)
                        .shadow(radius: 4)
                }

                Text(recipe.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .shadow(radius: 2)
                
                Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(width: 170, height: 260, alignment: .top)
    }
}

struct RecipeListView: View {
    let recipes: [Recipe]
    var isDarkMode: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCard(recipe: recipe, isDarkMode: isDarkMode)
                }
            }
            .padding()
        }
        .background(isDarkMode ? Color.black : Color.white)
    }
}
