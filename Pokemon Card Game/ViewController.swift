//
//  ViewController.swift
//  Pokemon Card Game
//
//  Created by JubeHuang黃冬伊 on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {
    var totalImageNames = ["太陽珊瑚","果然翁","可達鴨","雪吞蟲","仙子伊布","菊草葉","夢幻","多邊獸","胖丁","六尾","皮卡丘超極巨化","皮卡丘","巴大蝶","傑尼龜","小火龍","妙蛙"]
    var cardsArray = [Card]()
    var pickedCards = [Int]()
    @IBOutlet var cards: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0
    var timer = Timer()
    var countDownTime = Int()
    var firstCountDownStart = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
        countDownTime(seconds: 10, selector: #selector(countDown10))
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        //利用sender尋找按下的卡片編號 存進cardNum
        if let cardNum = cards.firstIndex(of: sender){
            //當牌沒被翻面時，才可翻牌
            if cards[cardNum].alpha == 1 {
                revealCardImage(num: cardNum, imageName: cardsArray[cardNum].name)
                pickedCards.append(cardNum)
                
                //當翻開兩張牌時 比對卡牌名稱是否一樣
                if pickedCards.count == 2 {
                    //不能再按第三張牌
                    for i in 0..<cards.count{
                        cards[i].isEnabled = false
                    }
                    //兩張牌相同
                    if cards[pickedCards[0]].configuration?.image == cards[pickedCards[1]].configuration?.image{
                        for i in 0...1{
                            self.cards[self.pickedCards[i]].alpha = 0.7
                        }
                        pickedCards = []
                        for i in 0..<cards.count{
                            cards[i].isEnabled = true
                        }
                        score += 1
                        scoreLabel.text = "\(score)"
                    }else {
                        //等翻完第二張牌0.3s+兩張翻回背面0.3s
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                            for i in 0...1{
                                self.revealCardImage(num: self.pickedCards[i], imageName: "cardBack")
                                for i in 0..<self.cards.count{
                                    self.cards[i].isEnabled = true
                                }
                            }
                            self.pickedCards = []
                        }
                    }
                }
            }
        }
        if score == 12 {
            timer.invalidate()
            gameOverAlert()
        }
    }
    
    @objc func countDown10() {
        countDownTime -= 1
        timerLabel.text = "\(countDownTime)"
        if countDownTime == 0 {
            timer.invalidate()
            firstCountDownStart = false
            for i in 0..<cards.count {
                revealCardImage(num: i, imageName: "cardBack")
            }
            //翻牌完後倒數60s
            countDownTime(seconds: 60, selector: #selector(countDown60))
        }
    }
    
    @objc func countDown60() {
        countDownTime -= 1
        timerLabel.text = "\(countDownTime)"
        if countDownTime == 0 {
            timer.invalidate()
            gameOverAlert()
        }
    }
    
    func countDownTime(seconds: Int, selector: Selector){
        //app開啟後一秒揭露卡牌
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            //控制第一次才會揭露卡牌圖案
            if self.firstCountDownStart == true {
                for i in 0..<self.cards.count {
                    self.revealCardImage(num: i, imageName: self.cardsArray[i].name)
                }
            }
            self.countDownTime = seconds
            //設定timer在不同計時段選取不同function
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: selector, userInfo: nil, repeats: true)
        }
    }
    
    func shuffleCards() {
        totalImageNames.shuffle()
        var card = Card(name: "")
        for i in 0...11 {
            card.name = totalImageNames[i]
            cardsArray.append(card)
        }
        for i in 0...11 {
            cardsArray.append(cardsArray[i])
        }
        cardsArray.shuffle()
        print(cardsArray)
    }
    
    func revealCardImage(num:Int, imageName:String) {
        UIView.transition(with: cards[num], duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        cards[num].configuration?.image = UIImage(named: imageName)
    }
    
    func reStart() {
        timerLabel.text = "10"
        scoreLabel.text = "0"
        score = 0
        pickedCards.removeAll()
        shuffleCards()
        countDownTime(seconds: 10, selector: #selector(countDown10))
        firstCountDownStart = true
        for i in 0..<cards.count{
            cards[i].alpha = 1
            revealCardImage(num: i, imageName: "cardBack")
        }
    }
    
    func gameOverAlert(){
        let gameOverAlert = UIAlertController(title: "Gotcha", message: "You get \(score) score", preferredStyle: .alert)
        //點擊btn後要做事
        let alertBtn = UIAlertAction(title: "Replay", style: .default){ _ in
            self.reStart()
        }
        gameOverAlert.addAction(alertBtn)
        present(gameOverAlert, animated: true)
    }

}

