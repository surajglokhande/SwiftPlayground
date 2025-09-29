//: [Previous](@previous)
import Foundation

class NetworkManager {
    //
}

protocol ViewProtocol {
    func displayAPIResponse(str: String)
}

class ViewController: ViewProtocol {
    
    var interactor: InteractorProtocol?
    var viewModel: String?
    var router: RouterProtocol?
    //var dataStore: DataStoreProtocol?
    
    init() {
        var dataStore = DataStore()
        var interactor = Interactor(dataStore: dataStore)
        interactor.presenter = Presenter()
        interactor.worker = Worker(network: NetworkManager())
        var router = Router()
        var controller = ViewController()
        controller.interactor = interactor
        controller.router = router
        router.viewController = controller
        router.dataStore = dataStore
    }
    
    func ViewDidLoad() {
        interactor?.fetchAPI()
    }
    
    func displayAPIResponse(str: String) {
        viewModel = str
        router?.redirectToSecoundView()
    }
}

protocol InteractorProtocol {
    func fetchAPI()
}

class Interactor: InteractorProtocol {
    
    var worker: Worker?
    var presenter: PresenterProtocol?
    var dataStore: DataStoreProtocol?
    
    init(dataStore: DataStoreProtocol?) {
        self.dataStore = dataStore
    }

    
    func fetchAPI() {
        worker?.getAPIResponse { [weak self] (data) in
            guard let _self = self else {
                return
            }
            _self.presenter?.presentAPIresponse(str: data)
        }
    }
}

protocol PresenterProtocol {
    func presentAPIresponse(str: String)
}

class Presenter: PresenterProtocol {
    
    var viewProtocol: ViewProtocol?
    
    func presentAPIresponse(str: String) {
        viewProtocol?.displayAPIResponse(str: str)
    }
}

protocol WorkerProtocol {
    func getAPIResponse(returnData: String)
}

class Worker {
    
    var network: NetworkManager?
    var worker: WorkerProtocol?
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func getAPIResponse(returnData:(String)->Void) {
        //network.request()
        worker?.getAPIResponse(returnData: "")
    }
}

protocol RouterProtocol {
    func redirectToSecoundView()
    var dataStore: DataStore? { get set }
}

class Router: RouterProtocol {
    var dataStore: DataStore?
    //var dataStore: DataStoreProtocol?
    var viewController: ViewController?
    
    func redirectToSecoundView() {
        //
    }
}

protocol DataStoreProtocol {
    var initialValue: String? { get set }
}

class DataStore: DataStoreProtocol {
    var initialValue: String?
}


var view = ViewController()
view.router?.dataStore?.initialValue = "pass data to next view"

//: [Next](@next)
