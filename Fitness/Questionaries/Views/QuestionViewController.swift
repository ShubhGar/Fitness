//
//  ViewController.swift
//  Fitness
//
//  Created by Shubham Garg on 12/12/19.
//  Copyright © 2019 Shubham Garg. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var infoBtn: UIButton!
    
    var answerDic:[Int:CGFloat] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoBtn.layer.cornerRadius = infoBtn.frame.size.height/2
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setQuestionViews()
        self.collectionView.reloadData()
    }
    
    @IBAction func doneBtnAxn(_ sender: UIButton) {
        if self.pageControl.currentPage < (self.pageControl.numberOfPages - 1) {
            sender.setImage(UIImage(named: "ICON-Next-Training-Inactive"), for: .normal)
            sender.setTitle(nil, for: .normal)
            self.scrollToNextCell()
        }
    }
    
    func getCellSize()->CGSize{
        var top:CGFloat = 0
        var bottom:CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            top = window?.safeAreaInsets.top ?? 0
            bottom = window?.safeAreaInsets.bottom ?? 0
        }
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height - topView.bounds.size.height - bottomView.bounds.size.height - top - bottom
        return CGSize(width: width, height:  height)
    }
    
    func scrollToNextCell(){
        self.pageControl.currentPage += 1
        if self.pageControl.currentPage == (self.pageControl.numberOfPages - 1) {
            doneBtn.setImage(nil, for: .normal)
            doneBtn.setTitle(DONE, for: .normal)
        }
        //get cell size
        let cellSize = getCellSize()
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset
        
        //scroll to next cell
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y:  contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    func scrollToLastCell(){
        self.pageControl.currentPage -= 1
        if self.pageControl.currentPage < self.pageControl.numberOfPages - 1{
            doneBtn.setImage(UIImage(named: "ICON-Next-Training-Inactive"), for: .normal)
            doneBtn.setTitle(nil, for: .normal)
        }
        //get cell size
        let cellSize = getCellSize()
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset
        
        //scroll to next cell
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width, y:  contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        
    }
    
    @IBAction func exitBtnAxn(_ sender: Any) {
    }
    
    @IBAction func infoBtnAxn(_ sender: Any) {
    }
    
    func setQuestionViews(){
        layout.itemSize = getCellSize()
    }
}



extension QuestionViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = Questions.allCases.count
        return Questions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: QuestionCollectionViewCell.self), for: indexPath) as! QuestionCollectionViewCell
        cell.setQuestion(index: indexPath.row, percentValue: answerDic[indexPath.row] ?? 0)
        cell.scrollDelegate = self
        cell.answerDelegate = self
        return cell
    }
    
}
extension QuestionViewController: UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = self.collectionView.frame.size.width
        self.pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
        if self.pageControl.currentPage < self.pageControl.numberOfPages - 1{
            doneBtn.setImage(UIImage(named: "ICON-Next-Training-Inactive"), for: .normal)
            doneBtn.setTitle(nil, for: .normal)
        }
        else{
            doneBtn.setImage(nil, for: .normal)
            doneBtn.setTitle(DONE, for: .normal)
        }
    }
    
    
}


extension QuestionViewController:SlideScrollDelegate{
    
    func scrollSlide(direction: Direction) {
        if direction == .right{
            self.scrollToLastCell()
        }
        else if direction == .left{
            self.scrollToNextCell()
        }
    }
    
}


extension QuestionViewController:AnswerValueDelegate{
    
    func valueChanged(index: Int, percentage: CGFloat) {
        answerDic[index] = percentage
    }
    
}
