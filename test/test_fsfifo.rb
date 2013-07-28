#
# filename: test-fs_array.rb
#
#

# Unit Test Lib.
#require "rubygems"
#gem "test-unit"
#require "test/unit"
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

    @fifo.of_proc = Proc.new { p "of called."; @of_proc_called ^= true }
    @fifo.uf_proc = Proc.new { p "uf called."; @uf_proc_called ^= true }
  end

  def teardown

  end

  ####
  
  def test_new

    ff = FSFIFO.new( size: 10 )
    assert_equal(  0, ff.size )
    assert_equal( 10, ff.fifosize )

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

    ret = @fifo.shift
    assert_equal( 0, @fifo.size )
    assert_equal( 1, @fifo.fifosize )
    assert_equal( [], @fifo )
    assert_equal( 'a', ret )

    @fifo.push( 'c' )
    assert_equal( 1, @fifo.size )
    assert_equal( 1, @fifo.fifosize )
    assert_equal( 'c', @fifo[0] )

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

    @fifo.push( 'o' )
    assert_equal( 2, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'mo', @fifo.join )

    @fifo.push( 'e' )
    assert_equal( 3, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'moe', @fifo.join )

    @fifo.push( 'm' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'moem', @fifo.join )

    @fifo.push( 'o' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'oemo', @fifo.join )

    @fifo.push( 'e' )
    assert_equal( 4, @fifo.size )
    assert_equal( 4, @fifo.fifosize )
    assert_equal( 'emoe', @fifo.join )

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
  
  def test_of

    @fifo.of_enable
    assert_equal( true, @fifo.of_enable? )

    @fifo.push( 1 )
    @fifo.push( 2 )
    assert_equal( true, @of_proc_called )

    @fifo.push( 3 )
    assert_equal( false, @of_proc_called )

    @fifo.of_disable
    @fifo.push( 4 )
    assert_equal( false, @of_proc_called )

  end

  def test_uf

    @fifo.uf_enable
    assert_equal( true, @fifo.uf_enable? )

    @fifo.push( 1 )
    @fifo.shift
    assert_equal( true, @uf_proc_called )

    @fifo.push( 2 )
    @fifo.shift
    assert_equal( false, @uf_proc_called )

    @fifo.push( 3 )
    @fifo.uf_disable
    @fifo.shift
    assert_equal( false, @uf_proc_called )

  end


end


#### endof filename: test-fs_array.rb
