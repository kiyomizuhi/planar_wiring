# planar_wiring
This code generates a planar wiring scheme for a set of randomly distributed semiconducting nanowires. Concretely, it generates center paths for such leads and a .gds file with polygons drawn along the generated paths with specified width for each segments. The important point is that these polygons must never be overlapping each other to function as independently controlled electric leads.

These semiconducting nanowires are randomly distributed on a sillicon substrate surface, which need to be connected via metallic leads and gates to form devices. Due to their random locations, formerly people had to draw polygons of such planar wiring with a layout editor (CAD software, .gds files). The present code is written in Matlab and is built upon a library which a former lab member Nissim Ofek created. The library is written in Matlab/C++ and does I/O with layout editor and polygon generations. This repo does not include his library but only include the codes I wrote.



## Nanowire device images taken with scanning electron microscope
An example target nanowire to be wired

<img width="400" alt="screen shot 2017-11-25 at 2 20 45 pm" src="https://user-images.githubusercontent.com/19827262/33230439-07dadc94-d1ec-11e7-8548-fb77862c8fb0.png">

An example nanowire device with metallic fingers on top

<img width="400" alt="screen shot 2017-11-25 at 2 21 54 pm" src="https://user-images.githubusercontent.com/19827262/33230441-081b94aa-d1ec-11e7-9d76-6705f3d0c437.png">

Zoom out image of above

<img width="400" alt="screen shot 2017-11-25 at 2 21 25 pm" src="https://user-images.githubusercontent.com/19827262/33230440-07fb7792-d1ec-11e7-877a-1c75b0dacf94.png">



## CAD drawing of the devices
This contains entire devices. There are 2 x 4 dies. Each die contains about 8 devices.

<img width="300" alt="whole" src="https://user-images.githubusercontent.com/19827262/33230668-61d41ce8-d1f0-11e7-88c0-f4663975932e.png">


A zoomin to one of the dies. The blue ones are the metallic leads that have been drawn manually so far.

<img width="400" alt="die" src="https://user-images.githubusercontent.com/19827262/33230666-61928b48-d1f0-11e7-8f8b-9b8650d97775.png">

A further zoomin. You can see the similar "finger"-like metallic leads.

<img width="400" alt="diezoom" src="https://user-images.githubusercontent.com/19827262/33230667-61b3826c-d1f0-11e7-83d4-d73ca088ae5c.png">



## flow of the code

This code assumes fingers were desinged manually as often preferred and have been placed by hands on the wires on gds. We decompose the problem into

#### 1: extract the entry points and directions for each nanowire from gds
#### 2: group up the bonding pads (yellow pads above) and nanowires to be connected
#### 3: find paths for the leads to the vicinity of the nanowire (called outer frames)
#### 4: find paths for the leads from the entries points to the leads from the bonding pads. (called inner frames)
#### 5: output the connected paths for leads
#### 6: draw the lead polygons on gds

What are outer frame nodes and inner frame nodes? We introduce square frames with respect to each wire in the vicinity of each. By default, there are 6 layers of inner frames and 1 layer of outer frame. Each frame has 20 nodes (5 nodes on each side). The reason why there are multiple inner frames is to accomodate more leads in a compactly and safely. These frames mediate the connections of the leads coming from the bonding pads and nanowires for each nanowire. Note again that no leads should cross each other.

Note that I have not introduced a mechanism to avoid crossing in the case of having two wires very close (say, less than 30 microns). In such a case, you would have to manually erase the crossed path and draw new leads manually that do not cross each other!!!

##### 1: extract the entry points and directions for each nanowire from gds
Input data: gds of the finger polygons to be used and the absolute coordinates of the both edges of the wires. The arrows indicates the entry points and directions of the leads to be connected.

<img width="300" alt="fingers" src="https://user-images.githubusercontent.com/19827262/33232799-12277562-d215-11e7-9547-c68ffea17568.png">

By rotate and translate the fingers to each nanowire, specified in the input file, we find the exact entry points and directions (shown as arrows in the image below) for each wire. We also find the number of leads that each nanowire requires. The green line is the wire and the red point is the center of the wire

<img width="400" alt="path_zooomin" src="https://user-images.githubusercontent.com/19827262/33230304-6541c6fc-d1e9-11e7-9fb1-189ad7b1813b.png">


##### 2: group up the bonding pads (yellow pads above) and nanowires to be connected
##### 3: find paths for the leads to the vicinity of the nanowire (called outer frames)

Now, we have to group up the bonding pads and nanowires to be connected. Trying all the possible permutations is simply not realistic as we deal with about 50 nodes. This is done by priotizing the closeness between them and by trying to use pads as contiguous as possible. Once done that, we have to draw the leads between the bonding pads and wires but up to the outer frames (the green frames). The exact paths are found by discretizing the die (putting a grid), treating it as a graph problem and performing breath first search between corresponding nodes. Let's say we cosider finding a path between a nanowire and one of the assigned bonding pad. First, we set the grid point closest to the nanowire as the start and the boding pad as the goal and classify unvisted (unused) nodes on the grid by their path distances from the nanowire. Then, switching the role of the start and goal, we traverse from the bonding pad and advance toward the nanowire. At every step, in order to pick the next node among the neighboring unvisited nodes, we give it a preference to choose a node that has the shortest distance to the nanowire. Once we reach the outer frame of the nanowire, we stop the iteration and that would be the selected path. 

<img width="400" alt="grid" src="https://user-images.githubusercontent.com/19827262/33230190-7ef34ea6-d1e7-11e7-8b88-1f55d5c14136.png">

This is an zoom up of one of the outer frames. The green lines are the leads. The orange (blue) frame is the outer (inner) frame and there are 20 nodes on each.

<img width="400" alt="frame_zooomin" src="https://user-images.githubusercontent.com/19827262/33230301-5b63ce3c-d1e9-11e7-9457-6398d21652c7.png">


#### 4: find paths for the leads from the entries points to the leads from the bonding pads. (called inner frames)
Here, we have to pair up the nodes on the inner frames (which node on which layer) and entry points. However, it does not make sense to try all the permutations. We first sort the entry points by couter-clockwise because pairing between non-sorted nodes would end up crossed paths. On top of this, the important point to notice is that there cannot be any lead that make a full turns with respect to the nanowire. Such lead would block other leads to pass without crossing. Given these constraints, let us denote the entry points and inner nodes according to the sorted order. Then, we try out pairing by shifting with respect to each other. For each case, if any pair end up making a full turn, we reject such pairing scheme. If not, we proceed and count how many layers they end up occupying. In the end, we choose a scheme that minimizes the number of used inner frames. This is to keep the leads as compact as possible.

<img width="600" alt="innerleads" src="https://user-images.githubusercontent.com/19827262/33230189-7728577a-d1e7-11e7-8e0b-e6e523f6e7d0.png">

#### 5: output the connected paths for leads
Now, let's see the generated leads. Note that this is still plotted on Matlab figures and not real polygons on gds yet. The green part is the segments between the bonding pads and outer frames and the purple part is the segments between the nanowire and inner frames. 

<img width="400" alt="leads" src="https://user-images.githubusercontent.com/19827262/33230177-53593f4e-d1e7-11e7-889a-c3fd90299611.png">

A zoomin to one of the wires.

<img width="400" alt="path_zoomin" src="https://user-images.githubusercontent.com/19827262/33230303-60659ad2-d1e9-11e7-86da-29e5d835bf35.png">

A further zoomin.

<img width="400" alt="path_zooomin" src="https://user-images.githubusercontent.com/19827262/33230304-6541c6fc-d1e9-11e7-9fb1-189ad7b1813b.png">


#### 6: draw the lead polygons on gds
Now, let's see the outcome. Not that the output path data contains the widths and layer information as well.

<img width="400" alt="output" src="https://user-images.githubusercontent.com/19827262/33233026-a2b56b68-d218-11e7-8cbe-fdb0ec51e5a6.png">

<img width="400" alt="plg_zooomin" src="https://user-images.githubusercontent.com/19827262/33233027-a2f28476-d218-11e7-8ecd-54de1067b38a.png">
