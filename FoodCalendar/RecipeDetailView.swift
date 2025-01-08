import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    var isDarkMode: Bool
    let foodItems: [FoodItem]
    @Environment(\.presentationMode) var presentationMode

    var matchingFoodItems: [FoodItem] {
        foodItems.filter { item in
            recipe.ingredients.contains { $0.lowercased() == item.name.lowercased() }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ZStack(alignment: .bottomLeading) {
                        if let uiImage = UIImage(named: recipe.imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .foregroundColor(.gray)
                                .cornerRadius(15)
                        }
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)]),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .cornerRadius(15)
                        
                        Text(recipe.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.purple)
                                Text(ingredient)
                                    .foregroundColor(isDarkMode ? .white.opacity(0.8) : .black.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if !matchingFoodItems.isEmpty {
                        Text("Available Ingredients:")
                            .font(.headline)
                            .padding(.horizontal)
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(matchingFoodItems) { item in
                                    VStack {
                                        if let uiImage = UIImage(named: item.imageName) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                                .shadow(radius: 2)
                                        } else {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                                .foregroundColor(.gray)
                                                .shadow(radius: 2)
                                        }
                                        Text(item.name)
                                            .font(.caption)
                                            .foregroundColor(isDarkMode ? .white : .black)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode
                                       ? [Color.black, Color.gray]
                                       : [Color.white, Color(UIColor.systemGray6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
