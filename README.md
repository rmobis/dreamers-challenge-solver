# Dreamer's Challenge Solver

<p align="center"><img src ="http://i.imgur.com/eEWmUWY.gif" /></p>

Since the first time I played through [this Tibia quest](http://tibia.wikia.com/wiki/Dreamer%27s_Challenge_Quest) I felt
intrigued by the little pillow puzzles it had on Mission 2. I started to code a few years later and ever since I've felt
the need to find a way to solve it programatically. After years of postponing it, telling myself it was __too
difficult__, I've finally managed to do it. This is the result.


## Usage

Here's a little example that uses the `DreamersSolver` class to solve a `DramersBoard` created from a predefined tiles
table and then prints the amount of steps taken to solve it:

````lua
local b = DreamersBoard:new({
    {1, 2, 3, 4, 1, 2},
    {3, 4, 1, 2, 3, 4},
    {1, 2, 3, 4, 1, 2},
    {3, 4, 1, 2, 3, 4},
    {1, 2, 3, 4, 1, 2},
    {3, 4, 1, 2, 3, 4}
})

local s = DreamersSolver:new(b, {
    {1, 2},
    {3, 4}
})

s:solveBoard()

if s:checkBoard() then
    print(#b:getSteps())
end
````

## Contributing

If you have any code to add, please make a pull request. If you have any suggestion, please open an issue. You can take
a look at the todo list below for anything that needs to be done. **Any contribution is welcome.**


## Todo

- Add an implementation with `synchronize` for other bots.
- Improve algorithm.


## License

Dreamer's Challenge Solver is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
