//
//  PokeDetail.swift
//  ProjectMVVM
//
//  Created by MAC46 on 30/04/22.
//

import Foundation

struct PokeDetail: Codable {
    
    let name: String
    let weight: Int
    //aqui esta la imagen del pokemon
    let sprites: Sprites
    let types: [Types]
}

struct Sprites: Codable {
    let other: Other
}

struct Other: Codable {
    let officialArtwork: Official
    
    // vamos a crear un alias para el nombre pq en la api se llama official-artwork y el - no esta permitido
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}
//modelo para el nombre, peso y la foto
struct Official: Codable {
    let front_default: String
}

struct Types: Codable {
    let slot: Int
    let type: TypePoke
}

struct TypePoke: Codable {
    let name: String
    let url: String
}
