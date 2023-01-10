//
//  ViewController.swift
//  CameraFilter
//
//  Created by Al-Hussein Anwar on 09/01/2023.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosVC = navC.viewControllers.first as? PhotosCollectionViewController else { return }
        
        photosVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)

    }

    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
        
    }

    
    @IBAction func applyFilterAction(sender : UIButton) {
        
        guard let sourceImage = self.photoImageView.image else { return }
        
        FiltersService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    
    
}
