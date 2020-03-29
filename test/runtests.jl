using ImageChipper
using Test

@testset "Image Chipping" begin
    faux_image = rand( 256, 256 )
    chip_dims = ( 64, 64 )
    chipped = chip( faux_image, chip_dims, ( 0.0, 0.0 ) )
    #checkoutput dimensionality
    @test all( size(chipped)[1:2] .== chip_dims )
    @test size(chipped)[3] == 16
    @test all( chipped[:,:,1] .== faux_image[ 1:chip_dims[1], 1:chip_dims[2] ] )
    @test all( chipped[:,:,end] .== faux_image[   (end - chip_dims[1] + 1):end,
                                        (end - chip_dims[2] + 1):end ] )
    #checkoutput dimensionality
    chipped = chip( faux_image, ( 60, 60 ), ( 0.0, 0.0 ) )
    @test size(chipped)[3] .==  25
    #checkoutput dimensionality
    chipped = chip( faux_image, ( 32, 32 ), ( 0.0, 0.0 ) )
    @test size(chipped)[3] .==  64
end

@testset "Image Chipping with Boxes" begin
    using ObjectDetectionStats
    faux_image = rand( 256, 256 )
    chip_dims = ( 128, 128 )

    boxes = [   ObjectDetectionStats.Box(   1,   1,  22,  22 ),
                ObjectDetectionStats.Box(  55,  55, 222, 222 ),
                ObjectDetectionStats.Box( 222, 222, 264, 264 )   ]

    chips, boxassignments = chip_with_boxes( faux_image, boxes, chip_dims, ( 0.0, 0.0 ), 0.0 )

    @test( length(boxassignments[ 1 ]) == 2 )
    @test( length(boxassignments[ 2 ]) == 1 )
    @test( length(boxassignments[ 3 ]) == 1 )
    @test( length(boxassignments[ 4 ]) == 2 )
end
