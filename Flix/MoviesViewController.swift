//
//  ViewController.swift
//  Flix
//
//  Created by John Abreu on 6/21/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [[String: Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        //Network request snippet
        loadMovieData()
        
        // Do any additional setup after loading the view.
        
    }
    
    func loadMovieData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=ab3e3d7326688ce73dd90f58d40024a9&language=en-US&page=1")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.alert()
                    print(error.localizedDescription)
                } else if let data = data,
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(dataDictionary)
                    
                    HUD.flash(.success, delay: 1.0) { finished in
                        // Completion Handler
                    // TODO: Get the posts and store in posts property
                    self.movies = dataDictionary["results"] as! [[String: Any]]
                    // TODO: Reload the table view
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=ab3e3d7326688ce73dd90f58d40024a9&language=en-US&page=1")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                self.alert()
                print(error.localizedDescription)
            }
            else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                self.movies = dataDictionary["results"] as! [[String: Any]]
                // TODO: Reload the table view
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
        
        // Tell the refreshControl to stop spinning
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        if let poster = movie["poster_path"] as? String {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + String(poster))
            cell.posterView.af_setImage(withURL: url!)
        }
        if let title = movie["title"] as? String {
            cell.movieTitle.text = title
        }
        if let overview = movie["overview"] as? String {
            cell.movieOverview.text = overview
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailedViewController
            detailViewController.movie = movie
        }
    }
    
}
