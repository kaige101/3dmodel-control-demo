//
//  CSliderView.m
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/16.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import "CMSliderView.h"
#import <objc/runtime.h>

#import "ModelTransView.h"

#define TAG_X_SUB   0
#define TAG_X_PLUS  1
#define TAG_Y_SUB   2
#define TAG_Y_PLUS  3
#define TAG_Z_SUB   4
#define TAG_Z_PLUS  5

@interface CMSliderView()
{
    CGFloat x;
    CGFloat y;
    CGFloat z;
    
    CGFloat unit;
}

@property (nonatomic, weak) IBOutlet UISlider *sliderX;
@property (nonatomic, weak) IBOutlet UISlider *sliderY;
@property (nonatomic, weak) IBOutlet UISlider *sliderZ;

@property (nonatomic, strong) History *curHistory;

@end

@implementation CMSliderView

+ (CMSliderView *)loadView
{
    CMSliderView *view = [[[NSBundle mainBundle] loadNibNamed:@"CMSliderView" owner:nil options:nil] objectAtIndex:0];
    return view;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)undoSlider:(SCNVector3)vector
{
    x = vector.x;
    y = vector.y;
    z = vector.z;
    self.sliderX.value = x;
    self.sliderY.value = y;
    self.sliderZ.value = z;
}

- (void)setType:(CMSlider)type
{
    _type = type;
    NSArray *array = @[self.sliderX, self.sliderY, self.sliderZ];
    switch (self.type) {
        case kSliderTranslation:
            for (UISlider *slider in array) {
                slider.value = 0;
                slider.minimumValue = -100;
                slider.maximumValue = 100;
            }
            unit = 10;
            break;
            
        case kSliderRotate:
            for (UISlider *slider in array) {
                slider.value = 0;
                slider.minimumValue = -180;
                slider.maximumValue = 180;
            }
            unit = 30;
            break;
            
        case kSliderScale:
        default:
            for (UISlider *slider in array) {
                slider.value = 1;
                slider.minimumValue = 0.1;
                slider.maximumValue = 3;
            }
            unit = 0.1;
            break;
    }
    
    x = self.sliderX.value;
    y = self.sliderY.value;
    z = self.sliderZ.value;
}

- (void)lockValue:(float)value
{
    if (self.transView.bLockValue) {
        x = y = z = value;
        self.sliderX.value = value;
        self.sliderY.value = value;
        self.sliderZ.value = value;
    }
}
- (IBAction)valueChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    switch ([sender tag]) {
        case 0:
            x = slider.value;
            [self lockValue:x];
            break;
        case 1:
            y = slider.value;
            [self lockValue:y];
            break;
        default:
            z = slider.value;
            [self lockValue:z];
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderViewValueChange:vector:)]) {
        [self.delegate sliderViewValueChange:_type vector:SCNVector3Make(x, y, z)];
    }
}

- (void)calculateHistory
{
    History *history = [[History alloc] init];
    history.type = self.type;
    history.vector = SCNVector3Make(x, y, z);
    self.curHistory = history;
}
- (IBAction)doTouchDown:(id)sender
{
    [self calculateHistory];
}
- (IBAction)doTouchUpInside:(id)sender
{
    if (self.curHistory) {
        if (_curHistory.vector.x != x || _curHistory.vector.y != y || _curHistory.vector.z != z) {
            [self.transView addHistory:self.curHistory];
        }
        self.curHistory = nil;
    }
    
    if (_type != kSliderTranslation) {
        if (_type == kSliderRotate && sender != nil) {
            UISlider *slider = (UISlider *)sender;
            int value = floorf(slider.value);
            int iUnit = floorf(unit);
            int remain = value % iUnit;
            if (remain >= iUnit/2.0) {
                value += iUnit-remain;
            }
            else {
                value -= remain;
            }
            
            slider.value = value;
            [self valueChange:sender];
        }
        
        if ([self.delegate respondsToSelector:@selector(sliderViewTouchUpInside:vector:)]) {
            [self.delegate sliderViewTouchUpInside:_type vector:SCNVector3Make(x, y, z)];
        }
    }
}

- (IBAction)doSymbolClick:(id)sender
{
    [self calculateHistory];
    
    UISlider *slider = nil;
    int symbol = 1;
    switch ([sender tag]) {
        case TAG_X_SUB:
            symbol = -1;
            slider = self.sliderX;
            break;
        case TAG_X_PLUS:
            slider = self.sliderX;
            break;
        case TAG_Y_SUB:
            symbol = -1;
            slider = self.sliderY;
            break;
        case TAG_Y_PLUS:
            slider = self.sliderY;
            break;
        case TAG_Z_SUB:
            symbol = -1;
            slider = self.sliderZ;
            break;
        case TAG_Z_PLUS:
        default:
            slider = self.sliderZ;
            break;
    }
    
    slider.value += symbol*unit;
    [self valueChange:slider];
    
    [self doTouchUpInside:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
