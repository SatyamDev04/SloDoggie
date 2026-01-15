//
//  MyEventsViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import Combine

final class EventListViewModel: ObservableObject {

    // MARK: - UI State
    @Published var selectedTab: String = "My Events"
    @Published var myEvents: [SavedEvent] = []
    @Published var isLoading: Bool = false

    // MARK: - Pagination
    @Published var page: Int = 1
    @Published var totalPages: Int = 1

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        fetchEvents()
    }

    // MARK: - Fetch Events
    func fetchEvents(
        type: String? = nil,
        page: Int? = nil
    ) {

        let currentPage = page ?? self.page
        let eventType = type ?? mapTabToType(selectedTab)

        guard !isLoading, currentPage <= totalPages else { return }

        isLoading = true

        APIManager.shared
            .getMyEventList(
                id: "1",                 // Replace with logged-in user id
                page: currentPage,
                type: eventType
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false

                if case .failure(let error) = completion {
                    print("Event API Error:", error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                guard response.success ?? false else { return }

                self.totalPages = response.data?.totalPage ?? 0

                if currentPage == 1 {
                    self.myEvents = response.data?.events ?? []
                } else {
                    self.myEvents.append(contentsOf: response.data?.events ?? [])
                }

                self.page = currentPage

            }
            .store(in: &cancellables)
    }

    // MARK: - Tab Selection
    func selectTab(_ tab: String) {
        selectedTab = tab
        page = 1
        totalPages = 20
        myEvents.removeAll()

        fetchEvents(
            type: mapTabToType(tab),
            page: 1
        )
    }

    // MARK: - Load Next Page (Pagination)
    func loadNextPageIfNeeded(currentEvent event: SavedEvent) {
        guard let lastEvent = myEvents.last else { return }

        if event.id == lastEvent.id {
            fetchEvents(page: page + 1)
        }
    }

    // MARK: - Helpers
    private func mapTabToType(_ tab: String) -> String {
        switch tab {
        case "Saved":
            return "saved_event"
        default:
            return "my_event"
        }
    }
}
