//
//  Movie.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class Movie {
    var title: String?
    var year: String?
    var type: String?
    var poster: UIImage?
    var posterURL: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var director: String?
    var writer: String?
    var actors: String?
    var plot: String?
    var language: String?
    var country: String?
    var awards: String?
    var imdbRating: String?
    var imdbVotes: String?
    var production: String?
    var imdbID: String?
    
    init(title: String = "", year: String = "", type: String = "", poster: UIImage = UIImage(), posterURL: String = "", imdbID: String = "") {
        self.title = title
        self.year = year
        self.type = type
        self.poster = poster
        self.imdbID = imdbID
        self.posterURL = posterURL
    }
}
