//
//  PhotosVC.swift
//  UnsplashMapped
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit
import CoreData
import CHTCollectionViewWaterfallLayout
import ViewAnimator

class PhotosVC: UIViewController {
    
    enum Section { case main }
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var collectionView: UICollectionView!
    var darkModeBarItem: DarkModeBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureCollectionView()
        configureFetchResultsController()
        fetchCoreData()
    }
    
    
    private func configureAppearance() {
        view.backgroundColor = UMColor.whiteToDarkGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        configureDarkModeBarItem()
    }

    
    private func configureDarkModeBarItem() {
        darkModeBarItem = DarkModeBarButtonItem(traitCollection: traitCollection)
        navigationItem.rightBarButtonItem = darkModeBarItem
    }
    
    
    
    private func configureCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing     = 24
        layout.minimumInteritemSpacing  = 20
        layout.sectionInset             = UIEdgeInsets(with: UMLayout.padding)
        layout.sectionInset.bottom      = 150
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate                     = self
        collectionView.dataSource                   = self
        collectionView.dragInteractionEnabled       = true
        collectionView.dragDelegate                 = self
        collectionView.dropDelegate                 = self
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UMColor.whiteToDarkGray
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
    }

    
    //MARK: - FetchedResultsController
    
    private func configureFetchResultsController() {
        let request: NSFetchRequest<Photo> = NSFetchRequest(entityName: "Photo")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self
    }
    
    
    private func fetchCoreData() {
        do {
            try fetchedResultsController.performFetch()
            collectionView.performBatchUpdates {
                let cells = collectionView.orderedVisibleCells
                let animation = AnimationType.vector(CGVector(dx: 0, dy: 100))
                UIView.animate(views: cells, animations: [animation], duration: 1)
            }
        } catch {
            self.showPopupVC(title: "Error", body: error.localizedDescription)
        }
    }
}


extension PhotosVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:   controllerDidInsert(newIndexPath: newIndexPath!)
        case .delete:   controllerDidDelete(indexPath: indexPath!)
        case .move:     controllerDidMove(newIndexPath: newIndexPath!, indexPath: indexPath!)
        default: break
        }
    }
    
    
    private func controllerDidInsert(newIndexPath indexPath: IndexPath) {
        let scrollable = collectionView.contentSize.height > collectionView.frame.size.height
        if scrollable {
            let bottomOffset = CGPoint(
                x: 0,
                y: collectionView.contentSize.height - collectionView.bounds.height + collectionView.contentInset.bottom
            )
            collectionView.setContentOffset(bottomOffset, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectionView.insertItems(at: [indexPath])
            
            self.collectionView.performBatchUpdates { 
                let cell        = self.collectionView.cellForItem(at: indexPath)
                let animation   = AnimationType.vector(CGVector(dx: 0, dy: 30))
                
                cell?.animate(animations: [animation], duration: 1)
            }
        }
    }
    
    
    private func controllerDidDelete(indexPath: IndexPath) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        let isLastItem = indexPath.row == lastItemIndex
        
        collectionView.deleteItems(at: [indexPath])
                
        if !isLastItem {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    
    private func controllerDidMove(newIndexPath: IndexPath, indexPath: IndexPath) {
        collectionView.moveItem(at: indexPath, to: newIndexPath)
        
        var indexPaths: [IndexPath] = []
        
        let lowerRow = min(indexPath.row, newIndexPath.row)
        let upperRow = max(indexPath.row, newIndexPath.row)
        
        Array(lowerRow...upperRow).forEach {
            indexPaths.append(IndexPath(row: $0, section: 0))
        }
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}


extension PhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = fetchedResultsController.fetchedObjects else { return 0 }
        return photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath)
        cell.setUp(with: photo)
                
        return cell
    }
}


extension PhotosVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo           = fetchedResultsController.object(at: indexPath)
        let photoModalVC    = PhotoModalVC(photo: photo)
        
        self.showModalVC(customChildVC: photoModalVC, height: .half)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let animation: AnimationType!
        
        switch scrollDirection {
        case .up:   animation = AnimationType.vector(CGVector(dx: 0, dy: -50))
        case .down: animation = AnimationType.vector(CGVector(dx: 0, dy: 50))
        default: return
        }
        
        cell.animate(animations: [animation], duration: 1, options: .allowUserInteraction)
    }
    
    
    enum ScrollDirection {
        case up, down
    }


    var scrollDirection: ScrollDirection? {
        if collectionView.panGestureRecognizer.translation(in: collectionView.superview).y > 0 {
            return .up
        } else if collectionView.panGestureRecognizer.translation(in: collectionView.superview).y < 0 {
            return .down
        } else {
            return nil
        }
    }
}


extension PhotosVC: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = fetchedResultsController.object(at: indexPath)
        return CGSize(width: 100, height: 100*photo.ratio)
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}


extension PhotosVC: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = fetchedResultsController.object(at: indexPath)
        
        if let itemProvider = NSItemProvider(contentsOf: item.objectID.uriRepresentation()) {
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            
            return [dragItem]
        }
        
        return []
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath)
        }
    }
    
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            let items = self.fetchedResultsController.fetchedObjects!
            CoreDataManager.movePhoto(items: items, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        }
    }
}
