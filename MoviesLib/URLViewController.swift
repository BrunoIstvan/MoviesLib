//
//  URLViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 28/06/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit

class URLViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let webpageURL = URL(string: url) else {return}
        let request = URLRequest(url: webpageURL)
        webView.loadRequest(request)
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func runJS(_ sender: UIBarButtonItem) {
        let jsCode = "alert('Nunca use isso!!')"
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

extension URLViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Começando a carregar a página")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Terminei de carregar a página")
        loading.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url!.absoluteString.range(of: "facebook.com") != nil {
            return false
        }
        print(">>>>>>> \(request.url!.absoluteString)")
        return true
    }
}






