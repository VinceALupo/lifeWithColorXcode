//
//  ViewController.swift
//  lifeWithColor
//
//  Created by Vince Lupo on 9/20/24.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}


import UIKit

class ViewController: UIViewController {
    
    // Grid Dimensions
    let rows = 73
    let columns = 37
    let cellSize: CGFloat = 10
    
    let xstart : CGFloat = 13
    let ystart : CGFloat = 75
    
    // 2D array for storing cell states (true = alive, false = dead)
    var grid: [[Bool]] = []
    
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
            let row = (0..<columns).map { _ in Bool.random() }
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
                cellView.backgroundColor = grid[row][column] ? .black : .white
                cellView.layer.borderWidth = 1
                cellView.layer.borderColor = UIColor.lightGray.cgColor
                view.addSubview(cellView)
                cellView.tag = row * columns + column
            }
        }
    }
    
    func startGameLoop() {
        // Update every 0.5 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.25,
                                     target: self,
                                     selector: #selector(updateGame),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateGame() {
        var newGrid: [[Bool]] = grid
        
        // Apply the Game of Life rules to each cell
        for row in 0..<rows {
            for column in 0..<columns {
                let aliveNeighbors = countAliveNeighbors(row: row, column: column)
                let isAlive = grid[row][column]
                
                // Apply the rules:
                if isAlive {
                    if aliveNeighbors < 2 || aliveNeighbors > 3 {
                        newGrid[row][column] = false // Cell dies
                    }
                } else {
                    if aliveNeighbors == 3 {
                        newGrid[row][column] = true // Cell becomes alive
                    }
                }
            }
        }
        
        // Update the grid with the new state
        grid = newGrid
        
        // Redraw the grid
        updateGridUI()
    }
    
    func countAliveNeighbors(row: Int, column: Int) -> Int {
        var aliveCount = 0
        
        // Check the 8 surrounding cells
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 { continue } // Skip the current cell
                
                let neighborRow = row + i
                let neighborColumn = column + j
                
                // Ensure the neighboring cell is within bounds
                if neighborRow >= 0 && neighborRow < rows && neighborColumn >= 0 && neighborColumn < columns {
                    if grid[neighborRow][neighborColumn] {
                        aliveCount += 1
                    }
                }
            }
        }
        
        return aliveCount
    }
    
    func updateGridUI() {
        // Update the grid's UI
        for row in 0..<rows {
            for column in 0..<columns {
                if let cellView = view.viewWithTag(row * columns + column) {
                    cellView.backgroundColor = grid[row][column] ? .black : .white
                }
            }
        }
    }
}

