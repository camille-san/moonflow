//
//  MoonResult.swift
//  MoonFlow
//
//  Created by Camille on 26/3/24.
//

import Foundation


//{"phase_name":"Waning Gibbous","stage":"waning","days_until_next_full_moon":28,"days_until_next_new_moon":12}


struct MoonJson {
    let phase: MoonPhase
    let daysUntilNextFullMoon: Int
    let daysUntilNextNewMoon: Int
    let imageName: String
}

extension MoonJson: Decodable {
    enum CodingKeys: String, CodingKey {
        case phase = "trackId"
        case daysUntilNextFullMoon = "collectionId"
        case daysUntilNextNewMoon = "trackTimeMillis"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
//        self.podcastID = try container.decode(Int.self, forKey: .podcastID)
//        let duration = try container.decode(Int.self, forKey: .duration)
//        self.duration = .milliseconds(duration)
//        self.title = try container.decode(String.self, forKey: .title)
//        self.date = try container.decode(Date.self, forKey: .date)
//        self.url = try container.decode(URL.self, forKey: .url)
    }
}
