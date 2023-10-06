//
//  ViewController.swift
//  Vocabulary Game
//
//  Created by Justin Choi on 4/1/2017.
//  Copyright © 2017 Man Choi & Justin Choi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var vocab_list: [String] = ["dictionary","university","executive","computer"]  // list of vocab
    var answer: String = ""
    var secret: Int = 0
    var game_text_array: [Character] = []   // array of char
    var numbers_seq: [Int] = [1]            // array of int
    var hidden_chars: [Character] = []      // array of char
    var life: Int = 0
    var replace_list: [Int] = []            // array of int
    var input: Character = "_"
    var cur_text: String = ""
    
    @IBOutlet weak var lbl_vocab: UILabel!
    @IBOutlet weak var lbl_input: UITextField!
    @IBOutlet weak var lbl_life: UILabel!
    @IBOutlet weak var img1: UIImageView!
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        print("submit clicked")
        check_answer()
    }
    
    
    func check_answer() {
        
        var str: String
        var match: Bool = false
        
        if life <= 0 {                      // already game over -> new game
            init_game()
            return
        }
        if hidden_chars.count == 0 {        // already bingo - new game
            init_game()
            return
        }
        if !lbl_input.hasText {return}      // no input yet, do nothing

        str = lbl_input.text!
        print( "str=\(str)")
        input = str[ str.startIndex ]
        print( "input=\(input)" )
        
        // compare input with answer
        match = false
        while hidden_chars.count > 0 {
            var tmp_match: Bool = false
            for i in 0...hidden_chars.count-1 {
                if (input == hidden_chars[i]) {     // hit
                    tmp_match = true
                    match = true
                    game_text_array.remove(at: replace_list[i])
                    game_text_array.insert(input, at:replace_list[i])
                    // cur_text.remove( at: cur_text.index(cur_text.startIndex, offsetBy:replace_list[i]) )
                    // cur_text.insert(input, at: cur_text.index(cur_text.startIndex, offsetBy:replace_list[i]) )
                    cur_text = String(game_text_array)
                    hidden_chars.remove( at: i )
                    replace_list.remove( at: i )
                    print("game_text_array=\(game_text_array)")
                    print("cur_text=\(cur_text)")
                    print("hidden_chars=\(hidden_chars)")
                    print("replace_list=\(replace_list)")
                    break
                }
            }
            if !tmp_match {break}
        }
        
        
        if match {
            if hidden_chars.count == 0 {   // Bingo! End of game.
                print("Bingo")
                lbl_input.text = "🎉BINGO!🎉"
            } else { lbl_input.text = "" }
        } else {
            lbl_input.text = ""
            life = life - 1
            
            print("life=\(life)")
            display_life()
            
            if life == 4 {
                
                
                img1.image = #imageLiteral(resourceName: "img3")  // show different images when different amount of "lifes"
                
                
            } else if life == 3 {
                
                img1.image = #imageLiteral(resourceName: "img2")
                
            } else if life == 2 {
                
                img1.image = #imageLiteral(resourceName: "img1")
            
            } else if life <= 0 {
                
                // show hangman image
                
                // game over
                img1.image = #imageLiteral(resourceName: "game-over")
                img1.isHidden = false
                print("GAME-OVER!")
                lbl_input.text = "GAME-OVER!"
            }
            else {
                display_life()
            }
        }
        
        print( "cur_text=\(cur_text)" )
        lbl_vocab.text = cur_text        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        init_game()
    }
    
    func init_game() {
        print( "vocab_list.count=\(vocab_list.count)" )
        secret = Int( arc4random_uniform( UInt32(vocab_list.count) ) )
        print( "secret=\(secret)" )
        answer = vocab_list[secret]
        print( "answer=\(answer)" )
        game_text_array = Array(answer)
        print( "game_text_array=\(game_text_array)" )
        
        // generate random number sequence to store in replace_list

        numbers_seq = Array(0...answer.count-1)
        print( "numbers=\(numbers_seq)" )
        replace_list = []
        for _ in 1...Int(answer.count/2) {
            var x: Int
            var n: Int
            x = Int( arc4random_uniform( UInt32(numbers_seq.count) ) )
            n = numbers_seq.remove(at: x)
            replace_list.append(n)
        }
        print( "replace_list=\(replace_list)" )
        
        // cover selected letters with "*"
        //selected letters are "replace_list"
        
        hidden_chars = []
        for x in replace_list {
            hidden_chars.append(game_text_array[x])
            game_text_array[x] = "*"
        }
        print( "hidden_chars=\(hidden_chars)" )
        print( "game_text_array=\(game_text_array)" )
    
        life = 5  //amount of life
        display_life()
    
        img1.image = #imageLiteral(resourceName: "img1") //load image
        img1.isHidden = false
    

        cur_text = String(game_text_array)
        print( "cur_text=\(cur_text)")
        lbl_vocab.text = cur_text
        
        lbl_input.text = ""
   
    }
    
    
    func display_life() {  // display "life"
        if life > 0 {
            lbl_life.text = ""
            for _ in 1...life {
                lbl_life.text = lbl_life.text! + "💙"
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
