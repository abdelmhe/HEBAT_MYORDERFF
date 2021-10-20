

import Foundation

//order class
struct order : Identifiable{
    
    let id: Int
    var orderAmount: Int
    var coffeeType: String
    var coffeeSize: String
    
    //constructor
    init(){
        
        self.id = 0
        self.orderAmount = 0
        self.coffeeType = ""
        self.coffeeSize = ""
    }
}

