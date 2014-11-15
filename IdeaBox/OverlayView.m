//
//  OverlayView.m
//  draggable
//
//  Created by InoueYuta on 2014/11/04.
//  Copyright (c) 2014年 InoueYuta. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(!self)return nil;
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mix_btn_unlike"]];
    [self addSubview:self.imageView];
    return self;
}

-(void)setMode:(OverlayMode)mode{
    if(_mode==mode)return;
    _mode = mode;
    if(mode == OverlayModeLeft){
        self.imageView.image = [UIImage imageNamed:@"mix_btn_unlike"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"mix_btn_like"];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(50, 50, 150, 100);
}
@end
