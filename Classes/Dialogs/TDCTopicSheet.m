/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

 Copyright (c) 2008 - 2010 Satoshi Nakagawa <psychs AT limechat DOT net>
 Copyright (c) 2010 - 2015 Codeux Software, LLC & respective contributors.
        Please see Acknowledgements.pdf for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Textual and/or "Codeux Software, LLC", nor the 
      names of its contributors may be used to endorse or promote products 
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

#import "TextualApplication.h"

@interface TDCTopicSheet ()
@property (nonatomic, weak) IBOutlet NSTextField *headerTitleTextField;
@property (nonatomic, unsafe_unretained) IBOutlet TVCTextViewWithIRCFormatter *topicValueTextField;
@end

@implementation TDCTopicSheet

- (instancetype)init
{
	if ((self = [super init])) {
		[RZMainBundle() loadNibNamed:@"TDCTopicSheet" owner:self topLevelObjects:nil];
	}

	return self;
}

- (void)start:(NSString *)topic
{
	IRCChannel *c = [worldController() findChannelByClientId:self.clientID channelId:self.channelID];

	NSString *headerTitle = [NSString stringWithFormat:[self.headerTitleTextField stringValue], [c name]];

	[self.headerTitleTextField setStringValue:headerTitle];

	[self.topicValueTextField setPreferredFont:[NSFont systemFontOfSize:13.0]];
	[self.topicValueTextField setPreferredFontColor:[NSColor colorWithCalibratedWhite:0.01 alpha:1.0]];

	NSAttributedString *topicas = [topic attributedStringWithIRCFormatting:[self.topicValueTextField preferredFont]
														preferredFontColor:[self.topicValueTextField preferredFontColor]
												 honorFormattingPreference:NO];
	
	[self.topicValueTextField setAttributedStringValue:topicas];

	[[mainWindow() formattingMenu] enableSheetField:self.topicValueTextField];

	[self startSheet];
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{
	if (aSelector == @selector(insertNewline:)) {
		[self ok:nil];

		return YES;
	} else if (aSelector == @selector(insertNewlineIgnoringFieldEditor:) ) {
		/* Do not allow a new line to be inserted using Option + Enter */

		return YES;
	}

	return NO;
}

- (void)ok:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(topicSheet:onOK:)]) {
		NSString *formattedTopic = [[self.topicValueTextField attributedStringValue] attributedStringToASCIIFormatting];

		NSString *topicWithoutNewlines = [formattedTopic stringByReplacingOccurrencesOfString:NSStringNewlinePlaceholder
																				   withString:NSStringWhitespacePlaceholder];

		[self.delegate topicSheet:self onOK:topicWithoutNewlines];
	}
	
	[super ok:nil];
}

#pragma mark -
#pragma mark NSWindow Delegate

- (void)windowWillClose:(NSNotification *)note
{
	[[mainWindow() formattingMenu] enableWindowField:mainWindowTextField()];
	
	if ([self.delegate respondsToSelector:@selector(topicSheetWillClose:)]) {
		[self.delegate topicSheetWillClose:self];
	}
}

@end
