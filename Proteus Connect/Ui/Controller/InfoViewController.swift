// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import UIKit
import WebKit
import BluetoothSDK_iOS

class InfoViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    var url = ""
    var htmlTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalContent()
    }
    
    func loadLocalContent() {
        self.title = htmlTitle
        webView.navigationDelegate = self

        guard let webUrl = Bundle.main.url(forResource: url, withExtension: "html", subdirectory: "") else {
            os_log_ui("InfoViewController.loadLocalContent: invalid or missing html '%s'", type: .error, "\(url).html")
            return
        }

        webView.loadFileURL(webUrl, allowingReadAccessTo: webUrl)
    }
}

// MARK: WKNavigationDelegate

extension InfoViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // TODO: Display Button to refresh and display message
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadCss()
    }

    /// Loads the style css to the html. Usefull when displaying app in darkmode.
    private func loadCss() {
        guard let path = Bundle.main.path(forResource: "WebStyle", ofType: "css") else {
            return
        }

        let js = "var link = document.createElement('link'); link.href = '\(path)'; link.rel = 'stylesheet'; document.head.appendChild(link)"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

}

// MARK: UIPopoverPresentationControllerDelegate

extension InfoViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
