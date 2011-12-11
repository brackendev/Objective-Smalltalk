//
//  MPWScheme.m
//  MPWTalk
//
//  Created by Marcel Weiher on 6.1.10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "MPWScheme.h"
#import "MPWBinding.h"

@implementation MPWScheme

+scheme
{
	return [[[self alloc] init] autorelease];
}

-value
{
	return self;		// FIXME:  this is a workaround for not returning proper bindings from the scheme scheme
}

-bindingForName:(NSString*)variableName inContext:aContext
{
	return nil;
}

-bindingWithIdentifier:anIdentifier withContext:aContext
{
	return [self bindingForName:[anIdentifier evaluatedIdentifierNameInContext:aContext] inContext:aContext];
}

-evaluteIdentifier:anIdentifer withContext:aContext
{
	MPWBinding *binding=[self bindingWithIdentifier:anIdentifer withContext:aContext];
	id value=[binding value];
	if (!binding ) {
		value=[aContext valueForUndefinedVariableNamed:[anIdentifer identifierName]];
	}

	if ( ![value isNotNil] ) {
		value=nil;
	}
	return value;
	//	return [aContext valueOfVariableNamed:[anIdentifer identifierName] withScheme:[anIdentifer schemeName]];
}


-get:uri
{
    MPWBinding *binding=[self bindingForName:uri inContext:nil];
    return [binding value];
}

-get:uri parameters:params
{
    return [self get:uri];
}


-(BOOL)isBoundBinding:(MPWBinding*)aBinding
{
    return YES;
}



@end
