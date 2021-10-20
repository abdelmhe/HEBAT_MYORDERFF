
import SwiftUI
import CoreData

struct ContentView: View {
    @State var page = 0
    var body: some View {
        VStack{
            VStack {
                if(page == 0 ){
                NewOrder()
                }
                else{
                    orderList()
                }
            }
            HStack{
                Spacer()
                Button(action:{
                    page = 0
                }){
                    VStack{
                        Image(systemName: "plus.bubble")
                        Text("New Order")
                    }
                }
                Spacer()
                Button(action:{
                    page = 1
                }){
                    VStack{
                        Image(systemName: "list.bullet.rectangle")
                        Text("My Orders")
                    }
                }
                Spacer()
            }
            
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
