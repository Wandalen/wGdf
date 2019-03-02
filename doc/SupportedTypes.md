| Transformer 	| Primitive(0-3) 	| RegExp(0-2) 	| Buffer(0-3) 	| Complex(0-2) 	|
|:-----------:	|:---------:	|:------:	|:-------:	|:-------:	|
|    Bson     	|     2      	|     2   	|     0  	|     1    	|
|    Yaml       |     2     	|     2   	|     1  	|     2    	|
|    Cbor       |      2     	|     1   	|    1   	|     1    	|
|    Js       |      3     	|     2   	|     2 	|     1    	|
|    Cson       |      1     	|     2   	|     2 	|     1    	|
|    Json.fine       |      1     	|     0   	|     0 	|     1    	|
|    Json.min       |      1     	|     0   	|     0 	|     1    	|

Primitive:
    1 - boolean,number,string
    2 - null,Infinity,NaN
    3 - +0,-0,undefined,Date,BigInt
RegExp:
    1 - simple regexps without flags
    2 - complex regexps with flags
Buffer: ArrayBuffer, TypedBuffer, NodeBuffer
    1 - at least one type of buffer
    2 - at least ArrayBuffer
    3 - all types of buffer
Complex:
    1 - multilevel maps and arrays
    2 - recursion in maps
