//
//  BURefreshGifHeader.m
//  BearUp
//
//  Created by Tebuy on 2017/7/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BURefreshGifHeader.h"
#import <ImageIO/ImageIO.h>

@implementation BURefreshGifHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepare{
    [super prepare];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"下拉" ofType:@"gif"];
    NSString *pathRefreshing = [[NSBundle mainBundle]pathForResource:@"松开" ofType:@"gif"];
    NSMutableArray *idleImages = [NSMutableArray array];
    
    idleImages = [self praseGIFDataToImageArray:[NSData dataWithContentsOfFile:path]];
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *pullingImages = [NSMutableArray array];
    [self setImages:pullingImages forState:MJRefreshStatePulling];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    refreshingImages = [self praseGIFDataToImageArray:[NSData dataWithContentsOfFile:pathRefreshing]];    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}
-(NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

@end
