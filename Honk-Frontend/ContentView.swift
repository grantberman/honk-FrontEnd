//
//  ContentView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI



struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
    var isMe: Bool = false
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

struct ChatRow: View {
    var chatMessage: ChatMessage
   
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
        
        
        return Group {
            if !chatMessage.isMe{
                Group{ // originally had this in the Vstack although it didn't orient correctly
                    Text(dateString.string(from:today))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                VStack{
                    HStack {
                        Group {
                             Text(chatMessage.avatar)
                             Text(chatMessage.message)
                                 .bold()
                                 .foregroundColor(.white)
                                 .padding(10)
                                 .background(chatMessage.color)
                                 .cornerRadius(10)
                                 .frame(minWidth: 10, maxWidth: 250,  alignment: .leading)
                        }
                    }
                }
            } else {
                VStack{
                    Group{
                        Spacer()
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(10)
                    }
                    HStack {
                        Group {
                            Spacer()
                            Text(chatMessage.message)
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(chatMessage.color)
                                .cornerRadius(10)
                            Text(chatMessage.avatar)
                            
                        }
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController : ChatController
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    
    var body: some View {
        VStack {
            NavigationView {
                CustomScrollView(reversed: true) {
                    ForEach(self.objects, id: \.self) { object in
                        VStack {
                            Text("Row \(object)").padding().background(Color.yellow)
                            NavigationLink(destination: Text("Details for \(object)")) {
                            Image(systemName: "chevron.right.circle")
                            }
                            Divider()
                            }.overlay(RoundedRectangle(cornerRadius: 8).stroke())
                        }
                    }
                    .navigationBarTitle("Reverse", displayMode: .inline)
                List {
                    ForEach (chatController.messages, id: \.self) { msg in
                        ChatRow(chatMessage: msg)
                        .rotationEffect(.radians(.pi))
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                    }
                }.onAppear {
                    UITableView.appearance().separatorStyle = .none     //gets rid of lines between messages
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
            }
            HStack{
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30)).background(GeometryGetter(rect: $kGuardian.rects[0]))
                Button(action: sendMessage) {
                    Text("Send")
                    }
                }.frame(minHeight:CGFloat(50)).padding()
            
        }.offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        .onAppear { self.kGuardian.addObserver() }
        .onDisappear { self.kGuardian.removeObserver() }
    }
    
    struct CustomScrollView<Content>: View where Content: View {
        var axes: Axis.Set = .vertical
        var reversed: Bool = false
        var scrollToEnd: Bool = false
        var content: () -> Content

        @State private var contentHeight: CGFloat = .zero
        @State private var contentOffset: CGFloat = .zero
        @State private var scrollOffset: CGFloat = .zero

        var body: some View {
            GeometryReader { geometry in
                if self.axes == .vertical {
                    self.vertical(geometry: geometry)
                } else {
                    // implement same for horizontal orientation
                }
            }
            .clipped()
        }

        private func vertical(geometry: GeometryProxy) -> some View {
            VStack {
                content()
            }
            .modifier(ViewHeightKey())
            .onPreferenceChange(ViewHeightKey.self) {
                self.updateHeight(with: $0, outerHeight: geometry.size.height)
            }
            .frame(height: geometry.size.height, alignment: (reversed ? .bottom : .top))
            .offset(y: contentOffset + scrollOffset)
            .animation(.easeInOut)
            .background(Color.white)
            .gesture(DragGesture()
                .onChanged { self.onDragChanged($0) }
                .onEnded { self.onDragEnded($0, outerHeight: geometry.size.height) }
            )
        }

        private func onDragChanged(_ value: DragGesture.Value) {
            self.scrollOffset = value.location.y - value.startLocation.y
        }

        private func onDragEnded(_ value: DragGesture.Value, outerHeight: CGFloat) {
            let scrollOffset = value.predictedEndLocation.y - value.startLocation.y

            self.updateOffset(with: scrollOffset, outerHeight: outerHeight)
            self.scrollOffset = 0
        }

        private func updateHeight(with height: CGFloat, outerHeight: CGFloat) {
            let delta = self.contentHeight - height
            self.contentHeight = height
            if scrollToEnd {
                self.contentOffset = self.reversed ? height - outerHeight - delta : outerHeight - height
            }
            if abs(self.contentOffset) > .zero {
                self.updateOffset(with: delta, outerHeight: outerHeight)
            }
        }

        private func updateOffset(with delta: CGFloat, outerHeight: CGFloat) {
            let topLimit = self.contentHeight - outerHeight

            if topLimit < .zero {
                 self.contentOffset = .zero
            } else {
                var proposedOffset = self.contentOffset + delta
                if (self.reversed ? proposedOffset : -proposedOffset) < .zero {
                    proposedOffset = 0
                } else if (self.reversed ? proposedOffset : -proposedOffset) > topLimit {
                    proposedOffset = (self.reversed ? topLimit : -topLimit)
                }
                self.contentOffset = proposedOffset
            }
        }
    }

    struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }

    extension ViewHeightKey: ViewModifier {
        func body(content: Content) -> some View {
            return content.background(GeometryReader { proxy in
                Color.clear.preference(key: Self.self, value: proxy.size.height)
            })
        }
    }
    
    
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "C", color: .green, isMe: true))
        composedMessage = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}


final class KeyboardGuardian: ObservableObject {
    public var rects: Array<CGRect>
    public var keyboardRect: CGRect = CGRect()

    // keyboardWillShow notification may be posted repeatedly,
    // this flag makes sure we only act once per keyboard appearance
    public var keyboardIsHidden = true

    @Published var slide: CGFloat = 0

    var showField: Int = 0 {
        didSet {
            updateSlide()
        }
    }

    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)

    }

    func addObserver() {
NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
}

func removeObserver() {
 NotificationCenter.default.removeObserver(self)
}

    deinit {
        NotificationCenter.default.removeObserver(self)
    }



    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }

    func updateSlide() {
        if keyboardIsHidden {
            slide = 0
        } else {
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY

            if diff > 0 {
                slide += diff
            } else {
                slide += min(diff, 0)
            }

        }
    }
}
