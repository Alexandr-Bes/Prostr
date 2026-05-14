//
//  SignInScene.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Observation
import SwiftUI

struct SignInScene: View {
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var focusedField: String?

    let viewModel: SignInViewModel
    let onAuthenticated: (AuthSession) -> Void
    let onShowSignUp: () -> Void

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        AuthSceneContainer(
            title: "Sign in to your account",
            backAction: onShowSignUp
        ) {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    AuthFieldContainer(
                        label: "Email address",
                        fieldState: emailFieldState
                    ) {
                        TextField(
                            "",
                            text: $bindableViewModel.email,
                            prompt: placeholderText("Your email")
                        )
                        .font(.body)
                        .foregroundStyle(palette.primaryText)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: "email")
                        .onSubmit(focusPasswordField)
                    } helperContent: {
                        if let emailErrorMessage = viewModel.emailErrorMessage {
                            AuthHelperTextView(message: emailErrorMessage)
                        }
                    }

                    AuthFieldContainer(
                        label: "Password",
                        fieldState: passwordFieldState
                    ) {
                        passwordInputField(binding: $bindableViewModel.password)
                    } helperContent: {
                        if let passwordErrorMessage = viewModel.passwordErrorMessage {
                            AuthHelperTextView(message: passwordErrorMessage)
                        }
                    }
                }

                VStack(spacing: 16) {
                    AuthPrimaryButton(
                        title: "Sign In",
                        isLoading: viewModel.isSubmitting,
                        action: submitTapped
                    )

                    Button("Forgot Password?") {
                    }
                    .font(.body)
                    .foregroundStyle(palette.accent)

                    if let serviceErrorMessage = viewModel.serviceErrorMessage {
                        AuthHelperTextView(message: serviceErrorMessage)
                    }
                }

                AuthDividerView()

                VStack(spacing: 16) {
                    AuthSocialButton(provider: .google, action: googleTapped)
                    AuthSocialButton(provider: .facebook, action: facebookTapped)
                    AuthSocialButton(provider: .apple, action: appleTapped)
                }
            }
            .onChange(of: viewModel.email) { _, _ in
                viewModel.handleEmailChanged()
            }
            .onChange(of: viewModel.password) { _, _ in
                viewModel.handlePasswordChanged()
            }
        } footer: {
            AuthFooterPromptView(
                message: "Don't have an account?",
                actionTitle: "Sign up",
                action: onShowSignUp
            )
        }
        .tint(palette.accent)
    }
}

private extension SignInScene {
    var palette: AuthPalette {
        AuthPalette(colorScheme: colorScheme)
    }

    var emailFieldState: AuthFieldState {
        if viewModel.emailErrorMessage != nil {
            return .error
        }

        if focusedField == "email" {
            return .focused
        }

        return .idle
    }

    var passwordFieldState: AuthFieldState {
        if viewModel.passwordErrorMessage != nil {
            return .error
        }

        if focusedField == "password" {
            return .focused
        }

        return .idle
    }

    func passwordInputField(binding: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Group {
                if viewModel.isPasswordVisible {
                    TextField(
                        "",
                        text: binding,
                        prompt: placeholderText("Your password")
                    )
                    .textContentType(.password)
                } else {
                    SecureField(
                        "",
                        text: binding,
                        prompt: placeholderText("Your password")
                    )
                    .textContentType(.password)
                }
            }
            .font(.body)
            .foregroundStyle(palette.primaryText)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.done)
            .focused($focusedField, equals: "password")
            .onSubmit(submitTapped)

            Button(
                viewModel.isPasswordVisible ? "Hide password" : "Show password",
                systemImage: viewModel.isPasswordVisible ? "eye.slash" : "eye",
                action: viewModel.togglePasswordVisibility
            )
            .labelStyle(.iconOnly)
            .foregroundStyle(palette.primaryText)
        }
    }

    func placeholderText(_ value: String) -> Text {
        Text(value).foregroundStyle(palette.placeholderText)
    }

    func focusPasswordField() {
        focusedField = "password"
    }

    func submitTapped() {
        Task {
            await submit()
        }
    }

    func googleTapped() {
        Task {
            await authenticate(with: .google)
        }
    }

    func facebookTapped() {
        Task {
            await authenticate(with: .facebook)
        }
    }

    func appleTapped() {
        Task {
            await authenticate(with: .apple)
        }
    }

    @MainActor
    func submit() async {
        guard let session = await viewModel.submit() else {
            return
        }

        onAuthenticated(session)
    }

    @MainActor
    func authenticate(with provider: AuthProvider) async {
        guard let session = await viewModel.authenticate(with: provider) else {
            return
        }

        onAuthenticated(session)
    }
}

#Preview {
    let appCore = PreviewAppCore.make()
    return SignInScene(
        viewModel: SignInViewModel(authService: appCore.services.authService),
        onAuthenticated: { _ in },
        onShowSignUp: {}
    )
    .previewAppCore(appCore)
}
