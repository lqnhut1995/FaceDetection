//
//  OpencvWrapper.m
//  face_detection
//
//  Created by Soubhi Hadri on 3/3/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import "OpencvWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/objdetect.hpp>
#import <opencv2/imgcodecs/ios.h>
#include <opencv2/face.hpp>
#import <opencv2/videoio/cap_ios.h>
#import "InputFile.h"
#import "EigenFace.h"

using namespace std;
using namespace cv;
using namespace face;

@interface OpencvWrapper() <CvVideoCameraDelegate>

- (void)detect:(cv::Mat)frame with: (void(^)(UIImage *Image,UIImage *faceimg))completion;

@end
@implementation OpencvWrapper

cv::CascadeClassifier face_cascade;
cv::CascadeClassifier eyes_cascade;
bool cascade_loaded = false;
NSString *face_cascade_name = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
NSString *facepath=[[NSBundle mainBundle] pathForResource:@"att_faces" ofType:@"list"];
CvVideoCamera *videoCamera;
UIImageView *imageview;
vector<Mat> images;
vector<int> labels;
Ptr<LBPHFaceRecognizer> model = createLBPHFaceRecognizer();

- (id)init{
    if (self = [super init]) {
        std::cout<<"loading ..";
        if( !face_cascade.load( std::string([face_cascade_name UTF8String]) ) ){
            printf("--(!)Error loading\n");
        }
        [InputFile loadfile:string([facepath UTF8String]) images:images labels:labels];
        if (!images.empty() && !labels.empty()) {
            model=[EigenFace faceRecognizerWithEigenface:images labels:labels];
        }
    }
    return self;
}

- (void)detect:(cv::Mat)frame with: (void(^)(UIImage *Image,UIImage *faceimg))completion {
    if ([NSThread isMainThread]) {
        NSLog(@"main thread....");
    }else
    {
        NSLog(@"background thread..");
    }
    std::vector<cv::Rect> faces;
    cv::Mat frame_gray;
    
    cvtColor( frame, frame_gray, 6 );
    equalizeHist( frame_gray, frame_gray );
    
    face_cascade.detectMultiScale(frame_gray, faces, 1.4, 5);
    for( size_t i = 0; i < faces.size(); i++ )
    {
        cv::Point pt1(faces[i].x,faces[i].y);
        cv::Point pt2( faces[i].x + faces[i].width, faces[i].y + faces[i].height );
        rectangle(frame, pt1, pt2, cv::Scalar( 0, 100, 255 ));
    }
    UIImage *img=MatToUIImage(frame);
    if (faces.size() > 0) {
        CGRect rect=CGRectMake(faces[faces.size()-1].x, faces[faces.size()-1].y, faces[faces.size()-1].width, faces[faces.size()-1].height);
        UIImage *faceimg=[self getSubImageFrom:img WithRect:rect];
        completion(img,faceimg);
    }
    completion(img,nil);
    
}

- (UIImage *) getSubImageFrom:(UIImage *)imageToCrop WithRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void)setupCamera:(UIImageView *)imageView{
    imageview=imageView;
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.delegate=self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
}
- (void)startCamera{
    [videoCamera start];
}
- (void)flipCamera{
    [videoCamera switchCameras];
}
- (void)processImage:(cv::Mat &)image {
    [self detect:image with:^(UIImage *Image, UIImage *faceimg) {
        if (!images.empty() && !labels.empty()) {
            if (faceimg) {
                [EigenFace faceRecognizerWithEigenface:faceimg model:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            imageview.image = Image;
        });
    }];
}

@end
