# fsfifo ReadMe

## Fixed Size FIFO, LIFO, Array lib.

fsfifo.rb defines FSFIFO, which is the fixed size FIFO (Queue).

This extends the built-in Array so you can easily understand it. (fsfifo.rb also defines FSLIFO and FSArray, and FSArray is the most general class)


## Usage

Do ```[sudo] gem install fsfifo``` and ```require 'fsfifo'``` for preparation.

### new

Just ```FSFIFO.new(4)``` or ```FSFIFO.new( size: 4 )``` and then you can create a FIFO whose size is 4:

```
>>fsf = FSFIFO.new( 4 )
=> []
>> fsf.size
=> 0
>> fsf.fifosize
=> 4
```

### size
Here, FSFIFO#size means the number of elements and FSFIFO#fifosize means the size of FIFO. You can also change the size of FIFO by FSFIFO#resize.

### operation

And you can push objects like this:

```
>> fsf.push( 1 )
=> [1]

>> fsf.push( 2 )
=> [1, 2]

>> fsf.push( 3 )
=> [1, 2, 3]

>> fsf.push( 4 )
=> [1, 2, 3, 4]

>> fsf.push( 5 )
=> [2, 3, 4, 5]
```

You can also shift and resize.

```
>> fsf
=> [2, 3, 4, 5]
>> fsf.shift
=> 2
>> fsf
=> [3, 4, 5]
>> fsf.resize( 2 )
=> [3]
>> fsf
=> [4, 5]
>> fsf.push( 6 )
=> [5, 6]
```


## License

MIT License.


# End
