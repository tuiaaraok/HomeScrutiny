import SwiftUI

@available(iOS 16.0, *)
struct SettingsScreen: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navPath: [Screens]
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    if !navPath.isEmpty {
                        navPath.removeLast()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 22, height: 20)
                        .foregroundStyle(Color.itemsBackground)
                }
                .padding(EdgeInsets(top: 17, leading: 17, bottom: 0, trailing: 0))
                Spacer()
            }
                        
            AppThemeToggle(lightStringResource: "themeLight", darkStringResource: "themeDark")
                .padding(EdgeInsets(top: 165, leading: 17, bottom: 0, trailing: 17))
            
            VStack(spacing: 27) {
                SettingsButton(text: "Contact us", action: { email("mustafasengun2@icloud.com") }, lightStringResource: "contactLight", darkStringResource: "contactDark", backgroundColor: Color.contactBackground)
                SettingsButton(text: "Privacy Policy", action: { privacy("https://docs.google.com/document/d/1Y8z7j4brLSNFBjDTRmJlh0Xoz0XmjQ7YBDpqCCJbgwQ/mobilebasic") }, lightStringResource: "privacyLight", darkStringResource: "privacyDark", backgroundColor: Color.privacyBackground)
                SettingsButton(text: "Rate us", action: { rate("6739555510") }, lightStringResource: "rateLight", darkStringResource: "rateDark", backgroundColor: Color.rateBackground)
            }.padding(EdgeInsets(top: 83, leading: 17, bottom: 0, trailing: 17))
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
    func rate(_ appId: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func privacy(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func email(_ email: String) {
        if let url = URL(string: "mailto:\(email)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}


@available(iOS 16.0, *)
private struct SettingsButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    let action: () -> Void
    let lightStringResource: String
    let darkStringResource: String
    let backgroundColor: Color
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0) {
                
                ZStack {
                    Ellipse()
                        .fill(backgroundColor)
                        .frame(width: 43, height: 33)
                        .rotationEffect(.degrees(-20))
                    
                    Image(themeManager.isLT ? lightStringResource : darkStringResource)
                        .frame(width: 43, height: 43)
                        .padding(EdgeInsets(top: 3, leading: 13, bottom: 4, trailing: 0))
                }

                Text(text)
                    .customFont(.settingsButtonText)
                    .foregroundStyle(Color.mainText)
                    .padding(.leading, 24)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .foregroundStyle(Color.mainText)
                    .frame(width: 8, height: 18)
                    .padding(.trailing, 22)
            }
            .frame(maxWidth: .infinity, maxHeight: 62)
            .background(Color.itemsBackground)
            .cornerRadius(15)
        }
    }
}

@available(iOS 16.0, *)
private struct AppThemeToggle: View {
    @EnvironmentObject var themeManager: ThemeManager
    let lightStringResource: String
    let darkStringResource: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            ZStack {
                Ellipse()
                    .fill(Color.toggleBackground)
                    .frame(width: 43, height: 33)
                    .rotationEffect(.degrees(-20))
                
                Image(themeManager.isLT ? lightStringResource : darkStringResource)
                    .frame(width: 43, height: 43)
                    .padding(EdgeInsets(top: 3, leading: 13, bottom: 4, trailing: 0))
            }

            Text(themeManager.isLT ? "Dark Mode" : "Light Mode")
                .customFont(.settingsButtonText)
                .foregroundStyle(Color.mainText)
                .padding(.leading, 24)
            Spacer()
            Toggle(isOn: $themeManager.isLT) {}
                .toggleStyle(AppToggleStyle())
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: 62)
        .background(Color.itemsBackground)
        .cornerRadius(15)
    }
}

private struct AppToggleStyle: ToggleStyle {
    @EnvironmentObject var themeManager: ThemeManager
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.toggleBackground)
                .frame(width: 50, height: 25)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(3)
                        .shadow(color: Color.black, radius: 2, x: configuration.isOn ? -1 : 1, y: 1)
                        .offset(x: configuration.isOn ? 12 : -12)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}


