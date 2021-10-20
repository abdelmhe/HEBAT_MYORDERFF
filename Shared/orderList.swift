

import SwiftUI

//View for a list of orders
struct orderList: View {
    
    //getting data from coredata
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Order>
    
    //date formatter Date -> String
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //function for deleting coredata items
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        VStack{
            List{
                Text("Orders").font(.largeTitle).fontWeight(.bold)
                
                //show all orders
                ForEach(items, id: \.self){ order in
                    VStack{
                        HStack{
                            VStack(alignment: .leading){
                                Text("ID: \(order.id)").font(.title3).fontWeight(.semibold)
                                Text(order.coffee_type ?? "unknown").font(.title3).fontWeight(.semibold)
                                Text("Size: " + (order.size ?? "")).font(.title3).fontWeight(.semibold)
                            }
                            Spacer()
                            VStack{
                                Text("x \(order.quantity)").font(.largeTitle).fontWeight(.semibold)
                            }
                        }
                        Text("\(itemFormatter.string(from: order.date ?? Date()))").fontWeight(.semibold)
                    }
                }
                //on slide delete button appears
                .onDelete(perform: deleteItems)
            }
        }
    }
}



struct orderList_Previews: PreviewProvider {
    static var previews: some View {
        orderList()
    }
}
