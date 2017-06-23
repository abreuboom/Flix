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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/recommendations?api_key=ab3e3d7326688ce73dd90f58d40024a9&language=en-US&page=1")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.abreuboom.PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let poster = movie["poster_path"] as? String {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + String(poster))
            cell.posterView.af_setImage(withURL: url!)
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
