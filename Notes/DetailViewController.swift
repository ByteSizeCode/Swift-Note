//
//  DetailViewController.swift
//  notes
//
//  Created by Isaac Raval on 4/2/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    //MARK: - Configurable Constants
    let ENABLE_BACKGROUND_NOTES_IMAGE = false;
    let SET_CUSTOM_FONT = false;
    
    @IBOutlet weak var textView: UITextView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let textViewContents = contentOfNote {
            
            //Set contents of textView from latest value of appropriate Note object (in array in MasterViewController)
            if let textViewContent = textView {
                textViewContent.text = textViewContents.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.delegate = self
        configureView()
        
        //Optionally add background image to textView
        if(ENABLE_BACKGROUND_NOTES_IMAGE) {
            let bkgdImage = UIImageView(frame: textView.bounds)
            bkgdImage.image = UIImage(named: "ivory-off-white-paper-texture.jpg")
            textView.backgroundColor = UIColor.clear
            bkgdImage.contentMode = .scaleAspectFill
            bkgdImage.frame = UIScreen.main.bounds //Make image full screen
            textView.addSubview(bkgdImage)
            self.view.addSubview(textView)
            textView.sendSubviewToBack(bkgdImage)
        }
        
        //Optionally set font
        if(SET_CUSTOM_FONT) {
            textView.font = UIFont(name: "Arial-BoldMT ", size: 20)
        }
    }

    var contentOfNote: NSString? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    //Called every time text changes in note
    func textViewDidChange(_ textView: UITextView) {
        print("Text Changed!: \(textView.text!)");
        
        //Get date and format it
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateTime = formatter.string(from: Date())
        
        //Find out what cell we are on
        if let theCurrentCell = MasterViewController.vals.currentCell {
            
            //Update noteContents of Note object with latest text
            MasterViewController.vals.objects[theCurrentCell].noteContents = textView.text!
            
            //Update noteContents of Note object with latest text
            MasterViewController.vals.objects[theCurrentCell].date = dateTime
        }
    }
}

extension UINavigationController {
    func setBackgroundImage(_ image: UIImage) {
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .blackTranslucent
        
        let logoImageView = UIImageView(image: image)
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(logoImageView, belowSubview: navigationBar)
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
            ])
    }
}
