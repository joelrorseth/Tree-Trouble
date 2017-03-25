public class Game {
    
    public var currentHeight: Int
    public var score: Int = 0
    
    public init(heights: [Int]) {
        self.currentHeight = heights[0]
    }
}
