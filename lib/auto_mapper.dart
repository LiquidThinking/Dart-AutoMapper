library AutoMapper;

import 'dart:mirrors';

class AutoMapper
{

	bool isPrimitive( dynamic value )
	{
		return (value == null || value is bool || value is num || value is String || value is DateTime || value is double);
	}

	Iterable<DeclarationMirror> getVariableMirrors( InstanceMirror fromMirror )
	{
		var fromVariables = fromMirror.type.declarations.values.where( ( d )
																	   => d is VariableMirror );
		return fromVariables;
	}

	String getVariableName( VariableMirror variableMirror )
	{
		return MirrorSystem.getName( variableMirror.simpleName );
	}

	instantiateType( Type toType )
	{
		var resultList = reflectClass( toType ).newInstance( const Symbol( '' ), [] ).reflectee;
		return resultList;
	}

	_mapList( Type toType, from )
	{
		var resultList = instantiateType( toType );
		var listObjectType = reflectType( toType ).typeArguments[0].reflectedType;
		resultList.addAll( from.map( ( x )
									 => map( x, listObjectType ) ) );
		return resultList;
	}

	_mapCustomType( Type toType, from )
	{
		var result = instantiateType( toType );

		var fromMirror = reflect( from );
		var toMirror = reflect( result );

		var fromVariables = getVariableMirrors( fromMirror );
		var toVariables = getVariableMirrors( toMirror );

		for ( var variableMirror in fromVariables )
		{
			if ( toVariables.any( ( v )
								  => propertyNamesMatch( v, variableMirror ) ) )
			{
				var destinationVariable = toVariables
				.firstWhere( ( v )
							 => propertyNamesMatch( v, variableMirror ) );
				var fromValue = fromMirror.getField( variableMirror.simpleName ).reflectee;

				toMirror.setField( destinationVariable.simpleName, map( fromValue, destinationVariable.type.reflectedType ) );
			}
		}

		return result;
	}

	dynamic map( dynamic from, Type toType )
	{
		if ( isPrimitive( from ) )
		{
			return from;
		}
		else if ( from is List )
		{
			return _mapList( toType, from );
		}
		else
		{
			return _mapCustomType( toType, from );
		}
	}

	bool propertyNamesMatch( VariableMirror variableMirror1, VariableMirror variableMirror2 )
	=> getVariableName( variableMirror1 ) == getVariableName( variableMirror2 );

}
