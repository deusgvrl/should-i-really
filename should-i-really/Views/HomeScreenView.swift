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
            switch viewModel.currentRoute {
            case .landing:
                LandingMenuView(viewModel: viewModel)
                    .offset(y: -8)
            case .usernameInput:
//                UsernameInputView(viewModel: viewModel)
                Text("Username Input Screen")
            case .timeline:
                ProfilePageView()
            case .archive:
                Text("Archive screen")
            case .ending:
                Text("Ending Screen")
                //            default:
                //                EmptyView()
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeScreenView()
        .environment(GameViewModel())
}
