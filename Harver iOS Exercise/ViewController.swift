//
//  ViewController.swift
//  Harver iOS Exercise
//
//  Created by Achsuthan Mahendran on 11/17/19.
//  Copyright © 2019 Achsuthan Mahendran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //This project has the answers for Question 5 and 6
    
    let words = ["start", "citizen", "flour", "circle", "petty", "neck", "seem", "lake", "page", "color", "ceiling", "angle", "agent", "mild", "touch", "bite", "cause", "finance", "greet", "eat", "minor", "echo", "aviation", "baby", "role", "surround", "incapable", "refuse", "reliable", "imperial", "outer", "liability", "struggle", "harsh", "coerce", "front", "strike", "rage", "casualty", "artist", "ex", "transaction", "parking", "plug", "formulate", "press", "kettle", "export", "hiccup", "stem", "exception", "report", "central", "cancer", "volunteer", "professional", "teacher", "relax", "trip", "fountain", "effect", "news", "mark", "romantic", "policy", "contemporary", "conglomerate", "cotton", "happen", "contempt", "joystick", "champagne", "vegetation", "bat", "cylinder", "classify", "even", "surgeon", "slip", "private", "fox", "gravity", "aspect", "hypnothize", "generate", "miserable", "breakin", "love", "chest", "split", "coach", "pound", "sharp", "battery", "cheap", "corpse", "hobby", "mature", "attractive", "rock"]
    
    
    func getRandomWordSync() -> String {
        let index = randomInRange(min: 0, max: 100)
        let word = words[index]
        return word
    }
    
    func getRandomWord(slow: Bool = false, completion:@escaping(_ word: String?, _ error: String?)->()) {
        let index = randomInRange(min: 0, max: 200)
        guard let word = words[safe: index] else {
            return completion(nil, "Fatal error: Index out of range")
        }
        
        let delay = slow ? 10 : 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(word, nil)
        }
    }
    
    func randomInRange(min: Int, max: Int) -> Int {
        return Int.random(in: min ..< max)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.question5()
    }
    
    func question5(){
        let filename = getDocumentsDirectory().appendingPathComponent("myfile.txt")
        
        do {
            try "".write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Error")
        }
        
        
        print("\nQ4 Answer = > \n")
        let myGroup2 = DispatchGroup()
        for i in 1...100 {
            var randomString = ""
            if(i%15 == 0){
                randomString = "FizzBuzz"
            }
            else if(i%5 == 0){
                randomString = "Buzz"
            }else if(i%3 == 0){
                randomString = "Fizz"
            }
            else {
                myGroup2.enter()
                getRandomWord(slow: true) { (word, error) in
                    if let val = word{
                        randomString = val
                    }
                    else {
                        randomString = "It shouldn't break anything!"
                    }
                    myGroup2.leave()
                }
            }
            myGroup2.notify(queue: .main) {
                do {
                    
                    if let fileHandle = FileHandle(forWritingAtPath: filename.path) {
                        fileHandle.seekToEndOfFile()
                        fileHandle.write("\(i) :  \(randomString) \n".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
                        fileHandle.closeFile()
                    }
                    else {
                        print("Can't open fileHandle")
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        myGroup2.notify(queue: .main) {
            
            do {
                let contents = try String(contentsOf: filename, encoding: String.Encoding.utf8)
                //print(contents)
            } catch {
                print(error)
            }
            let session = URLSession.shared
            let url = URL(string: "URL TO UPLOAD")!
            
            let request = URLRequest(url: url)
            
            //Create a JSON to upload the file
            let json = [
                "username": "zaphod42",
                "message": "So long, thanks for all the fish!"
            ]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
                // hanlder for the api response
            }
            task.resume()
            
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

