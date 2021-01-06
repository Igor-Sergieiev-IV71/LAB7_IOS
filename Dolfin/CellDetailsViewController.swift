//
//  CellDetailsViewController.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class CellsDetailsViewController: UIViewController {
    @IBOutlet weak var describeImage: UIImageView!
    @IBOutlet weak var describeTitle: UILabel!
    @IBOutlet weak var describeYear: UILabel!
    @IBOutlet weak var describeGenre: UILabel!
    @IBOutlet weak var describeDirector: UILabel!
    @IBOutlet weak var describeActors: UILabel!
    @IBOutlet weak var describeCountry: UILabel!
    @IBOutlet weak var describeLanguage: UILabel!
    @IBOutlet weak var describeProduction: UILabel!
    @IBOutlet weak var describeReleased: UILabel!
    @IBOutlet weak var describeRuntime: UILabel!
    @IBOutlet weak var describeAwards: UILabel!
    @IBOutlet weak var describeRating: UILabel!
    @IBOutlet weak var describePlot: UILabel!
    @IBOutlet weak var awardsText: UILabel!
    
    static var moviePressed: Movie?
    var activityIndicator = UIActivityIndicatorView()
    var imageMovieDetailsUrl: String!
    var titleMovieDetails: String!
    var plotMovieDetails: String!
    var yearMovieDetails: String!
    var genreMovieDetails: String!
    var directorMovieDetails: String!
    var actorsMovieDetails: String!
    var countryMovieDetails: String!
    var languageMovieDetails: String!
    var productionMovieDetails: String!
    var releasedMovieDetails: String!
    var runtimeMovieDetails: String!
    var awardsMovieDetails: String!
    var ratingMovieDetails: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        loadMovieDetailsAPI()
    }
    
    public func loadMovieDetailsAPI() {
        let movieID: String = CellsDetailsViewController.moviePressed!.imdbID!
        let urlApi = "http://www.omdbapi.com/?apikey=7e9fe69e&i=\(movieID)"
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        if let poster = myJson["Poster"] {
                            self.imageMovieDetailsUrl = String(describing: poster)
                        }
                        if let title = myJson["Title"] {
                            self.titleMovieDetails = String(describing: title)
                        }
                        if let plot = myJson["Plot"] {
                            self.plotMovieDetails = String(describing: plot)
                        }
                        if let year = myJson["Year"] {
                            self.yearMovieDetails = String(describing: year)
                        }
                        if let genre = myJson["Genre"] {
                            self.genreMovieDetails = String(describing: genre)
                        }
                        if let director = myJson["Director"] {
                            self.directorMovieDetails = String(describing: director)
                        }
                        if let actors = myJson["Actors"] {
                            self.actorsMovieDetails = String(describing: actors)
                        }
                        if let country = myJson["Country"] {
                            self.countryMovieDetails = String(describing: country)
                        }
                        if let language = myJson["Language"] {
                            self.languageMovieDetails = String(describing: language)
                        }
                        if let production = myJson["Production"] {
                            self.productionMovieDetails = String(describing: production)
                        }
                        if let released = myJson["Released"] {
                            self.releasedMovieDetails = String(describing: released)
                        }
                        if let runtime = myJson["Runtime"] {
                            self.runtimeMovieDetails = String(describing: runtime)
                        }
                        if let awards = myJson["Awards"] {
                            self.awardsMovieDetails = String(describing: awards)
                        }
                        if let rating = myJson["Rating"] {
                            self.ratingMovieDetails = String(describing: rating)
                        }
                        
                        let imageUrl = self.imageMovieDetailsUrl
                        let url = URL(string: imageUrl!)
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.describeImage.image = UIImage(data: data!)
                            self.describeTitle.text = self.titleMovieDetails
                            self.describePlot.text = self.plotMovieDetails
                            self.describeYear.text = self.yearMovieDetails
                            self.describeGenre.text = self.genreMovieDetails
                            self.describeDirector.text = self.directorMovieDetails
                            self.describeActors.text = self.actorsMovieDetails
                            self.describeCountry.text = self.countryMovieDetails
                            self.describeLanguage.text = self.languageMovieDetails
                            self.describeProduction.text = self.productionMovieDetails
                            self.describeReleased.text = self.releasedMovieDetails
                            self.describeRuntime.text = self.runtimeMovieDetails
                            self.describeAwards.text = self.awardsMovieDetails
                            self.describeRating.text = self.ratingMovieDetails
                        }
                    }
                    catch {
                        print("Error in JSONSerialization")
                    }
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
}
