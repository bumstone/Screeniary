//
//  WatchListView.swift
//  Screeniary
//
//  Created by 고범석 on 6/19/25.
//

import SwiftUI

struct WatchListView: View {
    @State var mediaList: [Media] = []
    @State var dbFirebase: DbFirebase?

    var body: some View {
        NavigationView {
            List {
                ForEach($mediaList, id: \.id) { $media in
                    MediaCardView(media: $media, dbFirebase: $dbFirebase)
                }
                .onDelete { indexSet in
                    deleteMedia(indexSet: indexSet)
                }
            }
            .navigationTitle("시청 기록")
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: MediaNewView(dbFirebase: $dbFirebase, mediaList: $mediaList)) {
                    Image(systemName: "plus.app")
                }
            )
            .onAppear {
                if dbFirebase == nil {
                    dbFirebase = DbFirebase(parentNotification: handleDbChange)
                    dbFirebase?.setQuery(from: 1, to: 10000)
                }
            }
        }
    }

    func deleteMedia(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let media = mediaList[index]
        dbFirebase?.saveChange(key: media.id ?? UUID().uuidString, object: Media.toDict(media: media), action: .delete)
    }

    func handleDbChange(dict: [String: Any]?, dbaction: DbAction?) {
        guard let dict = dict, let dbaction = dbaction else { return }
        let media = Media.fromDict(dict: dict)

        switch dbaction {
        case .add:
            mediaList.append(media)
        case .modify:
            if let index = mediaList.firstIndex(where: { $0.id == media.id }) {
                mediaList[index] = media
            }
        case .delete:
            mediaList.removeAll { $0.id == media.id }
        }
    }
}


#Preview{
    WatchListView()
}


