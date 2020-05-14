//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//


import SwiftUI
import CoreData
import Combine



struct ChatRow: View {
    

    @EnvironmentObject var appState : AppState
    @EnvironmentObject var user: UserLocal
    @State  var refreshing = false
    @State var makeChatIsPresented = false
    
    var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let objectWillChange = ObservableObjectPublisher()
    var chatMessage : Message {
        willSet{
            objectWillChange.send()
        }
    }
    
    var hasLikes: Bool = false
    var isMe : Bool  = false
    
    
    var body: some View{
        

        return Group {
            if self.chatMessage.author?.usernameDef != self.user.username{

                VStack{
                    HStack {
                        Group {
                            Text(self.chatMessage.avatar)
                                .padding(.leading, 5)
                                .frame(alignment: .leading)
                            Text(self.chatMessage.contentDef)
                                
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.blue)

                                .cornerRadius(10)

                                .contextMenu{
                                    Button(action: { self.reactToMessage("Like", self.user.auth.token, self.chatMessage.uuidDef, self.chatMessage.inChat!.uuidDef)
                                        
                                    }){
                                        HStack{
                                            Text("Like")
                                            Image("thumbs-up")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }.frame(alignment: .leading)
                                    Button(action: {
                                        self.makeChatIsPresented.toggle()
                                        self.showUsernames()
                                        print("here")
                                    }){
                                        HStack{
                                            Text("Create sub chat")
                                            Image("sub-group")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }
                                            .sheet(isPresented: self.$makeChatIsPresented) {
                                                return CreateChatView(initList: self.chatMessage.reactionUsernames, communityUUID: (self.chatMessage.inChat?.inCommunity?.uuid)!, isPresented: self.$makeChatIsPresented)
                                            .environmentObject(self.user).environmentObject(self.appState)
                                    }
                            }
                                    Group{
                                        if(self.chatMessage.reactions?.count ?? 0 > 0){
                                            Text(self.refreshing ? "" : "")
                                            Image("thumbs-up")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                                .aspectRatio(contentMode: .fit)
                                            
                                            Text(String(describing: self.chatMessage.reactions!.count))
                                                .frame(alignment: .bottomLeading)
                                        }
                                    }.onReceive(self.didSave) { _ in
                                        self.refreshing.toggle()
                                        
                                    }
                                    .frame(maxWidth: 30, maxHeight: 30, alignment: .leading)
                            }
                            Spacer()
                        
                    }
                }
            } else {

                    
                    HStack {
                        Group {
                            Spacer()

                            Group{
                                if(self.chatMessage.reactions?.count ?? 0 > 0){
//                                    Text(self.refreshing ? "" : "")
                                    Text(String(describing: self.chatMessage.reactions!.count))
                                        .frame(alignment: .bottomTrailing)
                                    
                                    Image("thumbs-up")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
//                            .onReceive(self.didSave) { _ in
//                                self.refreshing.toggle()
//
//                            }
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .trailing)
                            Text(self.chatMessage.contentDef)
                                //                                    .bold()
                                //                                    .foregroundColor(.white)
                                //                                    .padding(10)
                                //                                    .background(Color.green)
                                //                                    .cornerRadius(10)
                                
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                                .contextMenu{
                                    Button(action: { self.reactToMessage("Like", self.user.auth.token, self.chatMessage.uuidDef, self.chatMessage.inChat!.uuidDef)
                                    }){
                                        EmptyView()
                                        HStack{
                                            Text("Like")
                                            Image("thumbs-up")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }.frame(alignment: .leading)
                                    Button(action: {
                                        self.makeChatIsPresented.toggle()

                                    }){
                                        HStack{
                                            Text("Create sub chat")
                                            Image("sub-group")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }
                                            .sheet(isPresented: self.$makeChatIsPresented) {
                                                return CreateChatView(initList: self.chatMessage.reactionUsernames, communityUUID: (self.chatMessage.inChat?.inCommunity?.uuid)!, isPresented: self.$makeChatIsPresented)
                                            .environmentObject(self.user).environmentObject(self.appState)
                                    }
                            }
                            Text(self.chatMessage.avatar)
                                .padding(.trailing, 5)
                            
                        }
                        Text(self.refreshing ? "" : "")
                    }.frame(alignment: .bottomTrailing)
                .onReceive(self.didSave) { _ in
                    self.refreshing.toggle()
                    
                }
                
            }
        }
    }
    
    public func updateReact() -> some View{
        
        //self.hasReacted = !self.hasReacted
        return Group{
            if (self.chatMessage.reactions?.count ?? 0 > 0){
                Text(String(describing: self.chatMessage.reactions!.count))
                Image("thumbs-up")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    public func showUsernames () {
        
        for username in self.chatMessage.reactionUsernames {
            print(username)
        }
    }

    
    
    
    
    public func reactToMessage(_ reaction_type: String,  _ auth: String, _ message_uuid: String, _ chat_uuid: String){
        //  the API call to like
        
        
        guard let url = URL(string: "https://honk-staging.herokuapp.com/api/messages/\(message_uuid)/reactions")
            else {
                print("Invalid URL")
                return
        }
        
        let body: [String: Any] = ["reaction_type": reaction_type]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization") //after
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            guard let data = data else {
                print ("no data returned")
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let jsonString = String(data: data, encoding: .utf8)
//                    print(jsonString)
                    let jsonData = jsonString!.data(using: .utf8)
                    
                    
                    
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let message = try decoder.decode(Message.self, from: jsonData!)
                    print(message.reactions)
                    
                    
//                    print("first message is")
//                    print(message)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
                    fetchRequest.predicate = NSPredicate(format: "uuid == %@", chat_uuid)
                    
//                   print(message.reactionsDef[1].reactor)
                    let fetchedChat = try context.fetch(fetchRequest) as! [Chat]
                    let objectUpdate = fetchedChat[0]
                    let messages = objectUpdate.messages
                    let updatedMessages = messages?.adding(message)
                    objectUpdate.messages = updatedMessages as NSSet?
                    try context.save()
                    
                    self.didSave
                    print("message is")
                    print(message)
                    
                    
                    do {
                        try context.save()
                        print("save")
                    } catch {
                        print("could not save")
                    }
                } catch {
                    print("could not decode" )
                }
                
            }
            
            return
            
        }.resume()
        
        
    }
    func createSubChat(){
        // in here will be API call to create new subgroup
    }
    func getReactions(_ message_uuid: String, _ auth: String){
        // this is the API call to get the likes to display them
        
        guard let url = URL(string: "http://honk-staging.herokuapp.com/api/messages/\(message_uuid)") else {
            print("Invalid URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization") //after
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            if let data = data {
                if (try? JSONDecoder().decode(Message.self, from: data)) != nil {
                    
                    //                    let group = DispatchGroup()
                    do {
                        
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        
                        let jsonString = String(data: data, encoding: .utf8)
                        
                        let jsonData = jsonString!.data(using: .utf8)
                        print(jsonData)
                        let decoder = JSONDecoder()
                        decoder.userInfo[CodingUserInfoKey.context!] = context
                        let message = try decoder.decode(Message.self, from: jsonData!)
                        print("message is \(message)")
                        
                    } catch {
                        print( "could not get response" )
                    }
                    
                    
                    return
                }
                
            }
            
            
        }.resume()
    }
}



//
//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chatMessage: ChatMessage(message: "This is a long message test Im not sure what will happen with it and we need to see what happens", avatar: "B", color: .blue)).previewDevice("iPhone 8")
//    }
//}
//








