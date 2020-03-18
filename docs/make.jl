using Documenter, ImageChipper

makedocs(;
    modules=[ImageChipper],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/caseykneale/ImageChipper.jl/blob/{commit}{path}#L{line}",
    sitename="ImageChipper.jl",
    authors="Casey Kneale",
    assets=String[],
)

deploydocs(;
    repo="github.com/caseykneale/ImageChipper.jl",
)
