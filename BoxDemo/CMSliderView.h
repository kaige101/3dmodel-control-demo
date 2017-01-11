//
//  CSliderView.h
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/16.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@protocol CMSliderDelegate <NSObject>

-(void)sliderViewValueChange:(int)type vector:(SCNVector3)vector;
-(void)sliderViewTouchUpInside:(int)type vector:(SCNVector3)vector;

@end

enum {
    kSliderTranslation,
    kSliderRotate,
    kSliderScale
};

@class ModelTransView;

@interface CMSliderView : UIView

+(CMSliderView *)loadView;

-(void)undoSlider:(SCNVector3)vector;

@property (nonatomic, weak) ModelTransView *transView;

@property (nonatomic, assign) int type;

@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;

@property (nonatomic, weak) id<CMSliderDelegate> delegate;

@end
