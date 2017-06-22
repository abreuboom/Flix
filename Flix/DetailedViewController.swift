//
//  DetailedViewViewController.swift
//  Flix
//
//  Created by John Abreu on 6/21/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit

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
        }
        
        
        // Do any additional setup after loading the view.
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
