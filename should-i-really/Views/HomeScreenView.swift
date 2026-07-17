//
//  HomeScreenView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct HomeScreenView: View {
    // Call viewModel to manage routes
    //        @Bindable var viewModel: GameViewModel
    
    // Local state var
    @Environment(GameViewModel.self) private var viewModel
    
    
    // MARK: - Body
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack(path: $viewModel.navigationPath){
            VStack() {
                Text("Should I")
                    .font(.system(size: 70, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineSpacing(-50)
                    .padding(.top, 250)
                Text("Really?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .offset(x: 52, y: -8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 24)
                LandingMenuView(viewModel: viewModel)
                    .offset(y: -8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - Nav Destination
            .navigationDestination(for: GameViewModel.GameRoute.self) { route in
                switch route {
                case .usernameInput:
                    UsernameInputView()
                case .prologue:
                    PrologView()
                case .archive:
                    ArchiveView()
                case .timeline:
                    ProfilePageView()
                default:
                    EmptyView()
                }
            }
        }
    }
}


#Preview {
    HomeScreenView()
        .environment(GameViewModel())
}
