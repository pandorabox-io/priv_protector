
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

# Area integration

Additional `area` mod commands:

* `area_priv_set` Sets a  privilege for the area (the area needs to be opened with `/area_open <id>` for this to work)
* `area_priv_get` Returns the privilege, if any, required for that area
