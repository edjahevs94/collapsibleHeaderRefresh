//
//  ScrollRefreshable.swift
//  collapsibleHeaderRefresh
//
//  Created by EdgardVS on 15/12/22.
//

import SwiftUI

struct ScrollRefreshable<Content: View>: View {
    
    var content: Content
    var onRefresh: () async ->()
    
    init(title: String, tintColor: Color, @ViewBuilder content: @escaping ()->Content, onRefresh: @escaping () async ->()){
        
        self.content = content()
        self.onRefresh = onRefresh
        
        //moving refresh control indicator
        
        let refreshControl = UIRefreshControl.appearance()
        
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -(350 - getSafeArea().top) + refreshControl.bounds.origin.y , width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        
        UIRefreshControl.appearance().attributedTitle = NSAttributedString(string: title)
        UIRefreshControl.appearance().tintColor = UIColor(tintColor)
    }
    
    var body: some View {
        ScrollView{
            content
        }.refreshable {
            await onRefresh()
        }
    }
}



