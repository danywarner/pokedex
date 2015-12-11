//
//  Pokemon.swift
//  pokedex
//
//  Created by Daniel Warner on 12/11/15.
//  Copyright © 2015 Daniel Warner. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexid: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexid: Int {
        return _pokedexid
    }
    
    init(name: String, pokedexid: Int) {
        _name = name
        _pokedexid = pokedexid
    }
    
}