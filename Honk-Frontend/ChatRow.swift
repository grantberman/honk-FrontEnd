//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import CoreData
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


struct ChatRow: View {
    var chatMessage : Message;
    //    var author : User;
    @EnvironmentObject var user: UserLocal
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //@Binding var hasReacted: Bool
   // @State var hiddenTrigger = false
    
    
    var hasLikes: Bool = false
    var isMe : Bool  = false
    
    
    //        return chatMessage.authorDef.usernameDef == self.user.username
    //
    //    }
    
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
//        var likeNumber = getReactions(self.chatMessage.uuidDef, self.user.auth.token)
//        print("message is")
//        print(likeNumber)
        
        return Group {
            if self.chatMessage.author?.usernameDef != self.user.username{
                //            if isMe{
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
                                
                                //comment this out to
                                //                                 .background(chatMessage.color)
                                .cornerRadius(10)
                                
                                
                                
                                //                                    .frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
                                //                                    .padding(10)
                                .contextMenu{
                                    Button(action: self.reactToMessage){
                                        HStack{
                                            Text("Like")
                                            Image("thumbs-up")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }.frame(alignment: .leading)
                                    
                                    
                                    
                                    //.frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
//                                    .padding(10)
                                    .contextMenu{
                                    Button(action: { self.reactToMessage("Like", self.user.auth.token, self.chatMessage.uuidDef, self.chatMessage.inChat!.uuidDef)
                                        //self.hasReacted.toggle() // a state change to force rerender
                                        //self.hiddenTrigger = self.hasReacted
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
                                        Button(action: self.createSubChat){
                                            
                                            HStack{
                                                Text("Create sub chat")
                                                Image("sub-group")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                }
                                //updateReact()
                                Group{
                                    if(self.chatMessage.reactions?.count ?? 0 > 0){
                                   
                                    Image("thumbs-up")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        
                                    Text(String(describing: self.chatMessage.reactions!.count))
                                        .frame(alignment: .bottomLeading)
                                    }
                                }
                                .frame(maxWidth: 30, maxHeight: 30, alignment: .leading)
                            }
                            Spacer()
                        }
                    }
                } else {
                    VStack{
                        
                        HStack {
                            Group {
                                Spacer()
                                    //updateReact()
                                    Group{
                                        if(self.chatMessage.reactions?.count ?? 0 > 0){
                                        Text(String(describing: self.chatMessage.reactions!.count))
                                            .frame(alignment: .bottomTrailing)
                                            
                                        Image("thumbs-up")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fit)
                                            }
                                    }
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
                                        //self.hasReacted.toggle() // a state change to force rerender
                                        //self.hiddenTrigger = self.hasReacted
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
                                        Button(action: self.createSubChat){
                                                HStack{
                                                Text("Create sub chat")
                                                Image("sub-group")
                                                .renderingMode(.original)
                                                .resizable()
                                                .scaledToFit()
                                                }
                                        }
                                }
                                Text(self.chatMessage.avatar)
                                    .padding(.trailing, 5)
                                
                            }
                        }.frame(alignment: .bottomTrailing)
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
    
    public func reactToMessage(_ reaction_type: String,  _ auth: String, _ message_uuid: String, _ chat_uuid: String){
            //  the API call to like
        
            
            guard let url = URL(string: "https://honk-api.herokuapp.com/api/messages/\(message_uuid)/reactions")
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
                            print(jsonString)
                            let jsonData = jsonString!.data(using: .utf8)
                            
                            
                            
                            let decoder = JSONDecoder()
                            decoder.userInfo[CodingUserInfoKey.context!] = context
                            let message = try decoder.decode(Message.self, from: jsonData!)
                            print("first message is")
                            print(message)
                            
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
                            fetchRequest.predicate = NSPredicate(format: "uuid == %@", chat_uuid)
                
                
                            let fetchedChat = try context.fetch(fetchRequest) as! [Chat]
                            let objectUpdate = fetchedChat[0]
                            let messages = objectUpdate.messages
                            let updatedMessages = messages?.adding(message)
                            objectUpdate.messages = updatedMessages as NSSet?
                            try context.save()
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
        
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/messages/\(message_uuid)") else {
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








