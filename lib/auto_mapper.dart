library AutoMapper;

import 'dart:mirrors';

class AutoMapper
{

	bool _isPrimitive( dynamic value )
	{
		return (value == null || value is bool || value is num || value is String || value is DateTime || value is double);
	}

	Iterable<DeclarationMirror> _getVariableMirrors( InstanceMirror fromMirror )
	{
		var fromVariables = fromMirror.type.declarations.values.where( ( d )
																	   => d is VariableMirror );
		return fromVariables;
	}

	String _getVariableName( VariableMirror variableMirror )
	{
		return MirrorSystem.getName( variableMirror.simpleName );
	}

	dynamic _instantiateType( Type toType )
	{
		var resultList = reflectClass( toType ).newInstance( const Symbol( '' ), [] ).reflectee;
		return resultList;
	}

	dynamic _mapList( dynamic from, Type toType )
	{
		var resultList = _instantiateType( toType );
		var listObjectType = reflectType( toType ).typeArguments[0].reflectedType;
		resultList.addAll( from.map( ( x )
									 => map( x, listObjectType ) ) );
		return resultList;
	}

	dynamic _mapCustomType( dynamic from, Type toType )
	{
		var result = _instantiateType( toType );

		var fromMirror = reflect( from );
		var toMirror = reflect( result );

		var fromVariables = _getVariableMirrors( fromMirror );
		var toVariables = _getVariableMirrors( toMirror );

		for ( var variableMirror in fromVariables )
		{
			if ( toVariables.any( ( v )
								  => _propertyNamesMatch( v, variableMirror ) ) )
			{
				var destinationVariable = toVariables
				.firstWhere( ( v )
							 => _propertyNamesMatch( v, variableMirror ) );
				var fromValue = fromMirror.getField( variableMirror.simpleName ).reflectee;

				toMirror.setField( destinationVariable.simpleName, map( fromValue, destinationVariable.type.reflectedType ) );
			}
		}

		return result;
	}

	dynamic map( dynamic from, Type toType )
	{
		if ( _isPrimitive( from ) )
		{
			return from;
		}
		else if ( from is List )
		{
			return _mapList( from, toType );
		}
		else
		{
			return _mapCustomType( from, toType );
		}
	}

	bool _propertyNamesMatch( VariableMirror variableMirror1, VariableMirror variableMirror2 )
	=> _getVariableName( variableMirror1 ) == _getVariableName( variableMirror2 );

}
