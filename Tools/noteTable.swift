//

//var rawNoteTable = [261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88]   // C4
//var rawNoteTable = [523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880.00, 932.33, 987.77]   // C5
var rawNoteTable = [130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.08, 246.94] // C3
var zebraNote_R0 = [Int]()
var zebraNote_R1 = [Int]()
var zebraNote_R = [Int]()
let Fi = 1750000

 for i in rawNoteTable {
     let myNote_1 = 16.0 * i
     let myNote_2 = Fi/Int(myNote_1)
     zebraNote_R.append(myNote_2)   
 }

  for i in zebraNote_R {
     if  i > 255 {
        
        zebraNote_R0.append(i - 256*(i/256)) 
        zebraNote_R1.append(i/256)  
     }else {
         zebraNote_R0.append(i) 
         zebraNote_R1.append(0) 
     }
       
 }

print("==========R========")
print(zebraNote_R)
print("==========R0========")
print(zebraNote_R0)
print("==========R1========")
print(zebraNote_R1)
 