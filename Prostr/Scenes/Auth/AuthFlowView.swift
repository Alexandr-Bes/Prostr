//
//  AuthFlowView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthFlowView: View {
    @Environment(AppCore.self) private var appCore

    @State private var signUpViewModel: SignUpViewModel
    @State private var signInViewModel: SignInViewModel

    init(appCore: AppCore) {
        _signUpViewModel = State(
            wrappedValue: SignUpViewModel(authService: appCore.services.authService)
        )

        _signInViewModel = State(
            wrappedValue: SignInViewModel(authService: appCore.services.authService)
        )
    }

    var body: some View {
        Group {
            switch appCore.authDestination {
            case .signUp:
                SignUpScene(
                    viewModel: signUpViewModel,
                    onAuthenticated: appCore.finishAuthentication(with:),
                    onShowSignIn: showSignIn
                )

            case .signIn:
                SignInScene(
                    viewModel: signInViewModel,
                    onAuthenticated: appCore.finishAuthentication(with:),
                    onShowSignUp: showSignUp
                )
            }
        }
        .animation(.easeInOut(duration: 0.2), value: appCore.authDestination)
    }
}

private extension AuthFlowView {
    func showSignIn() {
        appCore.showAuthDestination(.signIn)
    }

    func showSignUp() {
        appCore.showAuthDestination(.signUp)
    }
}

#Preview {
    let appCore = PreviewAppCore.make()
    return AuthFlowView(appCore: appCore)
        .previewAppCore(appCore)
}
