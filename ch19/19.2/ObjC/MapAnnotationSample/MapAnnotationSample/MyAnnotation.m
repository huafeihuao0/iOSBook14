#import "MyAnnotation.h"

@implementation MyAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    self = [super init];
    if (self)
    {
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return @"您的位置!";
}

- (NSString *)subtitle {
    
    NSMutableString *res = [[NSMutableString alloc] init];
    if  (self.state != nil) {
        [res appendFormat:@"%@", self.state];
    }
    
    if  (self.city != nil) {
        [res appendFormat:@" • %@", self.state];
    }
    
    if  (self.zip != nil) {
        [res appendFormat:@" • %@", self.zip];
    }
    
    if  (self.streetAddress != nil) {
        [res appendFormat:@" • %@", self.streetAddress];
    }
    
    return res;
}


@end
