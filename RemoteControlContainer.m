/*****************************************************************************
 * RemoteControlContainer.m
 * RemoteControlWrapper
 *
 * Created by Martin Kahr on 11.03.06 under a MIT-style license. 
 * Copyright (c) 2006 martinkahr.com. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a 
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *****************************************************************************/

#import "RemoteControlContainer.h"


@implementation RemoteControlContainer

- (id) initWithDelegate: (id) _remoteControlDelegate {
	if (self = [super initWithDelegate:_remoteControlDelegate]) {
		remoteControls = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[self stopListening: self];
	[remoteControls release];
	[super dealloc];
}

- (BOOL) instantiateAndAddRemoteControlDeviceWithClass: (Class) clazz {
	RemoteControl* remoteControl = [[clazz alloc] initWithDelegate: delegate];
	if (remoteControl) {
		[remoteControls addObject: remoteControl];
		[remoteControl addObserver: self forKeyPath:@"listeningToRemote" options:NSKeyValueObservingOptionNew context:nil];
		return YES;		
	}
	return NO;	
}

- (unsigned int) count {
	return [remoteControls count];
}

- (void) reset {
	[self willChangeValueForKey:@"listeningToRemote"];
	[self didChangeValueForKey:@"listeningToRemote"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self reset];
}

- (void) setListeningToRemote: (BOOL) value {
	for(id loopItem in remoteControls) {
		[loopItem setListeningToRemote: value];
	}
	if (value && value != [self isListeningToRemote]) [self performSelector:@selector(reset) withObject:nil afterDelay:0.01];
}
- (BOOL) isListeningToRemote {
	for(id loopItem in remoteControls) {
		if ([loopItem isListeningToRemote]) {
			return YES;
		}
	}
	return NO;
}

- (IBAction) startListening: (id) sender {
	for(id loopItem in remoteControls) {
		[loopItem startListening: sender];
	}	
}
- (IBAction) stopListening: (id) sender {
	for(id loopItem in remoteControls) {
		[loopItem stopListening: sender];
	}	
}

- (BOOL) isOpenInExclusiveMode {
	BOOL mode = YES;
	for(id loopItem in remoteControls) {
		mode = mode && ([loopItem isOpenInExclusiveMode]);
	}
	return mode;	
}
- (void) setOpenInExclusiveMode: (BOOL) value {
	for(id loopItem in remoteControls) {
		[loopItem setOpenInExclusiveMode:value];
	}	
}

@end