//
//  ViewController.swift
//  VoterQuery
//
//  Created by RnD on 9/1/20.
//  Copyright © 2020 RnD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let yourAPIKey = ""
    var queryAddress = ""
    let electionID = 2000
    var contestsArray = [Contest]()
    var districtName = ""
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.isHidden = true
        
        addressTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorView.stopAnimating()
    }

    //MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: Any) {
        buttonAction()
    }
    
    func buttonAction() {
        // Process query
        if !addressTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            queryAddress = addressTextField.text!
            getVoterDataURLSession(address: queryAddress)
        } else {
            DispatchQueue.main.async {
                self.statusLabel.text = "No address provided"
                self.statusLabel.isHidden = false
            }
        }
        
        // Dismiss keyboard
        addressTextField.resignFirstResponder()
        
        // Clear text field and reset label
        addressTextField.text = ""
        statusLabel.isHidden = true
    }
    
    //MARK: - Networking
    
    func createURL(using address: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "civicinfo.googleapis.com"
        components.path = "/civicinfo/v2/voterinfo"
        components.queryItems = [
            URLQueryItem(name: "address", value: queryAddress),
            URLQueryItem(name: "electionId", value: String(electionID)),
            URLQueryItem(name: "key", value: yourAPIKey)
        ]
        
        guard let url = components.url else {
            return nil
        }

        return url
    }
    
    func getVoterDataURLSession(address: String) {
        activityIndicatorView.startAnimating()
        
        guard let url = createURL(using: address) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let json = data else {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = error?.localizedDescription
                    
                    self.activityIndicatorView.stopAnimating()
                }
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                switch (response as? HTTPURLResponse)?.statusCode as Int? {
                case 400:
                    DispatchQueue.main.async {
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = "Failed to parse address"
                    }
                case 404:
                    DispatchQueue.main.async {
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = "No information for this address"
                    }
                default:
                    break
                }
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
                return
            }

            self.updateData(json: json)
            
        }.resume()
    }
    
    func updateData(json: Data) {
        do {
            let response = try JSONDecoder().decode(VoterInfoQuery.self, from: json)
            contestsArray = response.contests
            
            // Filter results
            if contestsArray.isEmpty == false {
                let filtered = contestsArray.filter {
                let firstPredicate = $0.level?.contains(.country) ?? false
                let secondPredicate = $0.roles?.contains("legislatorLowerBody") ?? false
                return firstPredicate && secondPredicate
            }
                
                // If exists, extract numbers
                if let name = filtered.first?.district.name, checkForNumbers(name: name) {
                    districtName = name.numbers
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        
                        self.performSegue(withIdentifier: "showResult", sender: self)
                    }
                } else {
                    // Show name
                    districtName = filtered.first?.district.name ?? ""
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        
                        self.performSegue(withIdentifier: "showResult", sender: self)
                    }
                }
            }
                
        } catch {
            print(error)
        }
    }
    
    func checkForNumbers(name: String) -> Bool {
        let decimalRange = name.rangeOfCharacter(from: CharacterSet.decimalDigits)
        if decimalRange != nil {
            return true
        }
        
        return false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            let destination = segue.destination as? ResultsViewController
            destination?.districtName = districtName
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonAction()
        
        return true
    }
    
}
