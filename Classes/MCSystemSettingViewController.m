//
//  MCSystemSettingViewController.m
//  MCGame
//
//  Created by kwan terry on 13-6-3.
//
//

#import "MCSystemSettingViewController.h"
#import "MCStringDefine.h"
@interface MCSystemSettingViewController ()

@end

@implementation MCSystemSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:magicCubeSettingTable]) {
        if(section == 0)
            return @"Background Audio Volume2";
        else if(section == 1)
            return @"Effects volume2";
        else return nil;
    }else if ([tableView isEqual:soundSettingTable]) {
        if(section == 0)
            return S_L_RotateEffect;
        else if(section == 1)
            return S_L_RotateEffectSwitch;
        else if(section == 2)
            return S_L_BackGroundMusic;
        else if(section == 3)
            return S_L_BackGroundMusicSwitch;
	
        else return nil;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		// create a slider for the first 2 sections only
		if(indexPath.section == 0||indexPath.section == 2)
		{
			UISlider *slider;
			slider = [[UISlider alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width - cell.indentationWidth * 2.0, cell.bounds.size.height)];
			slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			slider.minimumValueImage = [UIImage imageNamed:@"volumedown.png"];
			slider.maximumValueImage = [UIImage imageNamed:@"volumeup.png"];
			
			slider.maximumValue = 1.0;
			slider.minimumValue = 0.0;
			slider.value = 1.0; // in a real app you should read this value from the user defaults
			
			if(indexPath.section == 0)
			{
				[slider addTarget:self action:@selector(musicVolume:) forControlEvents:UIControlEventValueChanged];
			//	slider.enabled = !soundMgr.isiPodAudioPlaying; // disable the slider if the ipod is playing...
			}
			else
				[slider addTarget:self action:@selector(effectsVolume:) forControlEvents:UIControlEventValueChanged];
			
			
			[cell.contentView addSubview:slider];
			[slider release];
		}
    }
    
	// Configure the cell.
	if(indexPath.section == 1)
	{
		cell.textLabel.text = S_L_RotateEffectSwitch;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
	else if(indexPath.section == 3)
	{
		cell.textLabel.text = S_L_BackGroundMusicSwitch;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
    
    return cell;
}

- (void) musicVolume:(id)sender
{
	//soundMgr.backgroundMusicVolume = ((UISlider *)sender).value;
}

- (void) effectsVolume:(id)sender
{
	//soundMgr.soundEffectsVolume = ((UISlider *)sender).value;
}


// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section < 2) return;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 2) {
		// play our sound effect
	//	[soundMgr playSoundWithID:AUDIOEFFECT2];
		return;
	}
	/*
	if ([soundMgr isBackGroundMusicPlaying])
	{
	//	[soundMgr pauseBackgroundMusic];
	}
	else
	{
	//	[soundMgr resumeBackgroundMusic];
	}*/
    
}



@end