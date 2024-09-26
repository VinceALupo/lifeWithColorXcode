

import UIKit

class ViewController: UIViewController {
    
    // Grid Dimensions
    let rows = 73
    let columns = 37
    let cellSize: CGFloat = 10
    
    let xstart : CGFloat = 13
    let ystart : CGFloat = 75
    
    // acceptable colors
    let acceptableColors: [UIColor] = [.red, .green, .blue, .yellow, .cyan, .gray, .orange]
    
    let deadColor = UIColor.white
    
    // 2D array for storing cell states (true = alive, false = dead)
    var grid: [[UIColor]] = []
    
    // Timer to update the game
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the grid
        initializeGrid()
        
        // Draw the grid on the screen
        drawGrid()
        
        // Start the game loop
        startGameLoop()
    }
    
    func initializeGrid() {
        // Randomly populate the grid with alive (true) and dead (false) cells
        for _ in 0..<rows {
            let row = (0..<columns).map { _ -> UIColor in
                let isAlive = Bool.random()
                
                if isAlive {
                    // Randomly pick the acceptable colors
                    return acceptableColors.randomElement()!
                } else {
                    return deadColor // Dead cell
                }
            }
            grid.append(row)
        }
    }
    
    func drawGrid() {
        for row in 0..<rows {
            for column in 0..<columns {
                let cellView = UIView()
                cellView.frame = CGRect(x: xstart + (CGFloat(column) * cellSize),
                                        y: ystart + (CGFloat(row) * cellSize),
                                        width: cellSize,
                                        height: cellSize)
                
                // Set background color based on whether the cell is alive or dead
                cellView.backgroundColor = grid[row][column]
                cellView.layer.borderWidth = 1
                cellView.layer.borderColor = UIColor.lightGray.cgColor
                view.addSubview(cellView)
                cellView.tag = row * columns + column
            }
        }
    }
    
    func startGameLoop() {
        // Update every 0.5 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateGame),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateGame() {
        var newGrid: [[UIColor]] = grid
        
        // Apply the Game of Life rules to each cell
        for row in 0..<rows {
            for column in 0..<columns {
                let aliveNeighborsAndColorBlend = countAliveNeighbors(row: row, column: column)
                let aliveNeighbors = aliveNeighborsAndColorBlend.0
                
                let thisCellColor = grid[row][column]
                
                // Apply the rules:
                if thisCellColor != deadColor {
                    if aliveNeighbors < 2 || aliveNeighbors > 3 {
                        newGrid[row][column] = deadColor // Cell dies
                    }
                } else {
                    if aliveNeighbors == 3 {
                        let colorBlend = aliveNeighborsAndColorBlend.1
                        newGrid[row][column] = colorBlend
                            //acceptableColors.randomElement()! // Cell becomes alive
                    }
                }
            }
        }
        
        // Update the grid with the new state
        grid = newGrid
        
        // Redraw the grid
        updateGridUI()
    }
    
    
    func countAliveNeighbors(row: Int, column: Int) -> (Int, UIColor) {
        var aliveCount = 0
        var colorMerge = deadColor
        
        // Check the 8 surrounding cells
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 { continue } // Skip the current cell
                
                let neighborRow = row + i
                let neighborColumn = column + j
                
                // Ensure the neighboring cell is within bounds
                if neighborRow >= 0 && neighborRow < rows && neighborColumn >= 0 && neighborColumn < columns {
                    let thisColor = grid[neighborRow][neighborColumn]
                    
                    if thisColor != deadColor {
                        aliveCount += 1
                        colorMerge = blendColors(color1: colorMerge, color2: thisColor)
                    }
                }
            }
        }
        
        return (aliveCount, colorMerge)
    }
         

    func blendColors(color1: UIColor, color2: UIColor) -> UIColor {
        var colorToUseForColor1 : UIColor = color1
        
        // Extract the RGBA components of the first color
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        
        if (color1 == deadColor) {
            colorToUseForColor1 = color2
        }

        colorToUseForColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        // Extract the RGBA components of the second color
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Blend the two colors by averaging the RGBA components
        let blendedRed = (r1 + r2) / 2
        let blendedGreen = (g1 + g2) / 2
        let blendedBlue = (b1 + b2) / 2
        let blendedAlpha = (a1 + a2) / 2
        
        // Return the blended color
        return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
    }

    
    func updateGridUI() {
        // Update the grid's UI
        for row in 0..<rows {
            for column in 0..<columns {
                if let cellView = view.viewWithTag(row * columns + column) {
                    cellView.backgroundColor = grid[row][column]
                }
            }
        }
    }
}

