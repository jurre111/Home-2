import SwiftUI

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    let items = [
        OnboardingItem(
            title: "Welcome to Homy",
            subtitle: "Monitor your home sensors with ease and stay connected to your environment.",
            imageName: "house.fill"
        ),
        OnboardingItem(
            title: "Add Your Sensors",
            subtitle: "Add your sensor endpoints and watch real-time temperature and humidity data.",
            imageName: "thermometer.sun.fill"
        ),
        OnboardingItem(
            title: "Customizable Dashboard",
            subtitle: "Create your perfect overview with customizable tiles and instant updates.",
            imageName: "rectangle.grid.2x2.fill"
        )
    ]
    
    var isLastPage: Bool {
        currentPage == items.count - 1
    }
}
