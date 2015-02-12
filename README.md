# AutoMapper

A library for mapping objects from one type to another.

## Usage

A simple usage example:

    import 'package:auto_mapper/auto_mapper.dart';

    main() {
		var fromObject = new MyTypeOfObject();
		var result = new AutoMapper().map( fromObject, MyOtherTypeOfObject );
    }
