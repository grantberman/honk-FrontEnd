//
//  CommunityView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct CommunityView: View {
    //@EnvironmentObject var user : User
    //@EnvironmentObject var appState: AppState
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommunityN.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityN>// a list of all of your communities
    
    
    @ViewBuilder
    var body: some View {
        
        NavigationView {
            
            VStack{
            List{
                ForEach(communities, id: \.name ) { communityItem in
                    
                    VStack{
                         Group{
                            // this should hopefully work if coredata is updated
                            // where 
                            Text(communityItem.communityName)
                            
                         }.frame(width: .infinity, height: 100, alignment: .leading)
                        .padding(50)
                    }
                }
            }
            Group{
                Button(action: {
                    //change this to other function that takes user
                    //to creating community page
                }){
                    Text("Create new community")
                    .font(.headline)
                    .foregroundColor(.white)
                    }
                    //.frame(width: 300, height: 50)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
                
            }
            
        }.navigationBarTitle("Your Communities")
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}



