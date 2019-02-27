src data file  - 'proto/dwtools/abase/l8.test/asset/generated.s'

| Read transformer 	| Runs 	| Time 	|
|:-----------:	|:---------:	|:------:
|    Bson     	|     10000     	|     2.013s
|    Yaml     	|     10000     	|     4.323s
|    Cson     	|     10000     	|     125.557s
|    Cbor     	|     6000     	|     4.731s
|    js     	|     10000     	|     0.405s
|    json( fine )   	|     10000     	|     0.525s
|    json( min )   	|     10000     	|     0.481s


| Write transformer 	| Runs 	| Time 	|
|:-----------:	|:---------:	|:------:
|    Bson     	|     10000     	|    1.635s
|    Yaml     	|     10000     	|    3.656s
|    Cson     	|     10000     	|    142.246s
|    Cbor     	|     6000     	|    7.352s
|    Js     	|     10000     	|    33.468s
|    json.fine   	|     10000     	|     52.473s
|    json.min   	|     10000     	|      0.443s