//
//  FinishView.h
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "UATitledModalPanel.h"
#import "MCConfiguration.h"
@interface FinishView : UATitledModalPanel{
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@end
