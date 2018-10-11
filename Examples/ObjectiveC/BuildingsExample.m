#import "BuildingsExample.h"

@import Mapbox;

NSString *const MBXExampleBuildings = @"BuildingsExample";

@interface BuildingsExample () <MGLMapViewDelegate>

@end

@implementation BuildingsExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the map style to Mapbox Light Style version 9. The map's source will be queried later in this example.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Center the map view on the Castel Sant'Angelo in Rome, Italy and set the camera's pitch, heading, and distance.
    mapView.camera = [MGLMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(41.9036, 12.4665) altitude:600 pitch:60 heading:210];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
    MGLSource *source = [style sourceWithIdentifier:@"composite"];
    MGLFillExtrusionStyleLayer *layer = [[MGLFillExtrusionStyleLayer alloc] initWithIdentifier:@"buildings" source:source];
    layer.sourceLayerIdentifier = @"building";
    
    // Filter out buildings that should not extrude.
    layer.predicate = [NSPredicate predicateWithFormat:@"extrude == 'true'"];
    
    // Set the fill extrusion height to the value for the building height attribute.
    layer.fillExtrusionHeight = [NSExpression expressionForKeyPath:@"height"];
    layer.fillExtrusionOpacity = [NSExpression expressionForConstantValue:@0.75];
    layer.fillExtrusionColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    
    // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"poi-scalerank3"];
    [style insertLayer:layer belowLayer:symbolLayer];
}

@end
