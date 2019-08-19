
# priv_protector for minetest

Adds a protection block that checks the priv of the builder/digger

## Usage

Define a few global privs that you want to give out to trusted builders:
```
minetest.register_privilege("protect_streets", {
	description = "Protection for common streets"
})
```

Place the priv_protector block and change the "Privilege" field to `protect_streets` or whatever you want to protect with

