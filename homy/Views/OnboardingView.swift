import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingCompleted: Bool
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            TabView(selection: $viewModel.currentPage) {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    OnboardingPageView(item: viewModel.items[index])
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                // Page Control dots
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == viewModel.currentPage ? 1.2 : 1.0)
                            .animation(.spring(), value: viewModel.currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Continue or Get Started button
                Button(action: {
                    withAnimation {
                        if viewModel.isLastPage {
                            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
                            isOnboardingCompleted = true
                        } else {
                            viewModel.currentPage += 1
                        }
                    }
                }) {
                    Text(viewModel.isLastPage ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .foregroundColor(.blue)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: 16) {
                Text(item.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(item.subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}
