[![Build Status](https://travis-ci.org/edennis/mars_rovers.svg?branch=master)](https://travis-ci.org/edennis/mars_rovers)
[![Coverage Status](https://coveralls.io/repos/github/edennis/mars_rovers/badge.svg?branch=master)](https://coveralls.io/github/edennis/mars_rovers?branch=master)


# Mars Rovers

This is an implementation of the mars rovers kata in Elixir which
serves as a testing ground for teaching myself the language. I've
come up with several iterations to familiarize myself with various
libraries and frameworks:

- [x] Solve the problem using only modules, functions and data.
- [x] Setup `mix`; create a CLI (file IO) and test with `ExUnit`
- [ ] OTP: Design a concurrent solution that has rovers running in parallel
- [ ] Phoenix: Visualization in a single-page app using Channels for live updates.


## Description

A squad of robotic rovers are to be landed by NASA on a plateau on
Mars. This plateau, which is curiously rectangular, must be navigated
by the rovers so that their on-board cameras can get a complete
view of the surrounding terrain to send back to Earth.
A rover’s position and location is represented by a combination of x
and y co- ordinates and a letter representing one of the four cardinal
compass points. The plateau is divided up into a grid to simplify
navigation. An example position might be 0, 0, N, which means the
rover is in the bottom left corner and facing North.
In order to control a rover, NASA sends a simple string of letters. The
possible letters are ‘L’, ‘R’ and ‘M’. ‘L’ and ‘R’ makes the rover spin
90 degrees left or right respectively, without moving from its current
spot. ‘M’ means move forward one grid point, and maintain the same
Heading.

Assume that the square directly North from (x, y) is (x, y+1).

### INPUT
The first line of input is the upper-right coordinates of the plateau, the
lower- left coordinates are assumed to be 0,0.
The rest of the input is information pertaining to the rovers that have
been deployed. Each rover has two lines of input. The first line gives
the rover’s position, and the second line is a series of instructions
telling the rover how to explore the plateau.
The position is made up of two integers and a letter separated by
spaces, corresponding to the x and y co-ordinates and the rover’s
orientation.
Each rover will be finished sequentially, which means that the
second rover won’t start to move until the first one has finished
Moving.

```
# Test Input:
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
```

### OUTPUT
The output for each rover should be its final co-ordinates and
heading.
```
# Expected Output:
1 3 N
5 1 E
```

## Running tests
```
mix test
```

## Building and running the CLI
```
mix escript.build
./mars_rovers test/support/input.txt
```
