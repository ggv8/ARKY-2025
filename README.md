# ARKY-2025

This is a personal repository where I host the different assignments I worked and completed for the Computer Architecture Course at my university. The assignments reflect my progress in x86 Assembly programming throughout the semester. All projects were designed to run in the DOSBox emulator using TASM per course instructions. The repository features a template file that was provided by the teacher, but I took the liberty to modify and improve it as my understanding of x86 architecture and low-level programming improved. The documentation for each program is provided as comments at the start of the source, along a self-evaluation tool that was required to turn it in.

Since this was for archival purposes originally, I used short names for each project folder where *t* stands for homework followed by its assignment number, and *c* stands for classwork. This was a short sighted decision, so I will briefly explain what each assignment was.

#### arkyT1
Introductory homework that reads a width, height, and numerical-base arguments to display a character-based shape. It isn't thorough in error checking by specification, and it provides a brief help message if no arguments are provided.

#### t2
This project challenged the student to read two fraction numbers and an operator from the command line as inputs. Then the program would solve the operation (if an overflow was not triggered), and output the result both as a fraction and its spelling. Error checking is more thorough for inputs and run-time exceptions.

#### t3
This program aims to extend arithmetic capabilities by handling number inputs as decimal string representations rather than binary values. It must first receive a code that triggers a mathematical operation. It will then request additional user input to fulfill operand requirements (unary, binary, tertiary). The output is printed back to the user if the operation is successful.

#### t4
For this homework, the challenge was to learn how to create, read, update, and delete text files using system interrupts. The context was to develop a command-line based text editor, similar to the previous assignment. It receives arguments that trigger a specific function like creating, writing, or erasing contents at a file path's line and column.

#### c1
Demo of the computational model known as Langton's Ant. It features a predefined matrix map for the ant to travel in it. It then prints the map's representation before and after runnning the model.

#### t5
In this assignment the goal was to recreate a board game known as Kulami using text-based graphics. Not fully implemented, but the design was partially complete.

#### t6
Another attempt to recreate a game, this time it is the arcade video game Qix. It is also partially complete. It uses text based graphics, it features both the player and enemy character, movement controls, and a pause menu. It lacks different levels of difficulty and the full implementation of the game logic, though it was designed fully.

#### t7
This assignment tasked me to implement Hanoi's recursive algorithm using the stack to handle variables and parameters. It then had to display a string representation of each step it took to validate its functionality.

#### t8
In this short homework, the goal was to adapt the first assingment's structure to be compiled as a .COM program instead of an .EXE program.

#### t9
The final challenge was to use interrupts to display custom images in VRAM. A set of flags was assigned to each student, and the program must display it accordingly given an input. The true challenge was implementing Bresenham's line algorithm as well as a circle rasterization routine to properly draw some flag elements.

## How to Run (DOSBox setup)
1. Mount the repository folder inside your DOSBox environment.
2. Compile the target file: `tasm filename.asm`
3. Link the object file: `tlink filename.obj`
4. Execute the binary: `filename.exe`
