class GameOfLife
    constructor: (@node_id, @size)->
        @ticks = 0
        @node = document.getElementById(@node_id)
        @calculateCellSize()
        @createNode() unless @node
        @createGrid()
        @randomPattern()
        @run()

    createNode: ->
        @node = document.createElement("table")
        document.body.appendChild(@node)

    createGrid: ->
        for r in [0..@size]
            row = document.createElement("tr")
            @node.appendChild(row)
            for c in [0..@size]
                cell = document.createElement("td")
                cell.id = "r#{r}c#{c}"
                cell.style.width = "#{@cellSize}px"
                cell.style.height = "#{@cellSize}px"
                row.appendChild(cell)

    calculateCellSize: ->
        @cellSize = Math.floor(window.innerWidth / @size / 2) # some padding

    getCell: (r, c)->
        document.getElementById("r#{r}c#{c}")

    bear: (r, c)->
        @getCell(r,c).className = "alive"

    kill: (r, c)->
        @getCell(r,c).className = ""

    randomPattern: ->
        for i in [0..@size*5]
            r = Math.round(Math.random()*@size)
            c = Math.round(Math.random()*@size)
            @bear(r,c)

    countLivingNeighbours: (r, c, highlight)->
        above  = @getCell(r-1, c)
        middle = @getCell(r, c)
        below  = @getCell(r+1, c)
        livingNeighbours = 0

        for cell in [above, middle, below]
            continue unless cell

            prev = cell.previousSibling
            next = cell.nextSibling

            livingNeighbours += 1 if prev && prev.className == "alive"
            livingNeighbours += 1 if cell.className == "alive" && cell != middle
            livingNeighbours += 1 if next && next.className == "alive"

        livingNeighbours

    destiny: (r, c)->
        switch @countLivingNeighbours(r,c)
            when 3 then @bear(r,c)
            when 0, 1, 4, 5, 6, 7, 8 then @kill(r,c)

    tick: ->
        @ticks += 1
        for r in [0..@size]
            for c in [0..@size]
                @destiny(r,c)


    run: ->
        fn = @run.bind(@)
        @tick()
        setTimeout(fn, 500)


window.GameOfLife = GameOfLife

