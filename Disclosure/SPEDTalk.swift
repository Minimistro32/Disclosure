//
//  SPEDTalk.swift
//  Disclosure
//
//  Created by Tyson Freeze on 2/7/24.
//

import SwiftUI

struct Artist: Identifiable {
    let id = UUID()
    let name = "John Doe"
}

struct Song: Identifiable {
    let id = UUID()
    let title = "Test Album"
    let artist = Artist()
}

struct Album: Identifiable {
    let id = UUID()
    let songs = [Song()]
    let cover = "music.mic"
}

struct AlbumDetail: View {
    var album: Album = Album()
    
    var body: some View {
        List(album.songs) { song in
            HStack {
                Image(systemName: album.cover)
                VStack(alignment: .leading) {
                    Text(song.title)
                    Text(song.artist.name)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    AlbumDetail()
}
