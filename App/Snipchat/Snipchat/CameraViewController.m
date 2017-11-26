//
//  CameraViewController.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "CameraViewController.h"
#import "SendSnipViewController.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //SETUP NOTIFICATIONS
    if(!SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
        NSLog(@"UPDATE TO iOS 10 for Notifications");
    
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = _delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error && granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    
    
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [_captureSession addInput:input];
    CALayer* rootLayer=_cameraView.layer;
    [rootLayer setMasksToBounds:YES];
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    newCaptureVideoPreviewLayer.frame = self.view.bounds;
    [rootLayer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
    _capturePhotoOutput=[[AVCapturePhotoOutput alloc] init];
    [_captureSession addOutput:_capturePhotoOutput];
    [_captureSession startRunning];
    
}

-(IBAction)switchCamera:(id)sender{
    if(_captureSession){
        [_captureSession beginConfiguration];
        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        [_captureSession removeInput:currentCameraInput];
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack) {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else{
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }

        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        if(!newVideoInput || err){
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }else{
            [_captureSession addInput:newVideoInput];
        }
        [_captureSession commitConfiguration];
    }
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position{
    NSArray<AVCaptureDeviceType>* deviceTypes=@[AVCaptureDeviceTypeBuiltInWideAngleCamera];
    AVCaptureDeviceDiscoverySession* discoverySession=[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:position];
    if ([discoverySession.devices count]>0)
        return discoverySession.devices.firstObject;
    return nil;
}

-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{
    if (error) {
        NSLog(@"Image error : %@", error.localizedDescription);
    }
    
    if (photoSampleBuffer) {
        _imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        [self performSegueWithIdentifier:@"showSendFromCamera" sender:self];
    }
}

-(IBAction)takePicture:(id)sender{
    [_capturePhotoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SendSnipViewController* sendViewController=[segue destinationViewController];
    sendViewController.sendImageData=_imageData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
