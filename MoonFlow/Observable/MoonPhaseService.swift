//
//  MoonPhaseHelper.swift
//  MoonFlow
//
//  Created by Camille on 26/3/24.
//

import Foundation

//class MoonPhaseService: ObservableObject {
//
//    @Published var moonData: MoonJson?
//
//    private let headers = [
//        "X-RapidAPI-Key": "d7ae7401abmshe32412f54def28fp134eb5jsn93b65b582bbf",
//        "X-RapidAPI-Host": "moon-phase.p.rapidapi.com"
//    ]
//

    //    let url = URL(string: "https://api.stackexchange.com/2.3/questions?pagesize=1&order=desc&sort=votes&site=stackoverflow&filter=)pe0bT2YUo)Qn0m64ED*6Equ")!
    //    let (data, _) = try await URLSession.shared.data(from: url)
    //    let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
    //    return wrapper.items[0]


    func fetchSimpleMoonPhase() async throws -> MoonJson {
        print("CALL MOON")
         let headers = [
            "X-RapidAPI-Key": "d7ae7401abmshe32412f54def28fp134eb5jsn93b65b582bbf",
            "X-RapidAPI-Host": "moon-phase.p.rapidapi.com"
        ]
            let url = URL(string: "https://moon-phase.p.rapidapi.com/basic")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(MoonJson.self, from: data)
    }

    //        do {
    //        let urlString = "https://moon-phase.p.rapidapi.com/basic"
    //        performGETRequest(urlString: urlString, headers: headers) { data, response, error in
    //            if let error = error {
    //                print("Error: \(error.localizedDescription)")
    //            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
    //                print("Response: \(responseString)")
    ////                    let result = try JSONDecoder().decode(MoonJson.self, from: data)
    //            }
    //        }
    //        } catch {
    //            print("boarf")
    //        }
//}

//func fetchAdvancedMoonPhase() {
//    let urlString = "https://moon-phase.p.rapidapi.com/advanced?lat=51.4768&lon=-0.0004"
//    //        let headers = [
//    //            "X-RapidAPI-Key": "d7ae7401abmshe32412f54def28fp134eb5jsn93b65b582bbf",
//    //            "X-RapidAPI-Host": "moon-phase.p.rapidapi.com"
//    //        ]
//
//    performGETRequest(urlString: urlString, headers: headers) { data, response, error in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//        } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
//            print("Response: \(responseString)")
//        }
//    }
//}

//}

enum MoonPhase {
    case full_moon
    case waning_gibbous
    case last_quarter
    case waning_crescent
    case new_moon
    case maxing_crescent
    case first_quarter
    case waxing_gibbous
}

//{"phase_name":"Waning Gibbous","stage":"waning","days_until_next_full_moon":28,"days_until_next_new_moon":12}


struct MoonJson {
    let phase: MoonPhase
    let daysUntilNextFullMoon: Int
    let daysUntilNextNewMoon: Int
    let imageName: String
}

extension MoonJson: Decodable {
    enum CodingKeys: String, CodingKey {
        case phase = "phase_name"
        case daysUntilNextFullMoon = "days_until_next_full_moon"
        case daysUntilNextNewMoon = "days_until_next_new_moon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let phaseString = try container.decode(String.self, forKey: .phase)
        self.phase = .waxing_gibbous
        self.daysUntilNextFullMoon = try container.decode(Int.self, forKey: .daysUntilNextFullMoon)
        self.daysUntilNextNewMoon = try container.decode(Int.self, forKey: .daysUntilNextNewMoon)
        self.imageName = "5fullmoon_A"
        //        switch phaseString {
        //        case "Full Moon": self.phase = .FULL_MOON
        //        case default: self.phase = nil
        //        }
        //        self.podcastID = try container.decode(Int.self, forKey: .podcastID)
        //        let duration = try container.decode(Int.self, forKey: .duration)
        //        self.duration = .milliseconds(duration)
        //        self.title = try container.decode(String.self, forKey: .title)
        //        self.date = try container.decode(Date.self, forKey: .date)
        //        self.url = try container.decode(URL.self, forKey: .url)
    }
}
