//
//  ModelTransView.m
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/28.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import "ModelTransView.h"
#import "CMSliderView.h"

#import "GameViewController.h"

#import "UIView+AutoLayout.h"

#define kCurrentScreenWidth [UIScreen mainScreen].bounds.size.width

//#define INFINITY 9999

NS_INLINE SCNVector3 SCNVector3Add(SCNVector3 v1, SCNVector3 v2) {
    return SCNVector3Make(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z);
}
//NS_INLINE SCNVector3 SCNVector3Minus(SCNVector3 v1, SCNVector3 v2) {
//    return SCNVector3Make(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z);
//}
NS_INLINE SCNVector3 SCNVector3Mult(SCNVector3 v, CGFloat aScale) {
    return SCNVector3Make(v.x*aScale, v.y*aScale, v.z*aScale);
}

//*****************History************************
@implementation History

@end
//*****************History End************************

@interface ModelTransView() <CMSliderDelegate>
{
    BOOL prevLockState;
    
    SCNVector3 vMin, vMax, vScale;
    //SCNVector3 vMin, vMax;
    
    SCNMatrix4 mat4t, mat4s, mat4r, mat4auto;
}
@property (nonatomic, strong) NSMutableArray *histories;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) UIButton *prevBtn;
@property (nonatomic, weak) IBOutlet UIButton *btnFront;
@property (nonatomic, weak) IBOutlet UIButton *btnUndo;
@property (nonatomic, weak) IBOutlet UIButton *btnLock;

@end

@implementation ModelTransView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initData
{
    mat4t = mat4s = mat4r = mat4auto = self.ctrl.theModelNode.transform;
    [self.ctrl.theModelNode getBoundingBoxMin:&vMin max:&vMax];
    vScale = SCNVector3Make(1, 1, 1);
    
    self.prevBtn = self.btnFront;
    [self.btnUndo setEnabled:NO];
    
    self.histories = [NSMutableArray array];
    
    [self initScrollView];
}

- (void)initScrollView
{
    for (int i = 0; i < 3; i++) {
        CMSliderView *sliderView = [CMSliderView loadView];
        sliderView.delegate = self;
        sliderView.transView = self;
        sliderView.type = i;
        [self.containerView addSubview:sliderView];
        
        [sliderView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kCurrentScreenWidth*i];
        [sliderView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [sliderView autoSetDimension:ALDimensionWidth toSize:kCurrentScreenWidth];
        [sliderView autoSetDimension:ALDimensionHeight toSize:self.containerView.frame.size.height];
        if (i == 2) {
            [sliderView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        }
    }
}

- (void)setTransType:(NSInteger)type
{
    if (type == kSliderScale) {
        self.bLockValue = YES;
        prevLockState = self.btnLock.selected;
        [self.btnLock setSelected:NO];
        [self.btnLock setEnabled:NO];
    }
    else {
        self.bLockValue = prevLockState;
        [self.btnLock setSelected:prevLockState];
        [self.btnLock setEnabled:YES];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

- (void)addHistory:(History *)history
{
    [self.histories addObject:history];
    
    [self.btnUndo setEnabled:YES];
}

- (IBAction)doTopClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 3:
            if (self.histories.count > 0)
            {
                NSUInteger end = _histories.count-1;
                History *history = [self.histories objectAtIndex:end];
                CMSliderView *slider = [self.containerView.subviews objectAtIndex:history.type];
                [slider undoSlider:history.vector];
                [self sliderViewValueChange:history.type vector:history.vector];
                if (history.type != kSliderTranslation) {
                    [self sliderViewTouchUpInside:history.type vector:history.vector];
                }
                
                [self.histories removeObjectAtIndex:end];
                if (self.histories.count == 0) {
                    [self.btnUndo setEnabled:NO];
                }
            }
            break;
        case 4:
            self.bLockValue = !self.bLockValue;
            btn.selected = !btn.selected;
            break;
        default:
        {
            [self.prevBtn setSelected:NO];
            [btn setSelected:YES];
            self.prevBtn = btn;
            if (self.ctrl) {
                int direction = (int)btn.tag;
                [self.ctrl changeCameraDirection:direction];
            }
        }
            break;
    }
}

#pragma mark - SliderView Delegate
- (void)sliderViewValueChange:(NSInteger)type vector:(SCNVector3)vector
{
    switch (type) {
        case kSliderTranslation:
        {
            self.vTranslation = vector;
            mat4t = SCNMatrix4MakeTranslation(vector.x, vector.y, vector.z);
        }
            break;
        case kSliderRotate:
        {
            CGFloat anglex = vector.x*M_PI/180.0;
            
            SCNMatrix4 mat4x = SCNMatrix4MakeRotation(anglex, 1, 0, 0);
            
            CGFloat angley = vector.y*M_PI/180.0;
            SCNMatrix4 mat4y = SCNMatrix4MakeRotation(angley, 0, 1, 0);
            
            CGFloat anglez = vector.z*M_PI/180.0;
            SCNMatrix4 mat4z = SCNMatrix4MakeRotation(anglez, 0, 0, 1);
            
            mat4r = SCNMatrix4Mult(SCNMatrix4Mult(mat4x, mat4y), mat4z);
        }
            break;
            
        case kSliderScale:
        default:
        {
            vScale = vector;
            [self.ctrl refreshSize:vector];
            mat4s = SCNMatrix4MakeScale(vector.x, vector.y, vector.z);
        }
            break;
    }
    SCNMatrix4 mat4 = SCNMatrix4Mult(SCNMatrix4Mult(mat4r, mat4s), mat4t);
    
    self.ctrl.theModelNode.transform = SCNMatrix4Mult(mat4, mat4auto);;
}

- (void)sliderViewTouchUpInside:(NSInteger)type vector:(SCNVector3)vector
{
    if (type == kSliderRotate)
        [self recalcModelSize:SCNVector3Mult(vector, M_PI/180.0)];
    // printf("%f, %f, %f\n", vMin.x, vMin.y, vMin.z);
    // printf("%f, %f, %f\n\n", vMax.x, vMax.y, vMax.z);
    SCNMatrix4 mat4 = SCNMatrix4Mult(SCNMatrix4Mult(mat4r, mat4s), mat4t);
    SCNVector3 vCenter = SCNVector3Mult(SCNVector3Add(vMax, vMin), 0.5);
    mat4auto = SCNMatrix4MakeTranslation(-vCenter.x*vScale.x, -vCenter.y*vScale.y, -vMin.z*vScale.z);
    self.ctrl.theModelNode.transform = SCNMatrix4Mult(mat4, mat4auto);
}

- (void)recalcModelSize:(SCNVector3)angle
{
    int len = 0;
    size_t size = sizeof(SCNVector3);
    
    vMin = SCNVector3Make(INFINITY, INFINITY, INFINITY);
    vMax = SCNVector3Make(-INFINITY, -INFINITY, -INFINITY);
    
    while (true) {
        SCNVector3 v, v1;
        [self.ctrl.theVertices getBytes:&v1 range:NSMakeRange(len, size)];
        
        v = v1;
        //rotate with x
        if (angle.x != 0) {
            v1.y = v.y*cosf(angle.x) - v.z*sinf(angle.x);
            v1.z = v.z*cosf(angle.x) + v.y*sinf(angle.x);
        }
        v = v1;
        //rotate with y
        if (angle.y != 0) {
            v1.z = v.z*cosf(angle.y) - v.x*sinf(angle.y);
            v1.x = v.x*cosf(angle.y) + v.z*sinf(angle.y);
        }
        v = v1;
        //rotate with z
        if (angle.z != 0) {
            v1.x = v.x*cosf(angle.z) - v.y*sinf(angle.z);
            v1.y = v.y*cosf(angle.z) + v.x*sinf(angle.z);
        }
        
        vMin.x = MIN(vMin.x, v1.x);
        vMin.y = MIN(vMin.y, v1.y);
        vMin.z = MIN(vMin.z, v1.z);
        vMax.x = MAX(vMax.x, v1.x);
        vMax.y = MAX(vMax.y, v1.y);
        vMax.z = MAX(vMax.z, v1.z);
        
        len += size;
        if (len >= self.ctrl.theVertices.length)
            break;
    }
    
}

@end

