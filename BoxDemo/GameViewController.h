//
//  GameViewController.h
//  BoxDemo
//

//  Copyright (c) 2015年 Kaige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@class ModelTransView;
@class CModelView;

@interface GameViewController : UIViewController

@property (nonatomic, weak) IBOutlet SCNView *scnView;
@property (nonatomic, weak) SCNNode *theModelNode;
@property (nonatomic, strong) NSData *theVertices;

@property (nonatomic, strong) IBOutlet CModelView *modelView;
@property (nonatomic, weak) IBOutlet ModelTransView *modelTrans;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

- (void)changeCameraDirection:(NSInteger)direction;
- (void)refreshSize:(SCNVector3)vector;

@end
