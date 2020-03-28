module ImageChipper
    using ObjectDetectionStats#, Images, FileIO, ImageMagick

    function chip(  img::Matrix,
                    chip_size::Tuple{Int, Int}      = ( 128, 128 ),
                    overlap::Tuple{Float64,Float64} = ( 0.0, 0.0 ) )
        width, height   = size( img )
        chips           = Int.( ceil.( [ width, height ] ./ chip_size ) ) #.+ 1
        overlap_factor  = chip_size
        if overlap != ( 0.0, 0.0 )
            chips = Int.( ceil.( ( chips .- 1.0 ) .* ( 1.0 ./ overlap ) ) )  #.+ 1
            overlap_factor = [  floor( chip_size[ 1 ] * ( overlap[ 1 ] ) ),
                                floor( chip_size[ 2 ] * ( overlap[ 2 ] ) ) ] .|> Int
            @assert( !any( overlap_factor .≈ chip_size ), "Requested overlap for at least one dimension is infinite. Please choose a smaller value.")
        end
        chip_view = Array{ eltype(img),3 }( undef, ( chip_size[ 1 ], chip_size[ 2 ], prod( chips ) ) )
        chip_count = 1
        for col in 1 : chips[1], row in 1 : chips[ 2 ]
            x = ( row - 1 ) * overlap_factor[ 1 ]
            X = ( x + 1 ) : ( x + chip_size[ 1 ] )
            y = ( col - 1 ) * overlap_factor[ 2 ]
            Y = ( y  + 1 ) : ( y + chip_size[ 2 ] )
            #if the last row/column then go to the extent of the image
            Y = (col == chips[1]) ? ( ( height - chip_size[ 2 ] + 1 ) : height ) : Y
            X = (row == chips[2]) ? ( (  width - chip_size[ 1 ] + 1 ) : width  ) : X
            chip_view[:,:,chip_count] = view( img, X, Y )
            chip_count += 1
        end
        return chip_view
    end
    export chip

    function chip_with_boxes(   img::Matrix,
                                boxes::Vector{ObjectDetectionStats.Box},
                                chip_size::Tuple{Int, Int}      = ( 128, 128 ),
                                overlap::Tuple{Float64,Float64} = ( 0.0, 0.0 ),
                                IoU_threshold::Float64          = 0.0 )
        width, height   = size( img )
        chips           = Int.( ceil.( [ width, height ] ./ chip_size ) ) #.+ 1
        overlap_factor  = chip_size
        if overlap != ( 0.0, 0.0 )
            chips = Int.( ceil.( ( chips .- 1.0 ) .* ( 1.0 ./ overlap ) ) )  #.+ 1
            overlap_factor = [  floor( chip_size[ 1 ] * ( overlap[ 1 ] ) ),
                                floor( chip_size[ 2 ] * ( overlap[ 2 ] ) ) ] .|> Int
            @assert( !any( overlap_factor .≈ chip_size ), "Requested overlap for at least one dimension is infinite. Please choose a smaller value.")
        end
        chip_view = Array{ eltype(img),3 }( undef, ( chip_size[ 1 ], chip_size[ 2 ], prod( chips ) ) )
        chip_count = 1
        boxes_in_chip = Dict()

        for col in 1 : chips[1], row in 1 : chips[ 2 ]
            x = ( row - 1 ) * overlap_factor[ 1 ]
            X = ( x + 1 ) : ( x + chip_size[ 1 ] )
            y = ( col - 1 ) * overlap_factor[ 2 ]
            Y = ( y  + 1 ) : ( y + chip_size[ 2 ] )
            #if the last row/column then go to the extent of the image
            Y = (col == chips[1]) ? ( ( height - chip_size[ 2 ] + 1 ) : height ) : Y
            X = (row == chips[2]) ? ( (  width - chip_size[ 1 ] + 1 ) : width  ) : X
            chip_view[:,:,chip_count] = view( img, X, Y )
            chip_box = ObjectDetectionStats.Box( first(X), first(Y), last(X), last(Y) )
            boxes_in_chip[ chip_count ] = [ i for (i, box) in enumerate( boxes )
                                            if intersection_over_union(chip_box, box) > IoU_threshold ]

            chip_count += 1
        end
        return chip_view, boxes_in_chip
    end

    export chip, chip_with_boxes

end # module
