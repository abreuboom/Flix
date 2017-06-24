//
//  DetailedViewViewController.swift
//  Flix
//
//  Created by John Abreu on 6/21/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import PKHUD

enum MovieKeys {
    static let title = "title"
    static let release = "release_date"
    static let rating = "vote_average"
    static let description = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailedViewController: UIViewController {
    
    var movie: [String: Any]?
    
    var movieID: Int = 0
    
    var trailerData: [[String: Any]]!
    var trailerURL: String = ""
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            let backdropPath = movie[MovieKeys.backdropPath] as! String
            let posterPath = movie[MovieKeys.posterPath] as! String
            let baseURL = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURL + backdropPath)!
            let posterURL = URL(string: baseURL + posterPath)!
            
            backdropView.af_setImage(withURL: backdropURL)
            posterView.af_setImage(withURL: posterURL)
            
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie[MovieKeys.release] as? String
            ratingLabel.text = movie[MovieKeys.rating] as? String
            descriptionLabel.text = movie[MovieKeys.description] as? String
            
            
            posterView.layer.shadowColor = UIColor.black.cgColor
            posterView.layer.shadowOffset = CGSize(width: 0, height: 1)
            posterView.layer.shadowOpacity = 1
            posterView.layer.shadowRadius = 5.0
            
            movieID = movie["id"] as! Int
            print(movieID)
        }
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=ab3e3d7326688ce73dd90f58d40024a9&language=en-US")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.alert()
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // TODO: Get the posts and store in posts property
                self.trailerData = dataDictionary["results"] as! [[String : Any]]
            }
        }
        
        task.resume()
        // Do any additional setup after loading the view.
    }

    func alert() {
        let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func trailerToggle(_ sender: UIButton) {
        if trailerData != nil {
        if let key = trailerData[0]["key"] as? String {
            trailerURL = "https://www.youtube.com/watch?v=\(key)"
            print(trailerURL)
            performSegue(withIdentifier: "videoSegue", sender: sender)
        }
      }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let videoViewController = segue.destination as! VideoViewController
        videoViewController.videoURL = trailerURL
    }
}
