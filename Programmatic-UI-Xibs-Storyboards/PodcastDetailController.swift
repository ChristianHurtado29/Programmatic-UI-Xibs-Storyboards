//
//  PodcastDetailController.swift
//  Programmatic-UI-Xibs-Storyboards
//
//  Created by Christian Hurtado on 1/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import ImageKit

class PodcastDetailController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    var podcast: Podcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard let podcast = podcast else {
            fatalError("did not load a podcast from segue")
        }
        artistLabel.text = podcast.artistName
        imageView.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                break // TODO: update default image
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
}
