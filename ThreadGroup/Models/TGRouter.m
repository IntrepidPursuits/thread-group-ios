//
//  TGRouter.m
//  ThreadGroup
//
//  Created by LuQuan Intrepid on 6/18/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TGRouter.h"
#import <arpa/inet.h>

typedef union {
    struct sockaddr sa;
    struct sockaddr_in ipv4;
    struct sockaddr_in6 ipv6;
} ip_socket_address;

@interface TGRouter() <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic) NSInteger port;
@end

@implementation TGRouter

- (instancetype)initWithService:(NSNetService *)service {
    self = [super init];
    if (self) {
        _name = service.name;
        _networkName = service.hostName;

        NSString *networkAddress = [self decodeIPAddressFromService:service];
        _ipAddress = [networkAddress componentsSeparatedByString:@":"][0];
        _port = [[networkAddress componentsSeparatedByString:@":"][1] integerValue];
    }
    return self;
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
                return [NSString stringWithFormat:@"%s:%d", addressStr, port];
            }
        }
    }
    
    return nil;
}

#pragma mark - NSSecureCodiing

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.networkName = [aDecoder decodeObjectForKey:@"networkName"];
        self.ipAddress = [aDecoder decodeObjectForKey:@"ipAddress"];
        self.port = [aDecoder decodeIntegerForKey:@"port"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.networkName forKey:@"networkName"];
    [aCoder encodeObject:self.ipAddress forKey:@"ipAddress"];
    [aCoder encodeInteger:self.port forKey:@"port"];
}

#pragma mark - Overridden

- (NSString *)description {
    return [NSString stringWithFormat:@"Router Name: <%@> Network: <%@> Address: <%@> Port: <%ld>", self.name, self.networkName, self.ipAddress, (long)self.port];
}

- (BOOL)isEqual:(id)object {
    BOOL objectIsNetService = [object isKindOfClass:[self class]];
    return (objectIsNetService) ? [self isEqualToRouter:object] : NO;
}

- (BOOL)isEqualToRouter:(TGRouter *)router {
    return (
            ([self.name isEqualToString:router.name]) &&
            ([self.networkName isEqualToString:router.networkName]) &&
            ([self.ipAddress isEqualToString:router.ipAddress]) &&
            (self.port == router.port)
            );
}

@end
