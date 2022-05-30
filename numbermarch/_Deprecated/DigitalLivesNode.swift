//
//  EnemyNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation
import SpriteKit

class DigitalLivesNode: DigitalCharacterNode {
    
    // MARK: - Public Properties
    
    
    public var lives: Int = 3 {
        didSet {
            self.setLivesBarVisibility(lives: lives)
        }
    }
    
    // MARK: - Initializers
    init(lives: Int = 3, size: CGSize = CGSize(width: 15, height: 40)) {
        super.init(value: 0, size: size)
        self.lives = lives
        self.setLivesBarVisibility(lives: lives)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLivesBarVisibility(lives: Int) {
        guard lives >= 0 && lives <= 3 else { return }
        
        switch lives {
        case 0:
            self.value = 14
        case 1:
            self.value = 13
        case 2:
            self.value = 12
        default:
            self.value = 11
            return
        }
    }
}
