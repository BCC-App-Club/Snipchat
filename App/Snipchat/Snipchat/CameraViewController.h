//
//  CameraViewController.h
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<AVCapturePhotoCaptureDelegate>

@property AppDelegate* delegate;
@property AVCapturePhotoOutput *capturePhotoOutput;
@property AVCaptureSession *captureSession;
@property IBOutlet UIImageView *cameraView;
@property NSData *imageData;
@property IBOutlet UIButton *switchCameraButton, *takePictureButtion;

-(IBAction)switchCamera:(id)sender;
-(IBAction)takePicture:(id)sender;

@end
