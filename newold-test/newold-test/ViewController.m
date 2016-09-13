//
//  ViewController.m
//  newold-test
//
//  Created by Javier Soto Morras on 13/09/2016.
//  Copyright © 2016 IDEO. All rights reserved.
//



#import "ViewController.h"
#import "UIView+Layout.h"


@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic,strong) CIDetector *faceDetector;
@property(nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic) dispatch_queue_t videoDataOutputQueue;

@property(nonatomic,strong) NSMutableArray <UIView *> *boxes;
@property(nonatomic,strong) UIImage *laughingManImage;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//setting up a capture session
    AVCaptureSession *session = [AVCaptureSession new];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //Setting the camera as device
    AVCaptureDevice *device = [self frontCamera];
    
    //getting the input from the camera
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    
    [session addInput:input];
    
    //add the preview layer -  proyecting capture from camera to screen
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    _previewLayer.frame = self.view.frame;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    [session startRunning];
    
    //turning the camera view
    AVCaptureConnection *previewLayerConnection = _previewLayer.connection;
    [previewLayerConnection setVideoOrientation:(AVCaptureVideoOrientation)[[UIApplication sharedApplication]statusBarOrientation]];
    
// Create a method for initialising the face detection
    
    [self faceDetecting];
    
    [self faceShower:session];
    
    self.boxes = [NSMutableArray array];
    
    self.laughingManImage = [UIImage imageNamed: @"laughing_man"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//creating a method for getting front camera
- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

//method for detecting faces
- (void)faceDetecting {
    
    NSDictionary *options = @{CIDetectorTracking: @YES, CIDetectorAccuracy: CIDetectorAccuracyHigh};
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    

    
}

// method for Showing faces
- (void) faceShower:(AVCaptureSession *) session {
    
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *rgbOutputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCMPixelFormat_32BGRA]};
    [_videoDataOutput setVideoSettings:rgbOutputSettings];
    [_videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    //create theread for detecting face
    self.videoDataOutputQueue = dispatch_queue_create("videoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    
    //checking we are getting new output from camera
    [_videoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
    if ( [session canAddOutput:_videoDataOutput]) {
        [session addOutput:_videoDataOutput];
    }
    
    [[_videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
                                        

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    
    //NSLog(@"AL Hello");
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if(attachments) CFRelease(attachments);
    
    NSNumber *orientation;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = @6;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = @8;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = @3;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = @1;
            break;
        default:
            orientation = @6;
            break;
    }
    
    NSDictionary *options = @{ CIDetectorSmile: @(YES), CIDetectorImageOrientation:orientation };
    NSArray *features = [self.faceDetector featuresInImage:ciImage options:options];
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect cleanAperture = CMVideoFormatDescriptionGetCleanAperture(fdesc, false);
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self drawFaces:features forVideoBox:cleanAperture];
//        [self recognizeFaces:features screenshot:ciImage];
    });
}

- (void)drawFaces: (NSArray *)features forVideoBox:(CGRect)clearAperture {
    float hscale = self.view.frame.size.height / clearAperture.size.height;
    float wscale = self.view.frame.size.width / clearAperture.size.width;
    
    for (int i = 0; i<_boxes.count;i++) {
        [[_boxes objectAtIndex:i] removeFromSuperview];
    }
    
    [_boxes removeAllObjects];
    
    for (int i = 0; i<features.count;i++) {
    
        CIFaceFeature *ff = [features objectAtIndex:i];
        
        UIView *boxFace = [UIView new];
        
        //boxFace.backgroundColor = [UIColor blackColor];
        
        CGRect faceRect = [ff bounds];
        faceRect.origin.y = faceRect.origin.y * hscale;
        faceRect.size.height = faceRect.size.height * hscale ;
        faceRect.origin.x = faceRect.origin.x * wscale;
        faceRect.size.width = faceRect.size.width * wscale ;
        
        //boxFace.frame = faceRect;
        
        boxFace.center = CGPointMake(faceRect.origin.x + (faceRect.size.width / 2), faceRect.origin.y + (faceRect.size.height / 2));
        
        [self.view addSubview:boxFace];
        
        [_boxes addObject:boxFace];
        
        //UIImageView *laughingFace = [[UIImageView alloc] initWithImage: _laughingManImage];
        
        
        UIView *laughingFace = [UIView new];
        
        laughingFace.layer.contents = (id) _laughingManImage.CGImage;
        
        [boxFace addSubview:laughingFace];
        
    
        //laughingFace.contentMode = UIViewContentModeScaleAspectFill;
        [laughingFace setSize:CGSizeMake(faceRect.size.width * 1.6 * 1.11, faceRect.size.height * 1.6)];
        [laughingFace centerInParent];
        
        
    }


}




@end
