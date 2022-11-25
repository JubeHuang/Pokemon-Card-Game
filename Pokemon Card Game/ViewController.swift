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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        //利用sender尋找按下的卡片編號 存進cardNum
        if let cardNum = cards.firstIndex(of: sender){
            revealCardImage(num: cardNum, imageName: cardsArray[cardNum].name)
            cardsArray[cardNum].flip = true
            pickedCards.append(cardNum)
            
            //當翻開兩張牌時 比對卡牌名稱是否一樣
            if pickedCards.count == 2 {
                //不能再按第三張牌
                for i in 0..<cards.count{
                    cards[i].isEnabled = false
                }
                if cards[pickedCards[0]].configuration?.image == cards[pickedCards[1]].configuration?.image{
                    for i in 0...1{
                        self.cards[self.pickedCards[i]].alpha = 0.7
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                        self.pickedCards = []
                        for i in 0..<self.cards.count{
                            self.cards[i].isEnabled = true
                        }
                    }
                    score += 1
                    scoreLabel.text = "\(score)"
                }else {
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
    
    
    func shuffleCards() {
        totalImageNames.shuffle()
        var card = Card(name: "", flip: false)
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

}

