//: [Previous](@previous)
/*:
 **What is a Graph?**
 
 A graph is an abstract data type (ADT) which consists of a set of objects that are connected to each other via links.
 
 **Graph Data Structure**
 
 Mathematical graphs can be represented in data structure. We can represent a graph using an array of vertices and a two-dimensional array of edges.
 
 - **Vertex** − Each node of the graph is represented as a vertex. In the following example, the labeled circle represents vertices. Thus, A to G are vertices. We can represent them using an array as shown in the following image. Here A can be identified by index 0. B can be identified using index 1 and so on.
 - **Edge** − Edge represents a path between two vertices or a line between two vertices. In the following example, the lines from A to B, B to C, and so on represents edges. We can use a two-dimensional array to represent an array as shown in the following image. Here AB can be represented as 1 at row 0, column 1, BC as 1 at row 1, column 2 and so on, keeping other combinations as 0.
 - **Adjacency** − Two node or vertices are adjacent if they are connected to each other through an edge. In the following example, B is adjacent to A, C is adjacent to B, and so on.
 - **Path** − Path represents a sequence of edges between the two vertices. In the following example, ABCD represents a path from A to D.
 
 **Depth First Search (DFS) Algorithm**
 
 ![](depth_first_traversal.jpg)
 
 - **Rule 1** − Visit the adjacent unvisited vertex. Mark it as visited. Display it. Push it in a stack.
 - **Rule 2** − If no adjacent vertex is found, pop up a vertex from the stack. (It will pop up all the vertices from the stack, which do not have adjacent vertices.)
 - **Rule 3** − Repeat Rule 1 and Rule 2 until the stack is empty.
 
 Depth First Search: S A D G E B F C
 
 **Breadth First Search (BFS) Algorithm**
 
 ![](breadth_first_traversal.jpg)
 
 - **Rule 1** − Visit the adjacent unvisited vertex. Mark it as visited. Display it. Insert it in a queue.
 - **Rule 2** − If no adjacent vertex is found, remove the first vertex from the queue.
 - **Rule 3** − Repeat Rule 1 and Rule 2 until the queue is empty.
 
 Breadth First Search: S A B C D E F G
 
 ### Q. Explain the difference between directed (digraph) and undirected graphs, and how this affects traversal.
 
 In a graph data structure, **the primary difference between directed and undirected graphs lies in the nature of the relationship (edge) between nodes.** This distinction fundamentally changes how traversal algorithms like BFS and DFS behave.
 
 ![](graph_directed_undirected.png)
 
 
 */

//: [Next](@next)
