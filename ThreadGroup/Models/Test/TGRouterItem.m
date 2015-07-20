//
//  TGRouterItem.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouterItem.h"
#import <arpa/inet.h>

typedef union {
    struct sockaddr sa;
    struct sockaddr_in ipv4;
    struct sockaddr_in6 ipv6;
} ip_socket_address;

@implementation TGRouterItem

- (instancetype)initWithName:(NSString *)name networkName:(NSString *)networkName networkAddress:(NSString *)networkAddress {
    self = [super init];
    if (self) {
        _name = name;
        _networkName = networkName;
        _networkAddress = networkAddress;
    }
    return self;
}

- (instancetype)initWithService:(NSNetService *)service {
    NSString *name = service.name;
    NSString *networkName = service.hostName;
    NSString *address = [self decodeIPAddressFromService:service];
    return [self initWithName:name networkName:networkName networkAddress:address];
}

- (NSString *)decodeIPAddressFromService:(NSNetService *)netService {
    NSArray *addresses = netService.addresses;
    char addressBuffer[INET6_ADDRSTRLEN];
    
    for (NSData *data in addresses) {
        memset(addressBuffer, 0, INET6_ADDRSTRLEN);
        
        ip_socket_address *socketAddress = (ip_socket_address *)[data bytes];
        
        if (socketAddress && (socketAddress->sa.sa_family == AF_INET || socketAddress->sa.sa_family == AF_INET6)) {
            const char *addressStr = inet_ntop(
                                               socketAddress->sa.sa_family,
                                               (socketAddress->sa.sa_family == AF_INET ? (void *) &(socketAddress->ipv4.sin_addr) : (void *) &(socketAddress->ipv6.sin6_addr)),
                                               addressBuffer,
                                               sizeof(addressBuffer));
            
            int port = ntohs(socketAddress->sa.sa_family == AF_INET ? socketAddress->ipv4.sin_port : socketAddress->ipv6.sin6_port);
            
            if (addressStr && port) {
                NSLog(@"Found service at %s:%d", addressStr, port);
                return [NSString stringWithFormat:@"%s:%d", addressStr, port];
            }
        }
    }
    
    return nil;
}

#pragma mark - Overridden

- (NSString *)description {
    return [NSString stringWithFormat:@"Router Name: <%@> Network: <%@> Address: <%@>", self.name, self.networkName, self.networkAddress];
}

- (BOOL)isEqual:(id)object {
    BOOL objectIsNetService = [object isKindOfClass:[self class]];
    return (objectIsNetService) ? [self isEqualToRouter:object] : NO;
}

- (BOOL)isEqualToRouter:(TGRouterItem *)router {
    return (
            ([self.name isEqualToString:router.name]) &&
            ([self.networkName isEqualToString:router.networkName]) &&
            ([self.networkAddress isEqualToString:router.networkAddress])
            );
}

@end
