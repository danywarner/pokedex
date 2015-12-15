//
//  Pokemon.swift
//  pokedex
//
//  Created by Daniel Warner on 12/11/15.
//  Copyright © 2015 Daniel Warner. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexid: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var nextEvolutionText: String {
        get {
            if _nextEvolutionText == nil {
                _nextEvolutionText = ""
            }
            return _nextEvolutionText
        }
    }
    
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
        return _nextEvolutionId
        }
    }
    
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
        return _nextEvolutionLvl
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
        return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
        return _type
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
        return _defense
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
        return _height
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
        return _weight
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
        return _attack
        }
    }
    
    var name: String {
        return _name
    }
    
    var pokedexid: Int {
        return _pokedexid
    }
    
    init(name: String, pokedexid: Int) {
        _name = name
        _pokedexid = pokedexid
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexid)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
    
            let url = NSURL(string: _pokemonUrl)!
            Alamofire.request(.GET, url).responseJSON { response in
                let result = response.result
                print(result.value)
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? String {
                        self._weight = weight
                    }
                
                    if let height = dict["height"] as? String {
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                
                    if let defense = dict["defense"] as? Int {
                        self._defense = "\(defense)"
                    }
                
                    if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                        
                        if let name = types[0]["name"] {
                            self._type = name.capitalizedString
                        }
                        
                        if types.count > 1 {
                            
                            for var x = 1; x < types.count; x++ {
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                        if let url = descArr[0]["resource_uri"] {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                                let desResult = response.result
                                if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                        print(self._description)
                                    }
                                }
                                
                                completed()
                            }
                        }
                    } else {
                        self._description = ""
                    }
                    
                    if let evolutions =  dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                        if let to = evolutions[0]["to"] as? String {
                            
                            //Can't support mega pokemons but the api still has mega data
                            if to.rangeOfString("mega") == nil {
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    self._nextEvolutionId = num
                                    self._nextEvolutionText = to
                                    
                                    if let lvl = evolutions[0]["level"] as? Int {
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                    
                                    print(self._nextEvolutionText)
                                    print(self._nextEvolutionId)
                                    print(self._nextEvolutionLvl)
                                }
                            }
                        }
                    }
                    
                
                }
                

            
        }

    }
    
    
}