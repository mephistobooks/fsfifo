#
# filename: test-fs_array.rb
#
#

# Unit Test Lib.
require 'helper'
require 'test/unit'

# required lib.
#require 'something'

# Testee.
require "fsfifo"


# Test Cases.
class TestFSArray < Test::Unit::TestCase

  def setup
    @fifo = FSFIFO.new

    @of_proc_called = false
    @uf_proc_called = false

    @fifo.of_proc = Proc.new { p "of called."; @of_proc_called = true }
    @fifo.uf_proc = Proc.new { p "uf called."; @uf_proc_called = true }
  end

  def teardown

  end

  ####

  def test_new

    ff = FSFIFO.new( size: 10 )
    assert_equal(  0, ff.size )
    assert_equal( 10, ff.fifosize )

    ff = FSFIFO.new( 2 )
    assert_equal( 0, ff.size )
    assert_equal( 2, ff.fifosize )

  end

  def test_size

    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )

  end

  def test_resize

    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )

    #
    @fifo.resize(10)
    assert_equal(  0, @fifo.size )
    assert_equal( 10, @fifo.fifosize )

  end

  ####
  
  def test_push_and_shift

    #
    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )

    #
    @fifo.push( 'a' )
    assert_equal( 1, @fifo.size )
    assert_equal( 1, @fifo.fifosize )
    assert_equal( 'a', @fifo[0] )
    assert_equal( 'a', @fifo[-1] )

    ret = @fifo.shift
    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )
    assert_equal( [], @fifo )
    assert_equal( 'a', ret )

    @fifo.push( 'c' )
    assert_equal( 1, @fifo.size )
    assert_equal( 1, @fifo.fifosize )
    assert_equal( 'c', @fifo[0] )
    assert_equal( 'c', @fifo[-1] )

  end

  def test_resize_and_push

    #
    @fifo.resize( 4 )
    assert_equal( 0, @fifo.size )
    assert_equal( 4, @fifo.fifosize )

    #
    ret = @fifo.push( 'm' )
    assert_equal( 1, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'm', ret.join )
    assert_equal( 'm', @fifo[-1] )

    @fifo.push( 'o' )
    assert_equal( 2, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'mo', @fifo.join )
    assert_equal( 'o', @fifo[-1] )

    @fifo.push( 'e' )
    assert_equal( 3, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'moe', @fifo.join )
    assert_equal( 'm', @fifo[0] )
    assert_equal( 'e', @fifo[-1] )

    @fifo.push( 'm' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'moem', @fifo.join )
    assert_equal( 'm', @fifo[0] )
    assert_equal( 'm', @fifo[-1] )

    @fifo.push( 'o' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'oemo', @fifo.join )
    assert_equal( 'o', @fifo[-1] )

    @fifo.push( 'e' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'emoe', @fifo.join )
    assert_equal( 'e', @fifo[-1] )

  end

  def test_resize_push_and_resize

    #
    @fifo.resize( 4 )
    assert_equal( 0, @fifo.size )
    assert_equal( 4, @fifo.fifosize )

    #
    "moemoe".split(/\B/).each do |e|
      @fifo.push( e )
    end
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'emoe', @fifo.join )

    #
    @fifo.resize(2)
    assert_equal( 2, @fifo.size )
    assert_equal( 2, @fifo.fifosize )
    assert_equal( 'oe', @fifo.join )

    #
    @fifo.resize( 4 )
    assert_equal( 2, @fifo.size )
    assert_equal( 4, @fifo.fifosize )

  end

  ####

  def test_default_uo

    ff = FSFIFO.new( size: 3, of_enable: true, uf_enable: true )
    assert_equal(  0, ff.size )
    assert_equal( 3, ff.fifosize )

    ff.push( 1 ); ff.push( 2 ); ff.push( 3 )
    e = assert_raise( RuntimeError ){ ff.push( 4 ); }

    3.times { ff.shift; }
    e = assert_raise( RuntimeError ){ ff.shift; }

  end

  def test_of

    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )

    @fifo.of_enable
    assert_equal( true, @fifo.of_enable? )

    @fifo.push( 1 )
    @fifo.push( 2 )
    assert_equal( true, @of_proc_called )

    @of_proc_called = false
    @fifo.push( 3 )
    assert_equal( true, @of_proc_called )

    @fifo.of_disable
    @of_proc_called = false
    @fifo.push( 4 )
    assert_equal( false, @of_proc_called )

  end

  def test_uf

    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )

    @fifo.uf_enable
    assert_equal( true, @fifo.uf_enable? )

    @uf_proc_called = false
    @fifo.push( 1 )
    @fifo.shift
    assert_equal( false, @uf_proc_called )

    @uf_proc_called = false
    @fifo.push( 1 )
    2.times{ @fifo.shift }
    assert_equal( true, @uf_proc_called )

    @uf_proc_called = false
    @fifo.push( 3 )
    @fifo.uf_disable
    @fifo.shift
    assert_equal( false, @uf_proc_called )

  end


end


#### endof filename: test-fs_array.rb
