//
//  ViewController.swift
//  Programmatic-UI-Xibs-Storyboards
//
//  Created by Alex Paul on 1/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
  
  private let podcastView = PodcastView()
  
  private var podcasts = [Podcast]() {
    didSet {
        DispatchQueue.main.async {
            self.podcastView.collectionView.reloadData()
        }
    }
  }

  override func loadView() {
    view = podcastView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    navigationItem.title = "Podcasts"
    podcastView.collectionView.delegate = self
    podcastView.collectionView.dataSource = self
    
    // register collection view cell
    // podcastView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "podcastCell")
    
    // or
    
    // register collection view cell using xib/nib
    podcastView.collectionView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "podcastCell")
    
    fetchPodcasts()
  }
    
  
  private func fetchPodcasts(_ name: String = "swift") {
    PodcastAPIClient.fetchPodcast(with: name) { (result) in
      switch result {
      case .failure(let appError):
        print("error fetching podcasts: \(appError)")
      case .success(let podcasts):
        self.podcasts = podcasts
      }
    }
  }
}

extension PodcastViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
        fatalError("failed to downcast to podcast cell")
    }
    cell.backgroundColor = .blue
    return cell
  }
}

extension PodcastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.95 // 95% the width of the device
        return CGSize(width: itemWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.row]
        print(podcast.collectionName)
    
    // segue to the PodcastDetailController
    // access the PodcastDetailController from storyboard
    
    // make sure that the storyboard id is set for the PodcastDetailController
    let podcastDetailStoryboard = UIStoryboard(name: "PodcastDetail", bundle: nil)
        guard let podcastDetailController = podcastDetailStoryboard.instantiateViewController(identifier: "PodcastDetailController") as? PodcastDetailController else {
            fatalError("could not downcast to PodcastDetailControlle")
        }
        podcastDetailController.podcast = podcast
        
        
        navigationController?.pushViewController(podcastDetailController, animated: true)
    }
}
