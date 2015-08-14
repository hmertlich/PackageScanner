//
//  ScanTrackingNumber.m
//  PackageScanner
//
//  Created by Skyler Tanner on 8/3/15.
//  Copyright (c) 2015 Skyler Tanner. All rights reserved.
//

#import "ScanTrackingNumberViewController.h"
#import "NewTicketViewController.h"

@interface ScanTrackingNumberViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ScanTrackingNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    self.captureSession = nil;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    
    // Initialize the captureSession object.
    self.captureSession = [AVCaptureSession new];
    // Set the input device on the capture session.
    [self.captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    [self.captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
 
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeCode128Code]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    
    // Start video capture.
    [self.captureSession startRunning];

    
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [self.videoPreviewLayer removeFromSuperlayer];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeCode128Code]) {
            // If the found metadata is equal to the 128 code then update the status label's text,
   
            if ([metadataObj stringValue].length >=18) {

                NSString *parsedTrackingNumber = [metadataObj stringValue];
                
                // Check barcode type, and return the tracking number based on company
                if ([self.carrier isEqualToString: @"UPS"]) {
                    self.trackingNumberString = parsedTrackingNumber;
                }
                if ([self.carrier isEqualToString: @"FedEx"]) {
                    self.trackingNumberString = [parsedTrackingNumber substringFromIndex:(parsedTrackingNumber.length -12)];
                }
                if ([self.carrier isEqualToString: @"DHL"]) {
                    self.trackingNumberString = [parsedTrackingNumber substringFromIndex:(parsedTrackingNumber.length -12)];
                }
                if ([self.carrier isEqualToString: @"USPS"]) {
                    self.trackingNumberString = parsedTrackingNumber;
                }
                if ([self.carrier isEqualToString: @"Other"]) {
                    self.trackingNumberString = [metadataObj stringValue];
                }
                
                //If the audio player is not nil, then play the sound effect.
                
                if (self.audioPlayer) {
                    [self.audioPlayer play];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"unwindToNewTicketView" sender:self];
                });
            }
        }
    }
}

-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [self.audioPlayer prepareToPlay];
    }
}

@end
