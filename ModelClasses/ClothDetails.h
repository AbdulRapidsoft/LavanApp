//
//  ClothDetails.h
//  LavanApp
//
//  Created by IPHONE-11 on 01/06/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ClothDetails : NSObject

@property (nonatomic, strong) NSString * clothName;
@property (nonatomic, strong) NSString * clothID;
@property (nonatomic, strong) NSString * clothImageURL;
@property (nonatomic, strong) NSString * clothPrice;
@property (nonatomic, strong) UIImage * clothImage;
@property (nonatomic, strong) NSString * numberofItems;

@end
