//
//  ShirtsViewController.m
//  LavanApp
//
//  Created by IPHONE-11 on 28/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "ShirtsViewController.h"
#import "ClothsDetailCell.h"
#import "WebCommunication.h"
#import "ImageDownloader.h"
#import "Definition.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "RSTAlertView.h"

@interface ShirtsViewController () < ImageDownloaderDelegate >
{
    AppDelegate * appDelegate;
}

@end

@implementation ShirtsViewController

#pragma mark - view life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
    self.pendingOperations = [[PendingOperations alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    cellsSelected = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelectedItemsFromArray) name:@"CartItemsRemoved" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([productList count] > 0)
    {
        [listTableView reloadData];
    }
    else
    {
        [self getDataFromServer];
    }
}
#pragma mark - memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([productList count] > 0)
    {
        return [productList count];
    }
    else
    {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClothsDetailCell * cell = (ClothsDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"ClothsCell"];
    if (cell == nil)
    {
        cell = [ClothsDetailCell CreateCustomCell:self];
        [cell.leftButton addTarget:self action:@selector(cellsLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(cellsRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.leftButton.tag = indexPath.row;
    cell.rightButton.tag = indexPath.row;
    cell.selectedView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([productList count] > 0)
    {
        ClothDetails * product = [productList objectAtIndex:indexPath.row];
        
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:product.clothName];
        NSRange range = NSMakeRange(0, [attString length]);
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(1.0f, 1.0f);
        [attString addAttribute:NSShadowAttributeName value:shadow range:range];
        cell.clothName.attributedText = attString;

        attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@€",product.clothPrice]];
        range = NSMakeRange(0, [attString length]);
        [attString addAttribute:NSShadowAttributeName value:shadow range:range];
        cell.clothPrice.attributedText = attString;
        
        cell.batgeNumber.text = product.numberofItems;
        cell.batgeNumber.numberOfLines = 1;
        cell.batgeNumber.minimumScaleFactor = 8./cell.batgeNumber.font.pointSize;
        cell.batgeNumber.adjustsFontSizeToFitWidth = YES;
        CGFloat actualFontSize;
        CGSize adjustedSize = [cell.batgeNumber.text sizeWithFont:cell.batgeNumber.font
                                                      minFontSize:cell.batgeNumber.minimumFontSize
                                                   actualFontSize:&actualFontSize
                                                         forWidth:cell.batgeNumber.bounds.size.width
                                                    lineBreakMode:cell.batgeNumber.lineBreakMode];
        CGFloat differenceInFontSize = cell.batgeNumber.font.pointSize - actualFontSize;
        cell.batgeNumber.font = [UIFont fontWithName:cell.batgeNumber.font.fontName size:cell.batgeNumber.font.pointSize - differenceInFontSize];

        if ([product.clothImageURL length] && !product.clothImage && (!tableView.dragging && !tableView.decelerating))
        {
            cell.cellImage.image = [UIImage imageNamed:@"Cloth-place-holder.png"];
            [cell.activityIndicator startAnimating];
            cell.activityIndicator.hidden = NO;
            [self startOperationsForRecord:product atIndexPath:indexPath];
        }
        else if (product.clothImage)
        {
            cell.cellImage.image = product.clothImage;
            [cell.activityIndicator stopAnimating];
            cell.activityIndicator.hidden = YES;
        }
        else
        {
            cell.cellImage.image = [UIImage imageNamed:@"Cloth-place-holder.png"];
            [cell.activityIndicator startAnimating];
            cell.activityIndicator.hidden = NO;
        }
        
        if ([cellsSelected count] > 0)
        {
            if ([cellsSelected containsObject:indexPath])
            {
                cell.selectedView.hidden = NO;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ClothsDetailCell * cell = (ClothsDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([productList count] > 0)
    {
        ClothDetails * clothObj = [productList objectAtIndex:indexPath.row];
        int numberofItem = [clothObj.numberofItems intValue];
        if (numberofItem < 1)
        {
            cell.selectedView.hidden = !cell.selectedView.hidden;
            if (cell.selectedView.hidden)
            {
                [cellsSelected removeObject:indexPath];
            }
            else
            {
                [cellsSelected addObject:indexPath];
            }
        }
    }
}

#pragma mark - IBAction methods

- (void)cellsLeftButtonClicked:(UIButton *)leftBtn
{
    if ([productList count] > 0)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:leftBtn.tag inSection:0];
        [self.delegate itemDeselectedForPlaceingOrder:[productList objectAtIndex:leftBtn.tag]];
        [listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)cellsRightButtonClicked:(UIButton *)rightBtn
{
    if ([productList count] > 0)
    {
        [self.delegate itemSelectedForPlaceingOrder:[productList objectAtIndex:rightBtn.tag]];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:rightBtn.tag inSection:0];
        [listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)removeSelectedItemsFromArray
{
    appDelegate = [AppDelegate sharedInstance];
    for (ClothDetails * obj in appDelegate.cartItemsArray)
    {
        obj.numberofItems = @"0";
    }
    [appDelegate.cartItemsArray removeAllObjects];
    [cellsSelected removeAllObjects];
    [listTableView reloadData];
}

#pragma mark -
#pragma mark - Class Methods

- (void)getDataFromServer
{
    if (![Utility isNetworkAvailable])
    {
        [RSTAlertView showAlertMessage:NSLocalizedString(kNetworkError, nil) withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {}
        }];
        return;
    }
    
    NSString * deviceToken = [Utility objectForKey:@"DeviceToken"];
    if (deviceToken == nil)
    {
        deviceToken = @"0123456789";
    }
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBaseURL]];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"CATEGORY_PRODUCTS_SERVICE" forKey:@"request_type_sent"];
    [dictionary setObject:@"2" forKey:@"device_type"];
    [dictionary setObject:deviceToken forKey:@"device_id"];
    [dictionary setObject:self.catagoryType forKey:@"category_id"];
    dictionary = (NSMutableDictionary *)[Utility convertIntoBase64:[dictionary allValues] dictionary:dictionary];

    [dictionary setObject:@"1" forKey:@"decode"];
    
    [kAppDelegate loadingEnd];
    [kAppDelegate loadingStart];

    WebCommunication * webComm = [WebCommunication new];
    [webComm callToServerRequestDictionary:dictionary onURL:url WithBlock:^(NSDictionary * response, NSInteger status_code, NSError *error, WebCommunication * webComm)
     {
         [kAppDelegate loadingEnd];

         if (response.allValues.count)
         {
             response = [Utility convertIntoUTF8:[response allValues] dictionary:response];
         }
         else
         {
             [[AppDelegate sharedInstance] loadingEnd];
             [RSTAlertView showAlertMessage:kGeneralServerErrorAlert withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
             return ;
         }
         
         if((long)status_code == 200)
         {
             if ([[response objectForKey:@"error_code"] isEqualToString:@"400"])
             {
                 NSLog(@"No product found.");
             }
             else
             {
                 NSMutableDictionary * fullDictionary = [response objectForKey:self.catagoryType];
                 NSMutableArray * arr = fullDictionary[@"products"];
                 productList = [[NSMutableArray alloc] init];
                 for (NSMutableDictionary * dic in arr)
                 {
                     ClothDetails * clothObj = [[ClothDetails alloc] init];
                     clothObj.clothName = [dic valueForKey:@"name"];
                     clothObj.clothID = [dic valueForKey:@"id"];
                     clothObj.clothPrice = [dic valueForKey:@"price"];
                     clothObj.clothImageURL = [dic valueForKey:@"image"];
                     clothObj.numberofItems = @"0";
                     [productList addObject:clothObj];
                 }
                 [listTableView reloadData];
             }
         }
         else
         {
             [RSTAlertView showAlertMessage:[response objectForKey:@"error_desc"] withButtons:eOk completionHandler:^(NSInteger buttonIndex) {
                 if (buttonIndex == 0) {}
             }];
         }
     }];
}

- (void)startOperationsForRecord:(ClothDetails *)record atIndexPath:(NSIndexPath *)indexPath
{
    // 1: First, check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore it.
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath] && !record.clothImage)
    {
        // 2: If not, create an instance of ImageDownloader by using the designated initializer, and set ListViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of PhotoRecord, and then add it to the download queue. You also add it to downloadsInProgress to help keep track of things.
        // Start downloading
        ImageDownloader * imageDownloader = [[ImageDownloader alloc] initWithInfo:indexPath url:[NSURL URLWithString:record.clothImageURL] delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)loadImagesForOnscreenCells
{
    // 1: Get a set of visible rows.
    NSSet * visibleRows = [NSSet setWithArray:[listTableView indexPathsForVisibleRows]];
    
    // 2: Get a set of all pending operations (download and filtration).
    NSMutableSet * pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    NSMutableSet * toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet * toBeStarted = [visibleRows mutableCopy];
    
    // 3: Rows (or indexPaths) that need an operation = visible rows ñ pendings.
    [toBeStarted minusSet:pendingOperations];
    
    // 4: Rows (or indexPaths) that their operations should be cancelled = pendings ñ visible rows.
    [toBeCancelled minusSet:visibleRows];
    
    // 5: Loop through those to be cancelled, cancel them, and remove their reference from PendingOperations.
    for (NSIndexPath * anIndexPath in toBeCancelled)
    {
        ImageDownloader * pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
    }
    
    // 6: Loop through those to be started, and call startOperationsForPhotoRecord:atIndexPath: for each.
    for (NSIndexPath * anIndexPath in toBeStarted)
    {
        if ([productList count] > 0)
        {
            ClothDetails * recordToProcess = [productList objectAtIndex:anIndexPath.row];
            [self startOperationsForRecord:recordToProcess atIndexPath:anIndexPath];
        }
    }
}

#pragma mark -
#pragma mark - ImageDownloader delegate

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{
    NSIndexPath * indexPath = (NSIndexPath *)downloader.info;
    
    NSArray * visibleCells = [listTableView visibleCells];
    if ([productList count] > 0 && [visibleCells count] > 0)
    {
        ClothDetails * detail = [productList objectAtIndex:indexPath.row];
        detail.clothImage = downloader.image;
        
        int lowCell = (int)[listTableView indexPathForCell:[visibleCells objectAtIndex:0]].row;
        int lastCell = (int)[listTableView indexPathForCell:[visibleCells lastObject]].row;
        
        if (indexPath.row >= lowCell && indexPath.row <= lastCell)
        {
            [listTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
    //NSLog(@"imageDownloaderDidFinish %d", (int)indexPath.row);
}

#pragma mark -
#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 1: As soon as the user starts scrolling, you will want to suspend all operations and take a look at what the user wants to see.
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 2: If the value of decelerate is NO, that means the user stopped dragging the table view. Therefore you want to resume suspended operations, cancel operations for offscreen cells, and start operations for onscreen cells.
    if (!decelerate)
    {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 3: This delegate method tells you that table view stopped scrolling, so you will do the same as in #2.
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

#pragma mark -
#pragma mark - Cancelling, suspending, resuming queues / operations

- (void)suspendAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:YES];
}

- (void)resumeAllOperations
{
    [self.pendingOperations.downloadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
    [self.pendingOperations.downloadQueue cancelAllOperations];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
