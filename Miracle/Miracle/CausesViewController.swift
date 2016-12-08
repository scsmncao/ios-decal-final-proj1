//
//  CausesViewController.swift
//  Miracle
//
//  Created by Simon Cao on 12/5/16.
//  Copyright © 2016 Miracle. All rights reserved.
//

import UIKit
import Firebase

class CausesViewController: UIViewController {

    @IBOutlet var globalCause: UIButton!
    @IBOutlet var localCauseOne: UIButton!
    @IBOutlet var localCauseTwo: UIButton!
    
    @IBOutlet var charityName: UILabel!
    @IBOutlet var shortDescription: UILabel!
    
    @IBOutlet var localOneShortDescription: UILabel!
    @IBOutlet var localOneCharityName: UILabel!
    
    @IBOutlet var localTwoShortDescription: UILabel!
    @IBOutlet var localTwoCharityName: UILabel!

    
    @IBAction func featureDetails(_ sender: Any) {
        performSegue(withIdentifier: "showDetails", sender: sender)
        
    }
    
    @IBAction func localOneDetails(_ sender: Any) {
        performSegue(withIdentifier: "showDetails", sender: sender)
    }
    
    @IBAction func localTwoDetails(_ sender: Any) {
        performSegue(withIdentifier: "showDetails", sender: sender)
    }
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalCause.tag = 0
        localCauseOne.tag = 1
        localCauseTwo.tag = 2
        
        ref = FIRDatabase.database().reference()
        
        let global = self.ref.child("global")
        let local1 = self.ref.child("local1")
        let local2 = self.ref.child("local2")
        
        // get data from firebase
        global.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            
            let globalPicUrl = value["image_url"] as! String
            
            self.charityName.text = value["name"] as? String
            self.shortDescription.text = value["shortDescription"] as? String
        
            self.downloadFeatureImage(NSURL(string: globalPicUrl) as! URL, button: self.globalCause)
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.globalCause.frame.size.width, height: self.globalCause.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            overlay.isUserInteractionEnabled = false
            self.globalCause.addSubview(overlay)
        })
        
        local1.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            
            let localOne = value["image_url"] as! String
            
            self.localOneCharityName.text = value["name"] as? String
            self.localOneShortDescription.text = value["shortDescription"] as? String
            
            self.downloadFeatureImage(NSURL(string: localOne) as! URL, button: self.localCauseOne)
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.localCauseOne.frame.size.width, height: self.localCauseOne.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            overlay.isUserInteractionEnabled = false
            self.localCauseOne.addSubview(overlay)
        })
        
        local2.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            
            let localTwo = value["image_url"] as! String
            
            self.localTwoCharityName.text = value["name"] as? String
            self.localTwoShortDescription.text = value["shortDescription"] as? String
            
            self.downloadFeatureImage(NSURL(string: localTwo) as! URL, button: self.localCauseTwo)
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.localCauseTwo.frame.size.width, height: self.localCauseTwo.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            overlay.isUserInteractionEnabled = false
            self.localCauseTwo.addSubview(overlay)
        })
        
//        let users = ref?.child(byAppendingPath: "users")

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadFeatureImage(_ url: URL, button: UIButton){
        print("Download Started")
        print(url)
        print("lastPathComponent: " + (url.lastPathComponent ))
        getDataFromUrl(url: url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                button.setImage(UIImage(data: data), for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetails") {
            let detailView = segue.destination as! CauseDetailViewController
            print("prepare for segue")
            let button = sender as! UIButton
            switch button.tag {
            case 0:
                detailView.whichFeature = "global"
                break;
            case 1:
                detailView.whichFeature = "local1"
                break;
            case 2:
                detailView.whichFeature = "local2"
                break;
            default:
                break;
            }
        }
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
