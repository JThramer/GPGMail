//
//  main.m
//  GPG
//
//  Created by lukele on 08.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <xpc/xpc.h>
#include <Foundation/Foundation.h>
#import <Libmacgpg/Libmacgpg.h>
#import "XPCKit.h"

int main(int argc, const char *argv[])
{
	[XPCService runServiceWithConnectionHandler:^(XPCConnection *connection){
    
//    [connection _sendLog:@"GPG received a connection"];
    
        [connection setEventHandler:^(NSDictionary *message, XPCConnection *connection){
//			[connection _sendLog:[NSString stringWithFormat:@"GPG received a message! %@", message]];
            
            NSString *encryptedString = [message valueForKey:@"EncryptedData"];
            NSData *encryptedData = [encryptedString dataUsingEncoding:NSUTF8StringEncoding];
            
            GPGController *gpgc = [[GPGController alloc] init];
            gpgc.verbose = NO;
            //gpgc.verbose = (GPGMailLoggingLevel > 0);
            NSData *decryptedData = [gpgc decryptData:encryptedData];
            NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
            
            [connection sendMessage:[NSDictionary dictionaryWithObject:decryptedString forKey:@"result"]];
            [decryptedString release];
    }];
    }];    
    
	return 0;
}
