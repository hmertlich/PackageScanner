//
//  ScanTrackingNumber.h
//  PackageScanner
//
//  Created by Skyler Tanner on 8/3/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;


@interface ScanTrackingNumberViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) NSString *trackingNumberString;
@property (nonatomic, strong) NSString *carrier;

@end
