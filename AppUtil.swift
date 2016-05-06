
struct AppUtil
{
    
    static var data = Array<Producto>()
    static var listaSubcategorias = Array<Subcategoria>()
    static var listaCarro = Array<ItemCarrito>()
    
    static let imagenCache: NSCache = {
        let cache = NSCache()
        cache.name = "MyImageCache"
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
}