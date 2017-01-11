//
//  CModelView.m
//  BoxDemo
//
//  Created by Kaige-SSD on 16/1/13.
//  Copyright © 2016年 Kaige. All rights reserved.
//

#import "CModelView.h"

#import <SceneKit/SceneKit.h>

@interface CModelView()
{
    float width, height, depth;
    
}

@end

@implementation CModelView

-(void)initModel
{
    /*SCNScene *scene = [SCNScene scene];
    
    // 打印机大小(mm)
    width = 205, height = 205, depth = 200;
    
    // board geometry
    SCNBox *boardGeometry = [SCNBox boxWithWidth:width height:height length:1.0f chamferRadius:0];
    boardGeometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"line_board.png"];
    SCNNode *boardNode = [SCNNode nodeWithGeometry:boardGeometry];
    boardNode.position = SCNVector3Make(0, 0, -1.1);
    [scene.rootNode addChildNode:boardNode];
    
    // box geometry
    SCNBox *boxGeometry = [SCNBox boxWithWidth:width height:height length:depth chamferRadius:0];
    boxGeometry.firstMaterial.diffuse.contents = [HEXCOLOR3B(0x019df0) colorWithAlphaComponent:0.25];
    boxGeometry.firstMaterial.specular.contents = [UIColor whiteColor];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
    boxNode.position = SCNVector3Make(0, 0, depth/2);
    [scene.rootNode addChildNode:boxNode];
    
    //direction geometry
    float dirWidth = width/3;
    for (int i = 0; i < 3; i++) {
        SCNBox *box = [SCNBox boxWithWidth:dirWidth height:2 length:2 chamferRadius:0];
        SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
        boxNode.pivot = SCNMatrix4MakeTranslation(-dirWidth/2, -1, -1);
        SCNMatrix4 mat4;
        SCNMatrix4 mat4_t = SCNMatrix4MakeTranslation(-width/2, -height/2, -1);
        if (i == 1) {
            SCNMatrix4 mat4_r = SCNMatrix4MakeRotation(MCP_DEGREES_TO_RADIANS(90), 0, 0, 1);
            mat4_t.m41 += 2;
            mat4 = SCNMatrix4Mult(mat4_r, mat4_t);
        }
        else if (i == 2) {
            SCNMatrix4 mat4_r = SCNMatrix4MakeRotation(MCP_DEGREES_TO_RADIANS(-90), 0, 1, 0);
            mat4_t.m41 += 2;
            mat4 = SCNMatrix4Mult(mat4_r, mat4_t);
            
        }
        else {
            mat4 = mat4_t;
        }
        boxNode.transform = mat4;
        [scene.rootNode addChildNode:boxNode];
    }
    
    // model geometry ctm
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mao.stl.ctm" ofType:nil];
    [CCTMImporter importFile:path complete:^(SCNNode *node, NSData *data) {
        self.theModelNode = node;
        self.theVertices = data;
        //SCNVector3 v3Min, v3Max;
        //[_theModelNode getBoundingBoxMin:&v3Min max:&v3Max];
        //_theModelNode.pivot = SCNMatrix4MakeTranslation((v3Max.x+v3Min.x)/2, (v3Max.y+v3Min.y)/2, v3Min.z);
        [scene.rootNode addChildNode:_theModelNode];
        
        [self refreshSize:SCNVector3Make(1, 1, 1)];
        
        [self initModelTransView];
    }];
    
    
    // create and add a camera to the scene
    SCNCamera *camera = [SCNCamera camera];
    camera.zFar = depth*4;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, depth*3);
    [scene.rootNode addChildNode:cameraNode];
    self.theCamera = cameraNode;
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor colorWithWhite:0.1 alpha:1.0];
    // ambientLightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the SCNView
    SCNView *scnView = self.scnView;
    // set the scene to the view
    scnView.scene = scene;
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
    // show statistics such as fps and timing information
    // scnView.showsStatistics = YES;
    // configure the view
    scnView.autoenablesDefaultLighting = YES;
    scnView.backgroundColor = HEXCOLOR3B(0xcccccc);
    
    SCNMatrix4 mat4_r = SCNMatrix4MakeRotation(MCP_DEGREES_TO_RADIANS(45), 1, 0, 0);
    SCNMatrix4 mat4_t = SCNMatrix4MakeTranslation(0, 0, depth*3);
    self.scnView.pointOfView.transform = SCNMatrix4Mult(mat4_t, mat4_r);*/
}

@end
