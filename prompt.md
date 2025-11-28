Goal
----
Improve the app navigation by replacing the current static menu behavior with a compact, accessible dropdown anchored to the `Icons.menu` button and enabling nested, navigable dropdowns.

Background
----------
Currently the app shows top-level navigation via `NavButton()` and `NavDropdown()` in `NavBar()` (in `lib/main.dart`). The request is to make the menu more compact (hamburger-triggered) while keeping all existing navigation items and enabling nested dropdown navigation where a dropdown entry can open a new set of options and provide an explicit "back" item.

Requirements
------------
1. Hamburger menu
	- Replace the existing `Icons.menu` behaviour so that tapping the hamburger opens a dropdown menu (or popover) containing the same items that currently appear as `NavButton()` and top-level `NavDropdown()` entries.

2. Reusable `ProductDropdown` / `NavDropdown` behaviour (nested navigation)
	- Modify `NavDropdown()` (or the shared dropdown widget) so that selecting a dropdown item can either:
	  a) navigate directly to a route (existing behaviour), or
	  b) replace the current dropdown content with a new set of options (nested submenu).
	- When a nested submenu is opened, the dropdown should show a first item that navigates back to the previous menu. The back item should display the previous menu heading text prefixed with a left angle bracket, e.g. "< Category" or "< Back to Products".

3. API & Component contract
	- `NavBar()` / `NavDropdown()` should accept an expressive data model that supports both leaf items and nested groups. Example idea:
	  - class MenuItem { final String label; final String? route; final List<MenuItem>? children; }
	- If `children` is present, selecting that item opens a nested menu instead of navigating.
	- Provide an optional callback `onNavigate(String route)` and `onOpenMenu()` / `onCloseMenu()` hooks.

4. Visual & UX details
	- The hamburger dropdown should be visually aligned with the app header and match existing styling (colors, padding, font-size) used by `NavButton()`.
	- When opening a nested submenu, animate the change (slide right) so the transition is obvious.
	- Provide a clear back item as the first row in a nested view with the exact text `"< {heading}"` where `{heading}` is the parent menu title.

5. Accessibility
	- Ensure all dropdown/menu elements are focusable and announce their role to screen readers.
	- The back item must be properly labeled for screen readers.

Acceptance criteria
-------------------
- Tapping `Icons.menu` opens a dropdown with the same set of items currently available via `NavButton()` and `NavDropdown()`.
- Selecting an item with `children` replaces the dropdown content with the child list and shows a first-row "< {heading}" back item.
- Pressing the back item returns to the previous dropdown content.
- Choosing a leaf item (no children) navigates to the intended route and closes the dropdown.
- The implementation exposes a simple data model for menu definition and hooks for navigation events.

Implementation notes / suggestions
-------------------------------
- Implement a small `MenuModel` (list of `MenuItem`) and build the dropdown UI from this data structure.
- For nested views, maintain a stack of `MenuItem` lists in state (push child list on open, pop on back).
- Reuse the existing `NavButton()` styles for menu rows to keep consistent visuals.
- Keep the dropdown widget generic so it can be used in other screens (collection page, product page) if needed.