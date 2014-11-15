//
//  DraggableView.m
//  draggable
//
//  Created by InoueYuta on 2014/11/04.
//  Copyright (c) 2014年 InoueYuta. All rights reserved.
//

#import "DraggableView.h"

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    [self loadImageAndStyle];
    UILabel* peTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 290, 30)];
    peTitleLabel.text = [NSString stringWithFormat:@"誰が"];
    peTitleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel* scTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 116, 290, 30)];
    scTitleLabel.text = [NSString stringWithFormat:@"いつ"];
    scTitleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel* puTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 215, 290, 30)];
    puTitleLabel.text = [NSString stringWithFormat:@"なんのために"];
    puTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.personLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 290, 0)];
    self.sceneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 144, 290, 0)];
    self.purposeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 253, 290, 0)];
    [self addSubview:peTitleLabel];
    [self addSubview:scTitleLabel];
    [self addSubview:puTitleLabel];
    [self addSubview:self.personLabel];
    [self addSubview:self.sceneLabel];
    [self addSubview:self.purposeLabel];
    
    self.overlayView = [[OverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    
    return self;
}

-(void)refreshContent:(NSMutableDictionary *)dic{
    self.personLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"person"]objectForKey:@"title" ]];
    self.sceneLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"scene"] objectForKey:@"title"]];
    self.purposeLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"purpose"] objectForKey:@"title"]];
    self.personLabel.textAlignment = NSTextAlignmentCenter;
    self.personLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.sceneLabel.textAlignment = NSTextAlignmentCenter;
    self.sceneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.purposeLabel.textAlignment = NSTextAlignmentCenter;
    self.purposeLabel.lineBreakMode = NSLineBreakByWordWrapping;

    
    [self setLabelSize:self.personLabel];
    [self setLabelSize:self.sceneLabel];
    [self setLabelSize:self.purposeLabel];
}

-(void)setLabelSize:(UILabel*)label{
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    CGRect frame = label.frame;
    frame.size.height = size.height;
    label.frame = frame;
}

- (void)loadImageAndStyle
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 322)];
    imageView.image = [UIImage imageNamed:@"mix_card"];
    [self addSubview:imageView];
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:gestureRecognizer.view.superview].x;
    CGFloat yDistance = [gestureRecognizer translationInView:gestureRecognizer.view.superview].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            
            if(xDistance>0.0){
                self.overlayView.mode = OverlayModeRight;
            } else if(xDistance<=-0.0){
                self.overlayView.mode = OverlayModeLeft;
            }
            CGFloat overlayStrength = MIN(fabsf(xDistance) /80,0.99);
            self.overlayView.alpha = overlayStrength;
            self.alpha = MAX(1-(fabsf(xDistance)/160),0.4);
            NSLog(@"%f %f",self.overlayView.alpha,self.alpha);
            break;
        };
        case UIGestureRecognizerStateEnded: {
            NSLog(@"%f",xDistance);
            if(xDistance>100.0){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadIdea" object:nil];
            } else if(xDistance<=-100.0){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"popIdea" object:nil];
            }
            [self resetViewPositionAndTransformations];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.overlayView.alpha = 0;
                         self.alpha = 1;
                     }];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}
@end