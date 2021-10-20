

import SwiftUI

//view to create a new order
struct NewOrder: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //getting coredata data
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Order>
    
    //initiating new order
    @State var newOrder = order()
    
    //Coffee Types
    let coffeeTypes = ["Americano","Latte","Espresso","Cafe Au Leit", "Mocha","Frappe"]
    
    //Coffee Sizes
    let sizes = ["Small","Medium","Large"]
    
    //function for getting id (highest id + 1)
    func createID()->Int{
        var id = 0
        if(!items.isEmpty){
            id = Int(items[0].id)
            for i in items{
                if(id < i.id){
                    id = Int(i.id)
                }
            }
        }
        return id+1
    }
    //saving order
    func saveOrder(){
        let newItem = Order(context: viewContext)
        newItem.id = Int16(createID())
        newItem.size = newOrder.coffeeSize
        newItem.coffee_type = newOrder.coffeeType
        newItem.quantity = Int16(newOrder.orderAmount)
        newItem.date = Date()
        
        do{
            try viewContext.save()
        }
        catch{
            print(error.localizedDescription)
        }
        newOrder = order()
    }
    
    //main view
    var body: some View {
        VStack{
            Text("New Order").font(.largeTitle).fontWeight(.bold)
            ScrollView{
                VStack(alignment: .leading){
                    getCoffeeType
                    getCoffeeSize
                    getCoffeeQuantity
                }.padding([.horizontal, .bottom])
                Button(action:{
                    withAnimation{
                        saveOrder()
                    }
                }){
                    HStack{
                        Spacer()
                        Text("Add Order").foregroundColor(.white).font(.title3)
                        Spacer()
                    }.padding().background(Color.blue).clipped().cornerRadius(5).shadow(radius: 5).padding(.horizontal)
                }
            }
            Spacer()
        }
    }
    
    //view to get coffee type
    var getCoffeeType : some View{
        VStack(alignment: .leading){
            Text("Coffee Type").font(.title3).fontWeight(.bold)
            ScrollView(.horizontal){
                //grid that shows all items in coffee types
                LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]){
                    ForEach(coffeeTypes, id: \.self){ types in
                        Button(action:{
                            withAnimation{
                                //when button is pressed set coffee types to according button
                                newOrder.coffeeType = types
                            }
                        }){
                            VStack{
                                Text(types).fontWeight(.bold).padding()
                            }.frame(width: UIScreen.main.bounds.width * 0.4).background((newOrder.coffeeType == types) ? Color.blue : Color.white).clipped().cornerRadius(10).shadow(radius: 5).foregroundColor(.black).padding(.horizontal, 5)
                        }
                    }
                }.padding(.horizontal)
            }.frame(height: UIScreen.main.bounds.width * 0.45)
        }
    }
    
    var getCoffeeSize : some View{
        VStack(alignment: .leading){
            Text("Size").font(.title3).fontWeight(.bold)
            HStack{
                Spacer()
                //show all sizes of coffee
                ForEach(sizes, id: \.self){ size in
                    Button(action:{
                        withAnimation{
                            //when button is pressed set coffee size to according button
                            newOrder.coffeeSize = size
                        }
                    }){
                        Text(size).font(.title3).fontWeight(.semibold).padding().foregroundColor(.black).background((newOrder.coffeeSize == size) ? Color.blue: Color.white).clipped().cornerRadius(10).shadow(radius: 4).padding(5)
                    }
                }
                Spacer()
            }
        }
    }
    
    var getCoffeeQuantity : some View{
        VStack(alignment: .leading){
            Text("Quantity").font(.title3).fontWeight(.bold)
            HStack{
                Spacer()
                //button to subtract quantity
                Button(action:{
                    if(newOrder.orderAmount > 0){
                        newOrder.orderAmount = newOrder.orderAmount - 1
                    }
                }){
                    Image(systemName: "minus").font(.largeTitle).padding().foregroundColor(.black)
                }
                //show order amount
                Text("\(newOrder.orderAmount)").font(.largeTitle).fontWeight(.bold)
                //button to add quantity
                Button(action:{
                    newOrder.orderAmount = newOrder.orderAmount + 1
                }){
                    Image(systemName: "plus").font(.largeTitle).padding().foregroundColor(.black)
                }
                Spacer()
            }
        }
    }
}

struct NewOrder_Previews: PreviewProvider {
    static var previews: some View {
        NewOrder()
    }
}
