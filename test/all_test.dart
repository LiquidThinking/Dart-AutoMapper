library AutoMapper.test;

import 'package:unittest/unittest.dart';
import 'package:auto_mapper/auto_mapper.dart';

import 'dart:collection';

main( )
{
	group( 'AutoMapper', ( )
	{
		
		test( 'Mapping from one type to another with only primitive properties correctly copies string property over', ( )
		{
			var dateTime = new DateTime.now( );
			var testEntity = new TestEntity( )
				..stringProperty = "test"
				..intProperty = 1
				..dateTimeProperty = dateTime
				..doubleProperty = 1.1
				..boolProperty = true
				..numProperty = 1;

			TestDto testDto = AutoMapper.map( testEntity, TestDto );

			expect( testDto.stringProperty, "test" );
			expect( testDto.intProperty, 1 );
			expect( testDto.dateTimeProperty, dateTime );
			expect( testDto.doubleProperty, 1.1 );
			expect( testDto.boolProperty, true );
			expect( testDto.numProperty, 1 );
		} );

		test( 'Mapping from one type to another with a non primitive property correctly maps the non primitive properties', ( )
		{

			var testEntity = new TestEntity( )
				..stringProperty = "test";
			var testEntity2 = new TestEntity2( )
				..test = testEntity;

			TestDto2 testDto = AutoMapper.map( testEntity2, TestDto2 );

			expect( "test", testDto.test.stringProperty );
		} );

		test( 'Mapping an object with a list of primitive types maps correctly', ( )
		{

			var listEntity = new ListEntity( )
				..list = [ "Hello", "World" ];

			var result = AutoMapper.map( listEntity, ListDto );

			expect( result.list, isNotNull );
			expect( result.list, new isInstanceOf<List<String>>( ) );
			expect( result.list[0], "Hello" );

		} );


		test( 'Mapping an object with a list of non primitive types maps correctly', ( )
		{
			var nonPrimitiveListEntity = new NonPrimitiveListEntity( )
				..list = [ new TestEntity( )
				..stringProperty = "Hello", new TestEntity( )
				..stringProperty = "World"];

			var result = AutoMapper.map( nonPrimitiveListEntity, NonPrimitiveListDto );
			expect( result.list[0], new isInstanceOf<TestDto>( ) );
			expect( result.list[0].stringProperty, "Hello" );
		} );

		test( 'Mapping an object with a list maps to custom list', ( )
		{
			var customListEntity = new CustomListEntity( )
				..list = (new CustomList<TestEntity>( )
				..addAll( [ new TestEntity( )
				..stringProperty = "Hello", new TestEntity( )
				..stringProperty = "World"] ) );

			var result = AutoMapper.map( customListEntity, CustomListDto );
			expect( result.list, new isInstanceOf<CustomList<TestDto>>( ) );
			expect( result.list[0].stringProperty, "Hello" );
		} );
	} );
}


class TestEntity
{
	String stringProperty;
	int intProperty;
	DateTime dateTimeProperty;
	double doubleProperty;
	bool boolProperty;
	num numProperty;
}

class TestDto
{
	String stringProperty;
	int intProperty;
	DateTime dateTimeProperty;
	double doubleProperty;
	bool boolProperty;
	num numProperty;
}


class TestEntity2
{
	TestEntity test;
}

class TestDto2
{
	TestDto test;
}

class ListEntity
{
	List<String> list;
}

class ListDto
{
	List<String> list;
}

class NonPrimitiveListEntity
{
	List<TestEntity> list;
}

class NonPrimitiveListDto
{
	List<TestDto> list;
}

class CustomListEntity
{
	CustomList<TestEntity> list;
}

class CustomListDto
{
	CustomList<TestDto> list;
}

class CustomList<E> extends ListBase<E>
{
	var innerList = new List<E>( );

	int get length
	=> innerList.length;

	void set length( int length )
	{
		innerList.length = length;
	}

	void operator []=( int index, E value ) {
		innerList[index] = value;
	}

	E operator []( int index ) => innerList[index];

	// Though not strictly necessary, for performance reasons
	// you should implement add and addAll.

	void add( E value )
	=> innerList.add( value );

	void addAll( Iterable<E> all )
	=> innerList.addAll( all );
}