
struct AppUtil
{
    static var contadorUpdateCollectionview : Int = 0
    
    static var sizeTituloSubcategoria : CGFloat = 0.0
    static var sizeOpcionMenu : CGFloat = 0.0
    static var altoCeldaOpcionMenu : CGFloat = 0.0
    static var data = Array<Producto>()
    static var listaSubcategorias = Array<Subcategoria>()
    static var listaAnuncios = Array<Anuncio>()
    static var listaCarro = Array<ItemCarrito>()
    static let cache: NSCache = {
        let cache = NSCache()
        cache.name = "MyImageCache"
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
    
    static var audioPlayer : AVAudioPlayer = {
        
        var audioPlayer =  try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sonido_click", ofType: "wav")!))
        
        return audioPlayer
    }()
    
    
    
}