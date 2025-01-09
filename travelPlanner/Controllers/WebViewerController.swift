//
//  WebViewerController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 2/1/25.
//

import UIKit
import WebKit
import SnapKit

class WebViewerController: UIViewController {

    private let webView = WKWebView()
    private let urlString: String
    
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: self.urlString) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.webView.load(URLRequest(url: url))
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
}
