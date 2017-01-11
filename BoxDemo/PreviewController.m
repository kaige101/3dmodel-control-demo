//
//  PreviewController.m
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/14.
//  Copyright (c) 2015年 Kaige. All rights reserved.
//

#import "PreviewController.h"

#import "CCTMImporter.h"

#define kCurrentScreenWidth [UIScreen mainScreen].bounds.size.width
#define MCP_DEGREES_TO_RADIANS(c) (c*M_PI/180.0)

//十六进制颜色转换
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define HEXCOLOR3B(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]

@interface PreviewController()
{
    BOOL bIsBottomShow;
    
    UIButton *btnPrev;
    
    IBOutlet UILabel *labSizeX;
    IBOutlet UILabel *labSizeY;
    IBOutlet UILabel *labSizeZ;
    
    CGFloat width, height, length;
}

@property (nonatomic, weak) SCNNode *theCamera;

@end

@implementation PreviewController

+ (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

+ (BOOL)isFileExistAtPath:(NSString *)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

- (void)enumPath:(NSString *)homePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:homePath];
    
    NSString *path;
    NSLog(@"1.Contents of %@:",homePath);
    while ((path = [dirEnum nextObject]) != nil)
    {
        NSLog(@"%@",path);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [self enumPath:documentsDirectory];
    [self enumPath:NSHomeDirectory()];
    
    // self.modelView = [[CModelView alloc] init];
    
    SCNScene *scene = [SCNScene scene];
    
    // 打印机大小(mm)
    width = 205, height = 205, length = 200;
    
    //Square, Circular
    NSString *printer_shape = @"Circular";
    if ([printer_shape isEqualToString:@"Circular"]) {
        [self initCylinder:scene];
    }
    else {
        [self initCubeBox:scene];
    }
    
    // model geometry ctm
    NSString *path = nil;
    if (self.fileUrl != nil) {
        path = self.fileUrl.path;
    }
    else {
        path = [[NSBundle mainBundle] pathForResource:@"ka.stl.ctm" ofType:nil];
    }
    NSLog(@"file path:%@", path);
    
    [CCTMImporter importFile:path complete:^(SCNNode *node, NSData *data) {
        self.theModelNode = node;
        self.theVertices = data;
        //SCNVector3 v3Min, v3Max;
        //[_theModelNode getBoundingBoxMin:&v3Min max:&v3Max];
        //_theModelNode.pivot = SCNMatrix4MakeTranslation((v3Max.x+v3Min.x)/2, (v3Max.y+v3Min.y)/2, v3Min.z);
        [scene.rootNode addChildNode:_theModelNode];
        
        [self refreshSize:SCNVector3Make(1, 1, 1)];
    }];
    
    
    // create and add a camera to the scene
    SCNCamera *camera = [SCNCamera camera];
    camera.zFar = length*4;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, length*3);
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
    scnView.backgroundColor = HEXCOLOR3B(0xf2f2f2);
    
    SCNMatrix4 mat4_r = SCNMatrix4MakeRotation(MCP_DEGREES_TO_RADIANS(45), 1, 0, 0);
    SCNMatrix4 mat4_t = SCNMatrix4MakeTranslation(0, 0, length*3);
    self.scnView.pointOfView.transform = SCNMatrix4Mult(mat4_t, mat4_r);
}

- (void)initCylinder:(SCNScene *)scene
{
    // board geometry
    SCNGeometry *boardGeometry = [SCNCylinder cylinderWithRadius:width/2 height:1.0f];
    boardGeometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"line_board.png"];
    SCNNode *boardNode = [SCNNode nodeWithGeometry:boardGeometry];
    boardNode.position = SCNVector3Make(0, 0, -1.1);
    boardNode.rotation = SCNVector4Make(1, 0, 0, MCP_DEGREES_TO_RADIANS(90));
    [scene.rootNode addChildNode:boardNode];
    
    // box geometry
    SCNGeometry *boxGeometry = [SCNCylinder cylinderWithRadius:width/2 height:length];
    boxGeometry.firstMaterial.diffuse.contents = HEXCOLOR3B(0xc5efff);//散射光
    // boxGeometry.firstMaterial.specular.contents = HEXCOLOR3B(0xc5efff);//反射光
    // boxGeometry.firstMaterial.ambient.contents = HEXCOLOR3B(0xc5efff);//环境光
    SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
    boxNode.opacity = 0.5f;
    boxNode.position = SCNVector3Make(0, 0, length/2);
    boxNode.rotation = SCNVector4Make(1, 0, 0, MCP_DEGREES_TO_RADIANS(90));
    [scene.rootNode addChildNode:boxNode];
}

- (void)initCubeBox:(SCNScene *)scene
{
    // board geometry
    SCNBox *boardGeometry = [SCNBox boxWithWidth:width height:height length:1.0f chamferRadius:0];//width = x, height = y, length = z;
    boardGeometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"line_board.png"];
    SCNNode *boardNode = [SCNNode nodeWithGeometry:boardGeometry];
    boardNode.position = SCNVector3Make(0, 0, -1.1);
    [scene.rootNode addChildNode:boardNode];
    
    // box geometry
    SCNBox *boxGeometry = [SCNBox boxWithWidth:width height:height length:length chamferRadius:0];
    boxGeometry.firstMaterial.diffuse.contents = HEXCOLOR3B(0xc5efff);//散射光
    // boxGeometry.firstMaterial.specular.contents = HEXCOLOR3B(0xc5efff);//反射光
    // boxGeometry.firstMaterial.ambient.contents = HEXCOLOR3B(0xc5efff);//环境光
    SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
    boxNode.opacity = 0.5f;
    boxNode.position = SCNVector3Make(0, 0, length/2);
    [scene.rootNode addChildNode:boxNode];
    
    //direction geometry
    CGFloat dirWidth = width/3;
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
}

- (void)refreshSize:(SCNVector3)vector
{
    SCNVector3 v3Min, v3Max;
    [_theModelNode getBoundingBoxMin:&v3Min max:&v3Max];
    
    labSizeX.text = [NSString stringWithFormat:@"SizeX:%0.2fmm", fabsf(v3Max.x-v3Min.x)*vector.x];
    labSizeY.text = [NSString stringWithFormat:@"SizeY:%0.2fmm", fabsf(v3Max.y-v3Min.y)*vector.y];
    labSizeZ.text = [NSString stringWithFormat:@"SizeZ:%0.2fmm", fabsf(v3Max.z-v3Min.z)*vector.z];
}

- (void)printMatrix4:(SCNMatrix4)mat4
{
    printf("%f, %f, %f, %f \n%f, %f, %f, %f \n%f, %f, %f, %f \n%f, %f, %f, %f\n\n\n",
           mat4.m11, mat4.m12, mat4.m13, mat4.m14,
           mat4.m21, mat4.m22, mat4.m23, mat4.m24,
           mat4.m31, mat4.m32, mat4.m33, mat4.m34,
           mat4.m41, mat4.m42, mat4.m43, mat4.m44);
}

- (IBAction)doCloseClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
