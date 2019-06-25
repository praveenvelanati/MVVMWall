//
//  FeedListController.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit

class FeedListController {
    
    let socialService: SocialService
    let viewModel: FeedListViewModel
    
    init(viewModel: FeedListViewModel = FeedListViewModel(), socialService: SocialService = SocialService()) {
        self.viewModel = viewModel
        self.socialService = socialService
    }
    
    func start() {
        self.viewModel.isLoading.value = true
        self.viewModel.isTableViewHidden.value = true
        self.viewModel.title.value = "Loading..."
        socialService.fetchFeeds { [weak self] (feeds) in
            self?.viewModel.title.value = "Your Feeds"
            self?.viewModel.isLoading.value = false
            self?.viewModel.isTableViewHidden.value = false
            self?.buildViewModels(feeds: feeds)
        }
        
        
    }
    
    func buildViewModels(feeds: [Feed]) {
        
        var sectionTable = [String: [RowViewModel]]()
        var vm: RowViewModel?
        
        for feed in feeds {
            let groupingKey = sectionGroupingKey(feed)
            if let memberFeed = feed as? Member {
                
                let avatarImage = AsyncImage(url: memberFeed.avatarURL, placeholderImage: UIImage())
                let profileVM: MemberCellViewModel = MemberCellViewModel(name: memberFeed.name,
                                                                         avatar: avatarImage)
                profileVM.addBtnPressed = handleAddContact(memberFeed.userID, viewModel: profileVM)
                vm = profileVM
            } else if let photoFeed = feed as? Photo {
                let photoCellViewModel = PhotoCellViewModel(title: photoFeed.captial,
                                                            desc: photoFeed.description,
                                                            image: AsyncImage(url: photoFeed.imageURL, placeholderImage: UIImage(named: "profile") ?? UIImage()))
                photoCellViewModel.cellPressed = {
                    print("Open a photo viewer!")
                }
                vm = photoCellViewModel
            }
            
            if let vm = vm {
                if var rows = sectionTable[groupingKey] {
                    rows.append(vm)
                    sectionTable[groupingKey] = rows
                } else {
                    sectionTable[groupingKey] = [vm]
                }
            }
        }
        
        self.viewModel.sectionViewModels.value = convertToSectionViewModel(sectionTable)
    }
    
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is PhotoCellViewModel:
            return PhotoCell.cellIdentifier()
        case is MemberCellViewModel:
            return MemberCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    private func convertToSectionViewModel(_ sectionTable: [String: [RowViewModel]]) -> [SectionViewModel] {
        let sortedGroupingKey = sectionTable.keys.sorted(by: dateStringDescComparator())
        return sortedGroupingKey.map {
            let rowViewModels = sectionTable[$0]!
            return SectionViewModel(rowViewModels: rowViewModels, headerTitle: $0)
        }
    }

    
    /// Use the date string for grouping feeds, e.x grouping same-date feeds
    private func sectionGroupingKey(_ feed: Feed) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter.string(from: feed.time)
    }
    
    private func dateStringDescComparator() -> ((String, String) -> Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return { (d1Str, d2Str) -> Bool in
            if let d1 = formatter.date(from: d1Str), let d2 = formatter.date(from: d2Str) {
                return d1 > d2
            } else {
                return false
            }
        }
    }
    
    // MARK: - User interaction
    
    func handleAddContact(_ userID: String, viewModel: MemberCellViewModel) -> (() -> Void) {
        return { [weak self, weak viewModel] in
            viewModel?.isLoading.value = true
            viewModel?.isAddBtnHidden.value = true
            
            self?.socialService.follow(userID: userID, complete: { (success) in
                if success {
                    viewModel?.isAddBtnEnabled.value = false
                    viewModel?.addBtnTitle.value = String.fontAwesomeIcon("check")!
                }
                viewModel?.isAddBtnHidden.value = false
                viewModel?.isLoading.value = false
            })
            
        }
    }
    
    
}
