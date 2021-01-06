//
//  ViewController.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DataEnteredDelegate {
    
    func userEnterInfo(info1: String, info2: String, info3: String) {
        moviesArray.append(Movie(title: info1, year: info3, type: info2))
        filteredMoviesArray.append(Movie(title: info1, year: info3, type: info2))
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nothingIsFoundView: UIView!
    var activitySpinner = UIActivityIndicatorView()
    
    var moviesArray: [Movie] = []
    var filteredMoviesArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredMoviesArray = moviesArray
        tableView.keyboardDismissMode = .onDrag
        tableView.isHidden = true
        nothingIsFoundView.isHidden = false
        activitySpinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activitySpinner)
        activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CellsDetailsViewController.moviePressed = filteredMoviesArray[indexPath.row]
        performSegue(withIdentifier: "toDescribingInfo", sender: nil)
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.movieTitleLabel.text = self.filteredMoviesArray[indexPath.row].title
        cell.typeLabel.text = self.filteredMoviesArray[indexPath.row].type
        cell.movieYearLabel.text = self.filteredMoviesArray[indexPath.row].year
        
        let imageUrl = self.filteredMoviesArray[indexPath.row].posterURL
        let url = URL(string: imageUrl!)
        let data = try? Data(contentsOf: url!)
        if data == nil {
            cell.moviePosterView.image = UIImage()
        } else {
            cell.moviePosterView.image = UIImage(data: data!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in
            
            let varTemp: String = self.filteredMoviesArray[indexPath.row].title!
            
            self.filteredMoviesArray.remove(at: indexPath.row)
            
            self.moviesArray.removeAll(where: { $0.title == varTemp})
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
        }
        return [deleteAction]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchOmdbAPI(findStr: String) {
        self.moviesArray = []
        self.filteredMoviesArray = []
        let strReplacedSpacesToPluses = String(findStr.map {
            $0 == " " ? "+" : $0
        })
        let url = URL(string: "http://www.omdbapi.com/?apikey=7e9fe69e&s=\(strReplacedSpacesToPluses)&page=1")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }
            else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                        if let search = myJson["Search"] as? [NSDictionary] {
                            print("ssss")
                            for result in search {
                                print(result["Title"]!)
                                print(result["Type"]!)
                                print(result["Poster"]!)
                                print(result["Year"]!)
                                let auxName = result["Title"]
                                let auxType = result["Type"]
                                let auxPoster = result["Poster"]
                                let auxYear = result["Year"]
                                let auxImdbID = result["imdbID"]
                                self.moviesArray.append(Movie(title: auxName as! String, year: auxYear as! String, type: auxType as! String, posterURL: auxPoster as! String, imdbID: auxImdbID as! String))
                                self.filteredMoviesArray.append(Movie(title: auxName as! String, year: auxYear as! String, type: auxType as! String, posterURL: auxPoster as! String, imdbID: auxImdbID as! String))
                            }
                        }
                    }
                    catch {
                        print("Error")
                    }
                }
            }
            DispatchQueue.main.async {
                self.activitySpinner.stopAnimating()
                self.tableView.reloadData()
                if self.moviesArray.isEmpty || self.filteredMoviesArray.isEmpty {
                    self.tableView.isHidden = true
                    self.nothingIsFoundView.isHidden = false
                }
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText.count < 3 {
            filteredMoviesArray.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
            nothingIsFoundView.isHidden = false
        } else {
            tableView.isHidden = true
            activitySpinner.startAnimating()
            func cycleFuncSearching(text: String) {
                let search = text.lowercased()
                fetchOmdbAPI(findStr: search)
                self.tableView.reloadData()
                tableView.isHidden = false
                nothingIsFoundView.isHidden = true
            }
            cycleFuncSearching(text: searchText)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddingMovie" {
            let secondViewController = segue.destination as! AddingMovieViewController
            secondViewController.delegate = self
        }
    }
}
