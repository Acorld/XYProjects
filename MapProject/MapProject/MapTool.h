//
//  MapTool.h
//  MapProject
//
//  Created by JD_Acorld on 14-7-23.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapTool : NSObject

/**
 *  显示所有坐标的最优显示范围1
 *  @from  http://brianreiter.org/2012/03/02/size-an-mkmapview-to-fit-its-annotations-in-ios-without-futzing-with-coordinate-systems/
 *  @param mapView
 *  @param animated 
 */
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated;

/**
 *  显示所有坐标的最优显示范围2
 *  @from  http://stackoverflow.com/questions/4680649/zooming-mkmapview-to-fit-annotation-pins
 *  @param mapView 
 */
- (void)regionFromLocationsInMapView:(MKMapView *)mapView;
@end
