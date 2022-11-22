//
//  ViewController.swift
//  Pokemon Card Game
//
//  Created by JubeHuang黃冬伊 on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {
    var totalImageNames = ["太陽珊瑚","果然翁","可達鴨","雪吞蟲","仙子伊布","菊草葉","夢幻","多邊獸","胖丁","六尾","皮卡丘超極巨化","皮卡丘","巴大蝶","傑尼龜","小火龍","妙蛙"]
    var cardImageNames = [String]()
    @IBOutlet var cards: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shuffleCards()
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            <#code#>
        }
    }
    
    
    func shuffleCards() {
        totalImageNames.shuffle()
        for i in 0...11 {
            cardImageNames.append(totalImageNames[i])
        }
        for i in 0...11 {
            cardImageNames.append(cardImageNames[i])
        }
        cardImageNames.shuffle()
    }

}

