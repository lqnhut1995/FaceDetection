//
//  EigenFace.m
//  face_detection
//
//  Created by Hell Rocky on 10/31/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EigenFace.h"
#include <opencv2/face.hpp>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;
using namespace face;

@implementation EigenFace
+ (void)faceRecognizerWithEigenface:(UIImage*)inputimage model:(Ptr<LBPHFaceRecognizer>)model{
    cv::Mat greyMat;
    cv::cvtColor([self cvMatFromUIImage:inputimage], greyMat, CV_BGR2GRAY);
    int predictlabel=-1;
    double confident;
    model->predict(greyMat, predictlabel, confident);
    cout<<"Label:"<< predictlabel <<"Confident:"<<confident<< endl;
}
+ (Ptr<LBPHFaceRecognizer>)faceRecognizerWithEigenface:(vector<Mat>&)images labels:(vector<int>&)labels{
    Ptr<LBPHFaceRecognizer> model = createLBPHFaceRecognizer();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docs = [paths objectAtIndex:0];
    NSString *savedDataPath = [docs stringByAppendingPathComponent:@"LBPHfaces_at.xml"];
    BOOL savedDataExists = [[NSFileManager defaultManager] fileExistsAtPath:savedDataPath];
    if (!savedDataExists) {
        model->train(images, labels);
        FileStorage fs([savedDataPath UTF8String], FileStorage::WRITE);
        model->save(fs);
        fs.release();
//        model->setThreshold(100);
        return model;
    }else{
        FileStorage fs([savedDataPath UTF8String], FileStorage::READ);
        model->load(fs);
        fs.release();
//        model->setThreshold(100);
        return model;
    }
}
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
@end
