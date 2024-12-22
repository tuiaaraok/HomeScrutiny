import Foundation
import WebKit
import SwiftUI
import FirebaseRemoteConfig
import Network

enum NavigationState {
    case homeFlow, serviceScreen
}

struct AddedStorage {
    
    static let sharedInstance = AddedStorage()
    
    private init() { }
    
    @AppStorage("APP_URL") private var URL = ""
    @AppStorage("IS_FIRST_TIME") private var isFRSTLNCH = true
    
    func getURL() -> String {
        URL
    }
    
    func setURL(_ url: String) {
        URL = url
    }
    
    func isFL() -> Bool {
        isFRSTLNCH
    }
    
    func setFL(_ value: Bool) {
        isFRSTLNCH = value
    }
}

class WVM: ObservableObject {
    @Published var nS: NavigationState = .serviceScreen
    @Published var dA: Bool = false
    @Published var lURLA: String?
    @Published var displayAgreeButton = false
    
    func fRC() async -> URL? {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        do {
            let status = try await remoteConfig.fetchAndActivate()
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let urlString = remoteConfig["privacyLink"].stringValue ?? ""
                guard let url = URL(string: urlString) else { return nil }
                return url
            }
        } catch {
            nS = .homeFlow
        }
        return nil
    }
}

@available(iOS 17.0, *)
struct LaunchScreen: View {
    @StateObject var viewModel = WVM()
    @StateObject private var themeManager = ThemeManager.shared
    var body: some View {
        Group {
            switch viewModel.nS {
            case .homeFlow:
                HomeFlow().environmentObject(themeManager)
            case .serviceScreen:
                VStack {
                    if let url = viewModel.lURLA {
                        WebViewWWW(url: url, viewModel: viewModel)
                    }
                    if viewModel.displayAgreeButton {
                        Button(action: {
                            viewModel.nS = .homeFlow
                        }, label: {
                            Text("Agree")
                                .customFont(.actionButtonText)
                                .foregroundStyle(Color.white)
                                .padding(EdgeInsets(top: 7, leading: 42, bottom: 7, trailing: 42))
                                .background(Color.mainAdd)
                                .cornerRadius(20)
                        })
                    }
                }
            }
        }
        .alert("No internet", isPresented: $viewModel.dA, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("Ok")
            })
        })
        .onAppear(perform: configureView)
    }
    
    private func configureView() {
        let storage = AddedStorage.sharedInstance
        if !storage.getURL().isEmpty {
            viewModel.lURLA = storage.getURL()
            viewModel.nS = .serviceScreen
        } else if storage.isFL() {
            Task {
                if let url = await viewModel.fRC() {
                    viewModel.lURLA = url.absoluteString
                    viewModel.nS = .serviceScreen
                }
            }
            storage.setFL(false)
        } else {
            viewModel.nS = .homeFlow
        }
    }
}

struct WebViewWWW: UIViewRepresentable {
    let url: String
    let viewModel: WVM
    private let userAgent = "Mozilla/5.0 (\(UIDevice.current.model); CPU \(UIDevice.current.model) OS \(UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(UIDevice.current.systemVersion) Mobile/15E148 Safari/604.1"
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else { return WKWebView() }
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = userAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWWW
        
        init(_ parent: WebViewWWW) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            if handleCustomSchemes(url: url) {
                decisionHandler(.cancel)
                return
            }
            
            if url.query?.contains("showAgreebutton") == true {
                parent.viewModel.displayAgreeButton = true
            } else {
                let storage = AddedStorage.sharedInstance
                storage.setURL(parent.viewModel.displayAgreeButton ? "" : url.absoluteString)
            }
            
            decisionHandler(.allow)
        }
        
        private func handleCustomSchemes(url: URL) -> Bool {
            let schemes = ["tel", "mailto", "tg", "phonepe", "paytmmp"]
            guard schemes.contains(url.scheme ?? "") else { return false }
            UIApplication.shared.open(url, options: [:])
            return true
        }
    }
}

