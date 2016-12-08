//
//  CauseDetailViewController.swift
//  Miracle
//
//  Created by Simon Cao on 12/7/16.
//  Copyright © 2016 Miracle. All rights reserved.
//

import UIKit
import Firebase

class CauseDetailViewController: UIViewController {

    @IBOutlet var donateImage: UIImageView!
    @IBOutlet var shortDescription: UILabel!
    @IBOutlet var charityName: UILabel!
    @IBOutlet var numberOfPeopleDonated: UILabel!
    @IBOutlet var aboutCharity: UITextView!
    @IBOutlet var aboutCause: UITextView!
    @IBOutlet var exit: UIButton!
    @IBOutlet var donationAmount: UITextField!
    
    var whichFeature: String?
    
    var ref: FIRDatabaseReference!
    
    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func donateClick(_ sender: Any) {
        let alert = UIAlertController(title: "Thank you!", message: "You donated $" + donationAmount.text!, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        let cause = self.ref.child(whichFeature!)
        
        cause.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject] {
                var numberDonated = post["numberDonated"] as! Int
                numberDonated += 1
                post["numberDonated"] = numberDonated as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frameRect = donationAmount.frame
        frameRect.size.height = 100
        donationAmount.frame = frameRect
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        ref = FIRDatabase.database().reference()
        
        let cause = self.ref.child(whichFeature!)
        
        // get data from firebase
        cause.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            
            let globalPicUrl = value["image_url"] as! String
            
            self.charityName.text = value["name"] as? String
            self.shortDescription.text = value["shortDescription"] as? String
            self.aboutCause.text = value["description"] as? String
            self.aboutCharity.text = value["aboutCharity"] as? String
            
            self.downloadFeatureImage(NSURL(string: globalPicUrl) as! URL)
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.donateImage.frame.size.width, height: self.donateImage.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
            overlay.isUserInteractionEnabled = false
            self.donateImage.addSubview(overlay)
        })
        
        cause.observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.numberOfPeopleDonated.text = String(describing: value["numberDonated"] as! Int)
        })

        // Do any additional setup after loading the view.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadFeatureImage(_ url: URL){
        print("Download Started")
        print(url)
        print("lastPathComponent: " + (url.lastPathComponent ))
        getDataFromUrl(url: url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.donateImage.image = UIImage(data: data)
            }
        }
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
