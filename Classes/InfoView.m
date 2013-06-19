//
//  InfoView.m
//  MCGame
//
//  Created by kwan terry on 13-6-19.
//
//

#import "InfoView.h"
#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }
@implementation InfoView

@synthesize viewLoadedFromXib;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
        self.x_outerMargin = 330;
        self.y_outerMargin = 150;
        self.isShowColseBtn = YES;
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin =  10.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 8.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 16;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:40.0f];
        
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleLinear];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: UAGradientLineModeBottom];
        
        // The noise layer opacity. Default = 0.4
        [[self titleBar] setNoiseOpacity:0.8];
        
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
        [[NSBundle mainBundle] loadNibNamed:@"myInfo" owner:self options:nil];
        [self.contentView addSubview:viewLoadedFromXib];
    }
	return self;
}


@end
