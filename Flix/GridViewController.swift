//
//  GridViewController.swift
//  Flix
//
//  Created by John Abreu on 6/22/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import PKHUD

class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var movies: [[String: Any]] = []
    
    let apiRequestURL = "https://api.themoviedb.org/3/movie/popular?api_key=ab3e3d7326688ce73dd90f58d40024a9&language=en-US&page=1"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        collectionView.insertSubview(refreshControl, at: 0)
        
        loadMovieData()
    }
    
    func loadMovieData() {
        let url = URL(string: apiRequestURL)!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.alert()
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                // TODO: Get the posts and store in posts property
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.collectionView.reloadData()
            }
        }
        task.resume()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let url = URL(string: apiRequestURL)!
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
                self.collectionView.reloadData()
                refreshControl.endRefreshing()
            }
        }
        
        // Tell the refreshControl to stop spinning
        
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.abreuboom.PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let poster = movie["poster_path"] as? String {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + String(poster))
            cell.posterView.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "Rectangle"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (response) in})
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath =  collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.item]
            let detailViewController = segue.destination as! DetailedViewController
            detailViewController.movie = movie
        }
    }
}
