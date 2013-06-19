//
//  InfoView.h
//  MCGame
//
//  Created by kwan terry on 13-6-19.
//
//

#import "UATitledModalPanel.h"

@interface InfoView : UATitledModalPanel{
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
