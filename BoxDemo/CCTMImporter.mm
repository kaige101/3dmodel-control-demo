//
//  CCTMImporter.m
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/29.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import "CCTMImporter.h"

#import "meshio.h"

/// Calculate smooth per-vertex normals
/*void MyCalculateNormals(Mesh& mesh)
{
    // Clear the smooth normals
    mesh.mNormals.resize(mesh.mIndices.size());
    for(unsigned int i = 0; i < mesh.mNormals.size(); ++ i)
        mesh.mNormals[i] = Vector3(0.0f, 0.0f, 0.0f);
    
    // Calculate sum of the flat normals of the neighbouring triangles
    unsigned long triCount = mesh.mIndices.size() / 3;
    for(unsigned int i = 0; i < triCount; ++ i)
    {
        // Calculate the weighted flat normal for this triangle
        Vector3 v1 = mesh.mVertices[mesh.mIndices[i * 3 + 1]] - mesh.mVertices[mesh.mIndices[i * 3]];
        Vector3 v2 = mesh.mVertices[mesh.mIndices[i * 3 + 2]] - mesh.mVertices[mesh.mIndices[i * 3]];
        Vector3 flatNormal = Cross(v1, v2);
        flatNormal = Normalize(flatNormal);
        
        // ...and add it to all three triangle vertices' smooth normals
        for(unsigned int j = 0; j < 3; ++ j)
            mesh.mNormals[mesh.mIndices[i * 3 + j]] += flatNormal;
    }
    
    // Normalize all the smooth normals
    for(unsigned int i = 0; i < mesh.mNormals.size(); ++ i) {
        mesh.mNormals[i] = Normalize(mesh.mNormals[i]);
    }
}

SCNNode* test()
{
    float VertexData[216] =
    {
        // Data layout for each line below is:
        // positionX, positionY, positionZ,     normalX, normalY, normalZ,
        30.0f, -30.0f, -30.0f,        1.0f, 0.0f, 0.0f,
        30.0f, 30.0f, -30.0f,         1.0f, 0.0f, 0.0f,
        30.0f, -30.0f, 30.0f,         1.0f, 0.0f, 0.0f,
        30.0f, -30.0f, 30.0f,         1.0f, 0.0f, 0.0f,
        30.0f, 30.0f, -30.0f,          1.0f, 0.0f, 0.0f,
        30.0f, 30.0f, 30.0f,         1.0f, 0.0f, 0.0f,
        
        30.0f, 30.0f, -30.0f,         0.0f, 1.0f, 0.0f,
        -30.0f, 30.0f, -30.0f,        0.0f, 1.0f, 0.0f,
        30.0f, 30.0f, 30.0f,          0.0f, 1.0f, 0.0f,
        30.0f, 30.0f, 30.0f,          0.0f, 1.0f, 0.0f,
        -30.0f, 30.0f, -30.0f,        0.0f, 1.0f, 0.0f,
        -30.0f, 30.0f, 30.0f,         0.0f, 1.0f, 0.0f,
        
        -30.0f, 30.0f, -30.0f,        -1.0f, 0.0f, 0.0f,
        -30.0f, -30.0f, -30.0f,       -1.0f, 0.0f, 0.0f,
        -30.0f, 30.0f, 30.0f,         -1.0f, 0.0f, 0.0f,
        -30.0f, 30.0f, 30.0f,         -1.0f, 0.0f, 0.0f,
        -30.0f, -30.0f, -30.0f,       -1.0f, 0.0f, 0.0f,
        -30.0f, -30.0f, 30.0f,        -1.0f, 0.0f, 0.0f,
        
        -30.0f, -30.0f, -30.0f,       0.0f, -1.0f, 0.0f,
        30.0f, -30.0f, -30.0f,        0.0f, -1.0f, 0.0f,
        -30.0f, -30.0f, 30.0f,        0.0f, -1.0f, 0.0f,
        -30.0f, -30.0f, 30.0f,        0.0f, -1.0f, 0.0f,
        30.0f, -30.0f, -30.0f,        0.0f, -1.0f, 0.0f,
        30.0f, -30.0f, 30.0f,         0.0f, -1.0f, 0.0f,
        
        30.0f, 30.0f, 30.0f,          0.0f, 0.0f, 1.0f,
        -30.0f, 30.0f, 30.0f,         0.0f, 0.0f, 1.0f,
        30.0f, -30.0f, 30.0f,         0.0f, 0.0f, 1.0f,
        30.0f, -30.0f, 30.0f,         0.0f, 0.0f, 1.0f,
        -30.0f, 30.0f, 30.0f,         0.0f, 0.0f, 1.0f,
        -30.0f, -30.0f, 30.0f,        0.0f, 0.0f, 1.0f,
        
        30.0f, -30.0f, -30.0f,        0.0f, 0.0f, -1.0f,
        -30.0f, -30.0f, -30.0f,       0.0f, 0.0f, -1.0f,
        30.0f, 30.0f, -30.0f,         0.0f, 0.0f, -1.0f,
        30.0f, 30.0f, -30.0f,         0.0f, 0.0f, -1.0f,
        -30.0f, -30.0f, -30.0f,       0.0f, 0.0f, -1.0f,
        -30.0f, 30.0f, -30.0f,        0.0f, 0.0f, -1.0f
    };
    Mesh mesh;
    int m = 0;
    for (int i = 0; i < 216/6; i++) {
        Vector3 v = Vector3(VertexData[i*6], VertexData[i*6+1], VertexData[i*6+2]);
        Vector3 vn = Vector3(VertexData[i*6+3], VertexData[i*6+4], VertexData[i*6+5]);
        
        int index = -1;
        for (int j = 0; j < mesh.mVertices.size(); j++) {
            Vector3 v3 = mesh.mVertices[j];
            if (v3.x == v.x && v3.y == v.y && v3.z == v.z) {
                index = j;
            }
        }
        if (index != -1) {
            //mesh.mIndices[i] = index;
            mesh.mIndices.push_back(index);
            mesh.mNormals.push_back(vn);
        }
        else {
            mesh.mIndices.push_back((int)mesh.mVertices.size());
            mesh.mVertices.push_back(v);
            mesh.mNormals.push_back(vn);
            
            //mesh.mVertices[m] = v;
            //mesh.mIndices[i] = m;
            m++;
        }
    }
   // MyCalculateNormals(mesh);
    
    NSMutableData *theVertices = [NSMutableData data];
    NSMutableData *theNormals = [NSMutableData data];
    NSMutableData *theElements = [NSMutableData data];
    
//    [self convertToData:mesh vertices:theVertices normals:theNormals elements:theElements];
//    long theIndicesSize = mesh.mIndices.size()/3;
//    long theVecticesSize = theIndicesSize*3;
//    long theNormalSize = theVecticesSize;
    
    [self convertToData1:mesh vertices:theVertices normals:theNormals elements:theElements];
    long theIndicesSize = mesh.mIndices.size()/3;
    long theVecticesSize = mesh.mVertices.size()*3;
    long theNormalSize = mesh.mVertices.size()*3;
    
    SCNGeometrySource *theVerticesSource = [SCNGeometrySource geometrySourceWithData:theVertices semantic:SCNGeometrySourceSemanticVertex vectorCount:theVecticesSize floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(Vector3)];
    SCNGeometrySource *theNormalsSource = [SCNGeometrySource geometrySourceWithData:theNormals semantic:SCNGeometrySourceSemanticNormal vectorCount:theNormalSize floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(Vector3)];
    
    SCNGeometryElement *theElement = [SCNGeometryElement geometryElementWithData:theElements primitiveType:SCNGeometryPrimitiveTypeTriangles primitiveCount:theIndicesSize bytesPerIndex:sizeof(int)];
    
    SCNGeometry *theGeometry = [SCNGeometry geometryWithSources:@[ theVerticesSource, theNormalsSource ] elements:@[ theElement]];
    SCNNode *theNode = [SCNNode nodeWithGeometry:theGeometry];
    
    return theNode;
    
}*/

@implementation CCTMImporter

+(void)importFile:(NSString *)path complete:(void (^)(SCNNode *, NSData *))complete
{
    [[[CCTMImporter alloc] init] importFile:path complete:complete];
}

-(void)importFile:(NSString *)path complete:(void (^)(SCNNode *, NSData *))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Mesh mesh;
        try {
            ImportMesh(path.UTF8String, &mesh);
        } catch (ctm_error error) {
            NSLog(@"error: %s", error.what());
        } catch (const std::runtime_error & error) {
            NSLog(@"error: %s", error.what());
        }
        
        NSMutableData *theVertices = [NSMutableData data];
        NSMutableData *theNormals = [NSMutableData data];
        NSMutableData *theElements = [NSMutableData data];
        
        NSLog(@"vc=%lu,nc=%lu,ic=%lu", mesh.mVertices.size(), mesh.mNormals.size(), mesh.mIndices.size());
        
        long theIndicesSize, theVecticesSize, theNormalSize;
        //当顶点数大于5K时，使用合并顶点后的索引显示模型
        if (mesh.mIndices.size() >= 5000) {
            [self convertToData:mesh vertices:theVertices normals:theNormals elements:theElements];
            
            theIndicesSize = mesh.mIndices.size()/3;
            theVecticesSize = mesh.mVertices.size();
            theNormalSize = theVecticesSize;
        }
        else {
            [self convertToData1:mesh vertices:theVertices normals:theNormals elements:theElements];
            
            theIndicesSize = mesh.mIndices.size()/3;
            theVecticesSize = theIndicesSize*3;
            theNormalSize = theVecticesSize;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SCNGeometrySource *theVerticesSource = [SCNGeometrySource geometrySourceWithData:theVertices semantic:SCNGeometrySourceSemanticVertex vectorCount:theVecticesSize floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(Vector3)];
            SCNGeometrySource *theNormalsSource = [SCNGeometrySource geometrySourceWithData:theNormals semantic:SCNGeometrySourceSemanticNormal vectorCount:theNormalSize floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(Vector3)];
            
            SCNGeometryElement *theElement = [SCNGeometryElement geometryElementWithData:theElements primitiveType:SCNGeometryPrimitiveTypeTriangles primitiveCount:theIndicesSize bytesPerIndex:sizeof(int)];
            
            SCNGeometry *theGeometry = [SCNGeometry geometryWithSources:@[ theVerticesSource, theNormalsSource ] elements:@[ theElement ]];
            SCNNode *theNode = [SCNNode nodeWithGeometry:theGeometry];
            
            complete(theNode, theVertices);
            
        });
    });
}

-(void)convertToData1:(Mesh)mesh vertices:(NSMutableData*)theVertices normals:(NSMutableData*)theNormals elements:(NSMutableData*)theElements
{
    Vector3 vMin, vMax, vCenter;
    mesh.BoundingBox(vMin, vMax);
    vCenter = (vMin+vMax)*0.5;
    float sizeZ = fabsf(vMax.z-vMin.z);
    vCenter.z -= sizeZ*0.5;
    
    for (int i = 0; i < mesh.mVertices.size(); i++) {
        mesh.mVertices[i] = mesh.mVertices[i]-vCenter;
    }
    
    for (int i = 0; i < mesh.mIndices.size()/3; i++) {
        int indice0 = mesh.mIndices[i*3];
        int indice1 = mesh.mIndices[i*3+1];
        int indice2 = mesh.mIndices[i*3+2];
        
        Vector3 v0 = mesh.mVertices[indice0];
        Vector3 v1 = mesh.mVertices[indice1];
        Vector3 v2 = mesh.mVertices[indice2];
        
        [theVertices appendBytes:&v0 length:sizeof(v0)];
        [theVertices appendBytes:&v1 length:sizeof(v1)];
        [theVertices appendBytes:&v2 length:sizeof(v2)];
        
        Vector3 theNormal = [CCTMImporter calNormal:v0 v1:v1 v2:v2];
        for (int j = 0; j < 3; j++) {
            [theNormals appendBytes:&theNormal length:sizeof(theNormal)];
        }
        
        int theIndices[3] = {i * 3 + 0, i * 3 + 1, i * 3 + 2 };
        [theElements appendBytes:&theIndices[0] length:sizeof(theIndices)];
    }
}
-(void)convertToData:(Mesh)mesh vertices:(NSMutableData*)theVertices normals:(NSMutableData*)theNormals elements:(NSMutableData*)theElements
{
    Vector3 vMin, vMax, vCenter;
    mesh.BoundingBox(vMin, vMax);
    vCenter = (vMin+vMax)*0.5;
    float sizeZ = fabsf(vMax.z-vMin.z);
    vCenter.z -= sizeZ*0.5;
    
    for (int i = 0; i < mesh.mVertices.size(); i++) {
        Vector3 v = mesh.mVertices[i]-vCenter;
        [theVertices appendBytes:&v length:sizeof(v)];
        
        // Vector3 vn = Vector3(0, 0, 0);
        // [theNormals appendBytes:&vn length:sizeof(vn)];
    }
    
    if (mesh.HasNormals() == false) {
        mesh.CalculateNormals(Mesh::ncaCAD);
    }
    for (int i = 0; i < mesh.mNormals.size(); i++) {
        Vector3 v = mesh.mNormals[i];
        [theNormals appendBytes:&v length:sizeof(v)];
    }
    
    for (int i = 0; i < mesh.mIndices.size()/3; i++) {
        int indice0 = mesh.mIndices[i*3];
        int indice1 = mesh.mIndices[i*3+1];
        int indice2 = mesh.mIndices[i*3+2];
        
        int theIndices[3] = {indice0, indice1, indice2 };
        [theElements appendBytes:&theIndices[0] length:sizeof(theIndices)];
    }

    // NSLog(@"%lu, %lu, %lu", mesh.mVertices.size(), mesh.mNormals.size(), mesh.mIndices.size());
    // printf("%f,\t %f,\t %f \n", theNormal.x, theNormal.y, theNormal.z);
}

+(Vector3)calNormal:(Vector3)v0 v1:(Vector3)v1 v2:(Vector3)v2
{
    Vector3 va, vb, vab;
    va = Vector3(v1.x-v0.x, v1.y-v0.y, v1.z-v0.z);
    vb = Vector3(v2.x-v0.x, v2.y-v0.y, v2.z-v0.z);
    vab= Vector3(va.y*vb.z-vb.y*va.z,  va.z*vb.x-vb.z*va.x, va.x*vb.y-vb.x*va.y);
    float module = vab.Abs();
    
    Vector3 theNormal = Vector3(vab.x/module, vab.y/module, vab.z/module);
    return theNormal;
}

@end
