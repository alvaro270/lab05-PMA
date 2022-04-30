import UIKit

class ViewController: UIViewController {
    
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet weak var tableView: UITableView!
        
        let pokeViewModel: PokeViewModel = PokeViewModel()
        
        var filterData: [Result] = []
    //esta variable se va allenar cuando le damos click en la celda
        var urlToDetail: String? = nil
        
        override func viewDidLoad() {
            super.viewDidLoad()
            Task {
                await setUpData()
            }
            setUpView()
        }
        
        func setUpData() async {
            await pokeViewModel.getDataFromAPI()
            filterData = pokeViewModel.pokemons
            tableView.reloadData()
        }
        
        func setUpView() {
            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self
            //es para que el texto back no se muestre
            navigationItem.backButtonTitle = ""
        }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // Retorna el numero de celdas que tendra la tabla
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filterData.count
        }
        
        // Setear los valores en la tabla
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            // La forma en la cual podemos saber la posicion actual de nuestra celda es con indexPath.row
            let pokemon = filterData[indexPath.row]
            cell.textLabel?.text = pokemon.name.capitalized
            cell.imageView?.image = HelperImage.setImage(id: HelperString.getIdFromUrl(url: pokemon.url))
            return cell
        }
        //didSelectRowAt => sirve para poder capturar la posicion de la celda
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //la variable urlToDetail => se va a rrellenar cuando le damos click en la celda
            urlToDetail = filterData[indexPath.row].url
            performSegue(withIdentifier: "detail", sender: self)
        }
        //prepare es la funcion que se encarga de poder esuchar cuando estamos cambiando de pantalla
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detail" {
                
                let pokeDetailView = segue.destination as! PokeDetailViewController
                pokeDetailView.url = urlToDetail!
            }
        }
}

// Extension para usar SearchBar :D
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // searchText: Es el texto que estamos escribiendo es decir es como un onChange cada vez
            // que escribimos esta funcion se ejecuta
            filterData = searchText.isEmpty
            ? pokeViewModel.pokemons
            : pokeViewModel.pokemons.filter({ (pokemon: Result) -> Bool in
                return pokemon.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            tableView.reloadData()
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
    }
}
