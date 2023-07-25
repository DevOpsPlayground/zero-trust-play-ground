pacakge hello

default allow_hello = false

default allow_world = false

default allow_new_world = false

default hello := false

allow_hello {
    "hello" != ""
}

allow_world {
    "world" != "world"
}

allow_new_world {
    "world" == "world"
}


hello if input.message == "world"

input := {
    "message": "world"
}