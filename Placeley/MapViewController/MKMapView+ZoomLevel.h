//
//  MKMapView+ZoomLevel.h
//  MapWithAnnptation
//
//  Created by Krishnan Ziggma on 1/18/14.
//
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
{
}
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;

@end
