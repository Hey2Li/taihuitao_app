//
//  FSBaseTopTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseTopTableViewCell.h"

@interface FSBaseTopTableViewCell ()
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end
@implementation FSBaseTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.cycleScrollView];
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_nomal_dot_4x4_"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_red_dot_13x4_"];
//        self.cycleScrollView.pageControlDotSize = CGSizeMake(13, 4);
        CGFloat layerHeight = 40;
//        CGFloat pageScollViewW = self.bounds.size.width;
//        CGFloat pageScollViewH = self.bounds.size.height;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(0, 200)];
        [path addQuadCurveToPoint:CGPointMake(ScreenWidth, 200) controlPoint:CGPointMake(ScreenWidth / 2, 200 - layerHeight)];
        layer.path = path.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        NSMutableArray *imageMutableArray = [NSMutableArray array];
        for (int i = 1; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cycle_%02d.jpg",i];
            [imageMutableArray addObject:imageName];
        }
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) imageNamesGroup:imageMutableArray];
    }
    return _cycleScrollView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
