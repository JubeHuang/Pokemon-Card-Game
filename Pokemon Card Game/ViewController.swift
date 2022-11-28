//
//  ViewController.swift
//  Pokemon Card Game
//
//  Created by JubeHuang黃冬伊 on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cards: [UIButton]!
    
    var totalImageNames = ["太陽珊瑚","果然翁","可達鴨","雪吞蟲","仙子伊布","菊草葉","夢幻","多邊獸","胖丁","六尾","皮卡丘超極巨化","皮卡丘","巴大蝶","傑尼龜","小火龍","妙蛙"]
    var score = 0
    var pickedCardNums = [Int]()
    var cardImageNames = [String]()
    var timer = Timer()
    var coundownTime = 10
    var firstCountDown = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
        countDownTimer(selector: #selector(countDown10))
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        //利用sender尋找按下的卡片編號 存進cardNum
        if let cardNum = cards.firstIndex(of: sender) {
            //當牌沒被翻面時，才可翻牌
            if cards[cardNum].configuration?.image == UIImage(named: "cardBack") {
                revealCardImage(cardNum: cardNum, imageName: cardImageNames[cardNum])
                pickedCardNums.append(cardNum)
                //當翻了兩張卡牌時
                if pickedCardNums.count == 2 {
                    //不能再按第三張牌
                    for i in 0..<cards.count{
                        cards[i].isEnabled = false
                    }
                    //當兩張卡牌名稱相同
                    if cardImageNames[pickedCardNums[0]] == cardImageNames[pickedCardNums[1]] {
                        for i in 0...1 {cards[pickedCardNums[i]].alpha = 0.7}
                        score += 1
                        scoreLabel.text = "\(score)"
                        pickedCardNums.removeAll()
                        for i in 0..<cards.count{
                            cards[i].isEnabled = true
                        }
                    } else {
                        //等翻完第二張牌0.3s+兩張翻回背面0.3s
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                            for i in 0...1{
                                self.revealCardImage(cardNum: self.pickedCardNums[i], imageName: "cardBack")
                            }
                            self.pickedCardNums.removeAll()
                            for i in 0..<self.cards.count{
                                self.cards[i].isEnabled = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func shuffleCards(){
        totalImageNames.shuffle()
        for i in 0...11 {
            cardImageNames.append(totalImageNames[i])
        }
        for i in 0...11 {
            cardImageNames.append(cardImageNames[i])
        }
        cardImageNames.shuffle()
    }
    
    func revealCardImage(cardNum: Int, imageName: String){
        UIView.transition(with: cards[cardNum], duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        cards[cardNum].configuration?.image = UIImage(named: imageName)
    }
    
    func changeTotalImage(imageCount: Int, imageName: String){
        for i in 0..<imageCount {
            revealCardImage(cardNum: i, imageName: imageName)
        }
    }
    
    @objc func countDown10() {
        firstCountDown = true
        coundownTime -= 1
        timerLabel.text = "\(coundownTime)"
        if coundownTime == 0 {
            timer.invalidate()
            firstCountDown = false
            changeTotalImage(imageCount: cards.count, imageName: "cardBack")
            coundownTime = 60
            timerLabel.text = "\(coundownTime)"
            countDownTimer(selector: #selector(countDown60))
        }
    }
    
    @objc func countDown60() {
        coundownTime -= 1
        timerLabel.text = "\(coundownTime)"
        //倒數結束or滿分
        if coundownTime == 0 || score == 12{
            timer.invalidate()
            firstCountDown = true
            //alert
            let gameOverAlert = UIAlertController(title: "Gotcha", message: "You Got \(score) Score.", preferredStyle: .alert)
            let replayBtn = UIAlertAction(title: "Replay", style: .default) { _ in
                self.gameReplay()
            }
            gameOverAlert.addAction(replayBtn)
            present(gameOverAlert, animated: true)
        }
    }
    
    func countDownTimer(selector:Selector){
        //app開啟後一秒揭露卡牌
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            //控制第一次才會揭露卡牌圖案
            if self.firstCountDown == true {
                for i in 0..<self.cards.count {
                    self.revealCardImage(cardNum: i, imageName: self.cardImageNames[i])
                }
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: selector, userInfo: nil, repeats: true)
        }
    }
    
    func gameReplay(){
        changeTotalImage(imageCount: cards.count, imageName: "cardBack")
        for i in 0..<cards.count {
            cards[i].alpha = 1
        }
        score = 0
        coundownTime = 10
        scoreLabel.text = "\(score)"
        timerLabel.text = "\(coundownTime)"
        pickedCardNums = []
        cardImageNames = []
        shuffleCards()
        countDownTimer(selector: #selector(countDown10))
    }
}

