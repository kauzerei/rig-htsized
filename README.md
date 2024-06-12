# Htsized Rig
Customizable 3d-printable parts for building RigHtsized camera Rig. 
## Rightsized cage
The idea is to use a 3d-model of a camera (for example by 3d-scanning it using photogrammetry) and helper functions to define the perfect shape of a cage, that fits specifically your camera and your vision of comfort.

'cage.scad' contains coordinate-visualization tools to help designing and modules that help generating the part.

'cage_sony_nex_f3.scad' and 'cage_olympus_e-pm1.scad' are cages for particular cameras, made with those tools.

## Rightsized rod nounts
Clamps and other parts to build the rail system and to mount things on it.

Skewed parts with offset holes allow to have access to all screws from one side without collisions.
For example, you can mount the spacers to the bottom of the cage, then the rail system to the bottom of spacers, while still maintaining acces to the screws holding the cage.

## Rightsized grips
Ergonomic handles, that fit user's hands.

The idea is to sculpt a handle out of some modelling material, take some measurements and use them to generate tailored 3d-printable smooth grips.

The full description of the process is to be written, but in short it looks like this:

Take a piece of modelling putty about 100mm high, 30mm wide and about 40mm in the third dimension.

Press it slightly inside your hand to feel more comfortable.

Round its edges, and reshape it a little to be of the same height and width as initially.

Repeat the process several times, making it more comfortable to hold with each iteration while constraining its shape to something oblong in horizontal cross-section, constant width and without sharp edges.

Measure coordinates of key points (edges, high and low points, etc) of the shape using caliper, photograph or scan of the object in image editor and put them into array, the OpenSCAD module reconstructs the surface from them.

## Rightsized plate
Manfrotto-501-style tripod plate with hole raster.
Those plates are used in multiple tripods and stabilized gimbals.
They may slightly differ from original Manfrotto design, that's why the model is fully customizable.
You can change width and height of the mechanical features to fit the shape of your gear, try on shorter length to save material.
You can change the length to fit the amount of your gear: use longer plate if you use wide range of lens/accessories masses to always be able to slide the plate in tripod/stab to find balance without unscrewing the plate from the camera.

