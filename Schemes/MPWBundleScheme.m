//
//  MPWBundleScheme.m
//  MPWTalk
//
//  Created by Marcel Weiher on 5/28/11.
//  Copyright 2012 metaobject ltd. All rights reserved.
//

#import "MPWBundleScheme.h"
#import "MPWStCompiler.h"
#import <MPWFoundation/AccessorMacros.h>
#import <MPWFoundation/MPWGenericReference.h>
#import "MPWFileBinding.h"

@implementation MPWBundleScheme

objectAccessor( NSBundle, bundle ,setBundle )

+schemeWithBundle:(NSBundle*)aBundle
{
	return [[[self alloc] initWithBundle:aBundle] autorelease];
}

+mainBundleScheme
{
	return [self schemeWithBundle:[NSBundle mainBundle]];
}

+classBundleScheme:(Class)aClass
{
	return [self schemeWithBundle:[NSBundle bundleForClass:aClass]];
}

-initWithBundle:(NSBundle*)aBundle
{
	self=[super init];
	[self setBundle:aBundle];
	return self;
}

-init
{
	return [self initWithBundle:[NSBundle bundleForClass:[self class]]];
}

-(NSString*)resourcePathForPath:(NSString*)aName
{
    NSString *pathExtension=[aName pathExtension];
    if ( !pathExtension) {
        pathExtension=@"";
    }
    NSString *path = [[self bundle] pathForResource:[aName stringByDeletingPathExtension] ofType:pathExtension];
    if ( !path ) {
        path=[[self bundle] resourcePath];
    }
    return path;
}

// FIXME:  this is wrong, appendinig the path should not happen here but
//  when generating the URL.

-bindingForReference:aReference inContext:aContext
{
    return [super bindingForReference:[self referenceForPath:[self resourcePathForPath:[aReference path]]] inContext:aContext];
}


-(id)objectForReference:(id)aReference
{
    return [super objectForReference:[self referenceForPath:[self resourcePathForPath:[aReference path]]]];
}


@end

@implementation MPWBundleScheme(testing)


+(void)testGettingASimpleFile
{
	chdir("/");
	IDEXPECT( [[MPWStCompiler evaluate:@"bundle:testfile.txt"] stringValue], @"this is a test file", @"geting testfile.txt");
}


+(void)testGettingRoot
{
	chdir("/");
	IDEXPECT( [[[MPWStCompiler evaluate:@"ref:bundle:/"] URL] path], [[MPWStCompiler evaluate:@"scheme:bundle bundle resourcePath."] stringValue], @"root");
}


+testSelectors
{
	return [NSArray arrayWithObjects:
			@"testGettingASimpleFile",
			@"testGettingRoot",
			nil];
}


@end
