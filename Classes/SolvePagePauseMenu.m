//
//  PauseMenu.m
//  MCGame
//
//  Created by kwan terry on 13-3-4.
//
//

#import "SolvePagePauseMenu.h"
#define BLACK_BAR_COMPONENTS				{ 0.171875, 0.2421875, 0.3125, 0.8, 0.07, 0.07, 0.07, 1.0 }

@interface SolvePagePauseMenu ()

@end

@implementation SolvePagePauseMenu
@synthesize viewLoadedFromXib;
@synthesize solvePagePauseSelectType;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
        self.x_outerMargin = 344;
        self.y_outerMargin = 175;
        self.isShowColseBtn = YES;
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin =  8.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 8.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 16;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:48.0f];
        
        solvePagePauseSelectType = kSolvePagePauseSelect_default;
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleLinear];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: UAGradientLineModeBottom];
        
        // The noise layer opacity. Default = 0.4
        [[self titleBar] setNoiseOpacity:0.8];
        
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
        [[NSBundle mainBundle] loadNibNamed:@"solvepagepausemenu" owner:self options:nil];
        [viewLoadedFromXib setAlpha:0.5];
        [self.contentView addSubview:viewLoadedFromXib];
    }
    
    
    
    
    
	return self;
}

- (void)dealloc {
	[viewLoadedFromXib release];
    [super dealloc];
}
- (void)layoutSubviews {
	[super layoutSubviews];
	
	[viewLoadedFromXib setFrame:self.contentView.bounds];
}
- (IBAction)goOnBtnPressed:(id)sender{
    solvePagePauseSelectType = kSolvePagePauseSelect_GoOn;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    };
};
- (IBAction)saveAndReturnBtnPressed:(id)sender{
    solvePagePauseSelectType = kSolvePagePauseSelect_GoBack_AndSave;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    };
};
- (IBAction)returnDirectoryBtnPressed:(id)sender{
    solvePagePauseSelectType = kSolvePagePauseSelect_GoBack_Directly;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    };
};
- (IBAction)cleanBtnPressed:(id)sender{
    solvePagePauseSelectType = kSolvePagePauseSelect_Clean_State;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    };
};
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
