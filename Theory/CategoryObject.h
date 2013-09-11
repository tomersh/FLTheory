//
//  CategoryObject.h
//  Theory
//
//  Created by Luda Fux on 7/10/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 category:{
     categoryID = NSString
     categoryName = NSString
 }
 */
@interface CategoryObject : NSObject{
    int _categoryID;
    NSString* _categoryName;
}
@property (assign,nonatomic) int categoryID;
@property (strong,nonatomic) NSString* categoryName;

@end
