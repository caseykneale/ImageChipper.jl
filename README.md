# ImageChipper.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://caseykneale.github.io/ImageChipper.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://caseykneale.github.io/ImageChipper.jl/dev)
[![Build Status](https://travis-ci.com/caseykneale/ImageChipper.jl.svg?branch=master)](https://travis-ci.com/caseykneale/ImageChipper.jl)
[![Codecov](https://codecov.io/gh/caseykneale/ImageChipper.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/caseykneale/ImageChipper.jl)
[![Coveralls](https://coveralls.io/repos/github/caseykneale/ImageChipper.jl/badge.svg?branch=master)](https://coveralls.io/github/caseykneale/ImageChipper.jl?branch=master)
[![Build Status](https://api.cirrus-ci.com/github/caseykneale/ImageChipper.jl.svg)](https://cirrus-ci.com/github/caseykneale/ImageChipper.jl)

## Overview

### Image chipping
```Julia
faux_image = rand( 256, 256 )
# chip( image/Matrix, ( Chip width, Chip height ), ( Overlap X, Overlap Y ) )
chipped = chip( faux_image, ( 64, 64 ), ( 0.0, 0.0 ) )
```
where the returned array is a 3-tensor of size `( Chip width, Chip height, Chip # )`

### Image chipping with labels
images with associated bounding boxes may also be chipped with known [ObjectDetectionStats.jl](https://github.com/caseykneale/ObjectDetectionStats.jl) bounding boxes.

```Julia
faux_image = rand( 256, 256 )

boxes = [   Box(   1,   1,  22,  22 ),
            Box(  55,  55, 222, 222 ),
            Box( 222, 222, 264, 264 )   ]
IoU_thresh = 0.0
chips, boxassignments = chip_with_boxes( faux_image, boxes, ( 64, 64 ) ( 0.0, 0.0 ), IoU_thresh )
```

Enjoy!
