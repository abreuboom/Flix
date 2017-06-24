//
//  VideoViewController.swift
//  Flix
//
//  Created by John Abreu on 6/23/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var videoURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoURL = videoURL {
            print(videoURL)
            // Convert the url String to a NSURL object.
            let requestURL = URL(string: videoURL)!
            // Place the URL in a URL Request.
            let request = URLRequest(url: requestURL)
            // Load Request into WebView.
            webView.loadRequest(request)
        }
    }
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
