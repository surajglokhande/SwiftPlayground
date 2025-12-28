//: [Previous](@previous)
/*:
 ### Common pitfalls (and how to avoid them)
 ❌ Caching full-size images in cells
 ✅ Downsample to the view’s display size using Image I/O thumbnails. [developer.apple.com], [developer.apple.com]
 
 ❌ No prefetching for long lists
 ✅ Use UICollectionViewDataSourcePrefetching to warm cache ahead of scroll. [developer.apple.com], [developer.apple.com]
 
 ❌ Recreating URLSession / URLCache repeatedly
 ✅ Keep a shared session / shared cache. URLCache is designed for response caching and supports memory/disk capacities. [developer.apple.com], [developer.apple.com]
 
 ❌ Unbounded memory cache
 ✅ Use countLimit / totalCostLimit on NSCache. [developer.apple.com], [developer.apple.com]
 
 ### Quick decision: what do you need?
 **If images are from API (URLs)**
 ✅ Use:
 
 - URLCache (network bytes) + NSCache (decoded UIImage)
 - Downsampling
 - Prefetching
 
 **If images are from Photos library**
 ✅ Use:
 
 - PHCachingImageManager + preheating
 
 
 ### ✅ TTL in the context of Image Caching (iOS)
 When you cache an image (or its downloaded bytes), you usually want to avoid re-downloading/re-decoding it every time. But you also don’t want to keep serving an old image forever.
 So you define a TTL like:
 
 - TTL = 5 minutes → for the next 5 minutes, use the cached image
 - After 5 minutes → treat it as expired and fetch a newer version
 
 ### 🧠 Why TTL is useful
 TTL helps you balance:
 
 - Performance (fewer downloads → faster UI)
 - Freshness (don’t show outdated images forever)
 - Data usage (avoid unnecessary network calls)
 
 ### 🧩 TTL vs “Cache size limit”
 They solve different problems:
 
 - Cache size limit (like NSCache.totalCostLimit) controls memory usage
 - TTL controls time-based validity / freshness
 
 You can have a cache that is small but still needs TTL, and vice versa.
 
 ### 🌐 TTL in HTTP caching (server-driven)
 On the web/network side, TTL typically comes from HTTP response headers like:
 
 - Cache-Control: max-age=3600 → TTL = 3600 seconds
 - Expires: <date> → expire at a specific time
 
 If your server sets these properly and you use URLCache, the system can cache automatically based on these policies.
 
 ### ⚖️ TTL vs ETag (important difference)
 **TTL (time-based)**
 
 - “Use cached image for 10 minutes, no questions asked.”
 
 **ETag (validation-based)**
 
 - “Ask server if the image changed. If not changed → server returns 304 Not Modified, saving bandwidth.”
 
 **Best practice for remote images:**
 
 - If server supports ETag + Cache-Control, rely on HTTP caching (URLCache)
 - Use app TTL mainly when headers are missing or you want extra control
 */


import Foundation
import UIKit
import ImageIO
import PlaygroundSupport

func downsample(data: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    let options: [CFString: Any] = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,  // force thumbnail [7](https://developer.apple.com/documentation/imageio/kcgimagesourcecreatethumbnailfromimagealways)
        kCGImageSourceThumbnailMaxPixelSize: Int(maxDimensionInPixels),
        kCGImageSourceCreateThumbnailWithTransform: true     // respect orientation [8](https://developer.apple.com/documentation/imageio/kcgimagesourcecreatethumbnailwithtransform)
    ]
    
    guard let source = CGImageSourceCreateWithData(data as CFData, nil),
          let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
        return nil
    }
    
    return UIImage(cgImage: cgImage)
}

final class MemoryImageCache {
    static let shared = MemoryImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 300                  // tune as per app
        cache.totalCostLimit = 150 * 1024 * 1024 // ~150 MB (tune)
    }
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func insert(_ image: UIImage, forKey key: String) {
        // Cost = approximate memory usage
        let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 1
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}


final class NetworkSessionFactory {
    static func makeSession() -> URLSession {
        let memoryCapacity = 50 * 1024 * 1024   // 50 MB
        let diskCapacity   = 300 * 1024 * 1024  // 300 MB
        
        let cache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            directory: nil
        )
        
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.requestCachePolicy = .useProtocolCachePolicy
        // .useProtocolCachePolicy uses server cache headers by default [1](https://developer.apple.com/documentation/foundation/accessing-cached-data)
        
        return URLSession(configuration: config)
    }
}



final class RemoteImageLoader {
    static let shared = RemoteImageLoader()
    
    private let session: URLSession = NetworkSessionFactory.makeSession()
    
    // Keep track of running tasks (helps cancel + avoid duplicates)
    private var tasks: [URL: URLSessionDataTask] = [:]
    private let lock = NSLock()
    
    func load(url: URL, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let key = cacheKey(url: url, size: targetSize)
        
        // 1) Memory cache (decoded image)
        if let cached = MemoryImageCache.shared.image(forKey: key) {
            completion(cached)
            return
        }
        
        // 2) Download (URLCache handles response caching automatically)
        lock.lock()
        if tasks[url] != nil { lock.unlock(); return }
        let task = session.dataTask(with: url) { data, response, error in
            self.lock.lock()
            self.tasks[url] = nil
            self.lock.unlock()
            
            guard let data else { DispatchQueue.main.async { completion(nil) }; return }
            
            // 3) Downsample to display size
            let image = downsample(data: data, to: targetSize)
            
            // 4) Store decoded image in memory cache
            if let image {
                MemoryImageCache.shared.insert(image, forKey: key)
            }
            
            DispatchQueue.main.async { completion(image) }
        }
        tasks[url] = task
        lock.unlock()
        
        task.resume()
    }
    
    func cancel(url: URL) {
        lock.lock()
        tasks[url]?.cancel()
        tasks[url] = nil
        lock.unlock()
    }
    
    private func cacheKey(url: URL, size: CGSize) -> String {
        "\(url.absoluteString)|w:\(Int(size.width))|h:\(Int(size.height))"
    }
}

final class FeedViewController: UIViewController, UICollectionViewDataSourcePrefetching {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageURLs: [URL] = []
    let cellSize = CGSize(width: 120, height: 120)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let url = imageURLs[indexPath.item]
            RemoteImageLoader.shared.load(url: url, targetSize: cellSize) { _ in }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let url = imageURLs[indexPath.item]
            RemoteImageLoader.shared.cancel(url: url)
        }
    }
}

PlaygroundPage.current.liveView = FeedViewController()
//: [Next](@next)
