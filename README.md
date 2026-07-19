# Slav License

Everything in this repository is licensed under the **Slav License**.

## Permissions

You are free to:

- Modify any source code.
- Edit, improve, or rewrite any scripts.
- Customize the project however you like.
- Learn from, experiment with, and build upon the code.
- Use this project freely for personal or public projects.

This repository is provided for learning, development, and experimentation.

## Restrictions

The following may **NOT** be removed, reused, or redistributed:

- Credits to the original creator.
- Custom icons.
- Logos.
- Branding.
- Profile images.
- Any original artwork created specifically for this project.

These assets are exclusive to this repository and may not be used in other projects without permission from the creator.

If you fork or redistribute this repository, all credits must remain intact.

---

# RDI

## Runtime Data Inspector

RDI is a runtime DataModel inspection utility built with Luau buffers.

It allows users to inspect and understand runtime objects through:

- Runtime hierarchy visualization.
- Instance tracking.
- Object searching.
- Timeline events.
- Performance statistics.
- Relationship graph visualization.
- Buffer-based snapshot storage.

RDI is free to use.

You can take it, modify it, learn from it, or build upon it. There are no usage restrictions on the source code itself as long as credits and original project assets remain intact.

---

# Testing RDI

You can load RDI directly using:

```lua
local url = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/RDI/RobloxRDI.luau"
--asodkop smth rq
local success, result = pcall(function()
	return loadstring(game:HttpGet(url))()
end)

if success then
	print("RDI Loaded Successfully")
else
	warn("RDI Failed To Load:")
	warn(result)
end
