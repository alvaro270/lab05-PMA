//
//  PokeDetailViewController.swift
//  ProjectMVVM
//
//  Created by MAC46 on 29/04/22.
//

import UIKit

class PokeDetailViewController: UIViewController {

    // vamos a declarar que variable necesito
    var url: String = ""
    var pokemon: PokeDetail? = nil
        
    let pokeViewModel: PokeViewModel = PokeViewModel()

    //enlaces con elementos de la pantalla que haran accion
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNamePokemon: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await setUpView()
        }
    }
    
    func setUpView() async {
            await pokeViewModel.getPokeDetail(url: url)
            pokemon = pokeViewModel.pokemon
            setUpPokeData()
    }
        
    func setUpPokeData() {
        //cambiar color de fondo porcada tipo de pokemon
            view.backgroundColor = PokeTypes.types[(pokemon?.types[0].type.name)!]
            lblNamePokemon.text = pokemon?.name.capitalized
            lblType.text = pokemon?.types[0].type.name.capitalized ?? ""
            imagePokemon.image = HelperImage.setImageFromUrl(url: (pokemon?.sprites.other.officialArtwork.front_default)!)
    }
}
