import SwiftUI

struct AddressSearchSheet: View {

    @Environment(\.dismiss) var dismiss

    var onSelect: (GooglePlaceDetail) -> Void

    @State private var searchText = ""
    @State private var predictions: [PlacePrediction] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {

                TextField("Search address", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                    .onChange(of: searchText) { newText in
                        if newText.count > 2 { searchPlaces(query: newText) }
                        else { predictions.removeAll() }
                    }

                List(predictions, id: \.placeId) { prediction in
                    Button(action: {
                        fetchPlaceDetails(placeId: prediction.placeId)
                    }) {
                        Text(prediction.description)
                    }
                }

                if isLoading {
                    ProgressView("Loading…")
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Search Address")
        }
    }

    func fetchPlaceDetails(placeId: String) {
        isLoading = true

        let apiKey = "AIzaSyCinDdjJJjl5Fl1LqrNUOjBQAW3_Uzy4YU"
        let urlStr = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async { self.isLoading = false }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(GooglePlaceDetailResponse.self, from: data)
                if let detail = response.result {
                    DispatchQueue.main.async {
                        onSelect(detail)
                        dismiss()
                    }
                }
            } catch {
                print("Place Details Error:", error)
            }
        }.resume()
    }

    // MARK: - Google Places Autocomplete
    func searchPlaces(query: String) {
        isLoading = true
        let apiKey = "AIzaSyCinDdjJJjl5Fl1LqrNUOjBQAW3_Uzy4YU"

        let input = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(input)&key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }

            guard let data = data else { return }

            do {
                let res = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.predictions = res.predictions
                }
            } catch {
                print("Decode error:", error)
            }

        }.resume()
    }
}
struct GooglePlaceDetailResponse: Decodable {
    let result: GooglePlaceDetail?
}

struct GooglePlaceDetail: Decodable {
    let name: String?
    let addressComponents: [AddressComponent]
    let geometry: Geometry?

    enum CodingKeys: String, CodingKey {
        case name
        case addressComponents = "address_components"
        case geometry
    }
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

struct AddressComponent: Decodable {
    let longName: String
    let shortName: String?
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct GooglePlacesResponse: Decodable {
    let predictions: [PlacePrediction]
}

struct PlacePrediction: Decodable {
    let description: String
    let placeId: String

    enum CodingKeys: String, CodingKey {
        case description
        case placeId = "place_id"
    }
}
