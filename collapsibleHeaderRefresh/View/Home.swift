//
//  Home.swift
//  collapsibleHeaderRefresh
//
//  Created by EdgardVS on 15/12/22.
//

import SwiftUI

struct Home: View {
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            
            //top nav bar...
            ZStack{
                Image("Pic")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: getScreenBounds()
                        .width, height: 300, alignment: .bottom)
                    .clipShape(
                        CustomCorner(corners: [.bottomLeft], radius: getCornerRadius())
                    )
                //hidding image
                    .opacity(1 + getProgress())
                
                CustomCorner(corners: [.bottomLeft], radius: getCornerRadius())
                    .fill(.ultraThinMaterial)
                
                let progress = -getProgress() < 0.4 ? getProgress() : -0.4
                
                VStack(alignment: .leading) {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    //scaling down image.....
                        .scaleEffect(1 + progress * 1.3, anchor: .bottomLeading)
                    Text("iUlima")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .scaleEffect(1 + progress, anchor: .topTrailing)
                        .offset(x: progress * -70 ,y: progress * 100)
                }
                .padding(15)
                .padding(.bottom,30)
                //stoping view at bottom
                //max progress = 0.4
                //0.4 * 200 = 80
                //topbar height = 70
                // 10 = padding...
                .offset(y: progress * -200)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
              
            }.frame(height: 320)
            //moving up with the offset
                .offset(y: getOffset())
                .zIndex(1)
            
            ScrollRefreshable(title: "Pull to Refresh", tintColor: .primary) {
                
                VStack(spacing: 15) {
                    ForEach(1...4, id: \.self) {index in
                        Image("post\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getScreenBounds().width - 30, height: 250)
                            .cornerRadius(15)
                    }
                }.padding()
                    .padding(.top, 400)
                    //.offset(y: 350)
                // eliminating top Edge..
                    .padding(.top, -getSafeArea().top)
                    .modifier(OffsetModifier(offset: $offset))
                
            } onRefresh: {
                //simply wait for two sec
                await Task.sleep(2_000_000_000)
            }

        }.ignoresSafeArea(.container, edges: .top)
    }
    
    func getOffset()->CGFloat{
        
        let checkSize = -offset < (280 - getSafeArea().top) ? offset : -(280 - getSafeArea().top)
        
        return offset < 0 ? checkSize : 0
    }
    
    func getProgress()->CGFloat{
        let topheight = (280 - getSafeArea().top)
        let progress = getOffset() / topheight
        
        return progress
    }
    
    func getCornerRadius()-> CGFloat{
        let radius = getProgress() * 45
        
        //reducing radius of the corner when scrolling
        return 45 + radius
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().preferredColorScheme(.dark)
    }
}



extension View{
    func getScreenBounds()->CGRect{
        return UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets{
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let screen = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else {
            return null
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return null
        }
        
        return safeArea
    }
}
