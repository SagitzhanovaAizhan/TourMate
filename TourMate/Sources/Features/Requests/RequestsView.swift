import SwiftUI

struct RequestsView: View {
    let viewState: RequestsViewModel.ViewState
    @StateObject private var viewModel = RequestsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.filteredRequests(for: viewState).isEmpty {
                    Image(viewState == .saved ? .emptySaved : .emptyRequest)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredRequests(for: viewState)) { request in
                            NavigationLink(destination: RequestDetailView(request: request)) {
                                RequestCardView(
                                    request: request,
                                    isLikeVisible: viewState == .saved,
                                    isLiked: viewModel.likedIDs.contains(request.id),
                                    onLikeTapped: {
                                        viewModel.toggleLike(for: request.id)
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if viewState != .saved {
                                    Button(role: .destructive) {
                                        viewModel.deleteRequest(id: request.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewState.title)
            .refreshable {
                viewModel.loadRequests()
                viewModel.loadLiked()
            }
            .onAppear {
                viewModel.loadRequests()
                viewModel.loadLiked()
            }
        }
    }
}

#Preview {
    RequestsView(viewState: .saved)
}
