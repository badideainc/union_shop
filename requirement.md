**Overview**

- **Purpose:** Replace the current top-level navigation with a hamburger-triggered dropdown that contains the same items as `NavButton()` and top-level `NavDropdown()` and supports nested, navigable submenus with a clear "back" action.
- **Files to change:** `lib/main.dart` (NavBar), shared dropdown component (existing `NavDropdown()` or `ProductDropdown()`), related styles and any pages that currently use `NavButton()` / `NavDropdown()`.

**Functional Requirements**

- **FR-1 — Hamburger menu:** Tapping the `Icons.menu` (hamburger) opens a dropdown/popover that lists the same navigation items currently exposed by `NavButton()` and top-level `NavDropdown()` entries.
- **FR-2 — Nested menus:** A dropdown item may either be a leaf (navigates to a route) or a parent with `children` (opens a nested menu replacing the current list).
- **FR-3 — Back navigation:** When a nested menu is active, the first item must be a back entry with text `"< {heading}"` where `{heading}` is the parent menu title. Activating the back entry returns to the previous menu.
- **FR-4 — Close behavior:** Selecting any leaf navigation item closes the dropdown and navigates to the route. The dropdown is also dismissible by tapping outside, pressing Esc, or selecting a close action.
- **FR-5 — Hooks & callbacks:** The dropdown component must provide optional callbacks for `onNavigate(String route)`, `onOpenMenu()`, and `onCloseMenu()` so the host app can react to navigation and menu visibility.

**Data Model**

- **MenuItem** (recommended):
  - `label` (String): visible text.
  - `route` (String?, optional): navigation target (leaf items set this).
  - `children` (List<MenuItem>?, optional): nested submenu items.
  - `icon` (IconData?, optional): optional icon for the row.
  - `id` (String?, optional): stable identifier for analytics or tests.

**Non-Functional Requirements**

- **NFR-1 — Accessibility:** All menu items must be reachable by keyboard and announced to screen readers with appropriate roles and labels. The back item must also be accessible.
- **NFR-2 — Performance:** Dropdown open/close and nested transitions must be smooth (target 60fps on supported devices). Avoid expensive rebuilds on each keystroke.
- **NFR-3 — Reusability:** Implement the dropdown as a generic, reusable widget that accepts `List<MenuItem>` and optional callbacks.

**UI & UX Details**

- **Placement:** The dropdown is anchored to `Icons.menu` in the `NavBar` and visually aligned with the header.
- **Animation:** When opening a nested submenu, animate the transition (suggested: slide-right for entering child, slide-left for returning). Keep animation subtle and fast (e.g., 150–250ms).
- **Back row:** The back row is the first visible row in any nested view and should use a left-angle glyph + parent heading: `"< {heading}"`.
- **Styling:** Reuse the `NavButton()` row styling for menu rows (padding, font-size, colors). Ensure contrast meets accessibility standards.

**Accessibility Requirements**

- Elements expose semantic roles (e.g., `role=menu`, `role=menuitem`) and labels.
- Manage focus: when opening the menu, focus the first actionable item; when closing, return focus to the hamburger icon.
- Keyboard interactions: Arrow keys move focus, Enter activates, Esc closes, Home/End navigate to first/last.

**Acceptance Criteria**

- **AC-1:** Tapping the hamburger opens a dropdown containing the same items as the current top-level navigation.
- **AC-2:** Selecting a MenuItem with `children` replaces the dropdown content with the child list and shows a back entry `"< {heading}"` at the top.
- **AC-3:** Selecting the back entry returns to the previous list.
- **AC-4:** Selecting a leaf MenuItem navigates to that route and closes the menu.
- **AC-5:** Keyboard navigation and Esc-to-dismiss work for both top-level and nested menus.
- **AC-6:** The implementation exposes `MenuItem` data model and `onNavigate` / `onOpenMenu` / `onCloseMenu` hooks.

**Implementation Notes & Suggestions**

- Use a stack to manage nested menus in state: push `children` when navigating into a submenu and pop on back.
- Provide a small helper to convert existing navigation definitions (e.g., current `NavDropdown()` data or static route lists) into `MenuItem` structures so migration is straightforward.
- Keep the dropdown widget generic and small: separate responsibilities between data stack management and row rendering.
- Consider using `PopupMenuButton`/`Overlay`/`CompositedTransformFollower` for anchoring the dropdown; for complex nested content prefer a custom `OverlayEntry` to control the animation and focus.

**Testing**

- Unit tests for menu stack behavior (push/pop/back logic) and for correct `onNavigate` calls.
- Widget tests to ensure keyboard navigation, focus handling, and Back row presence in nested views.
- Manual accessibility verification with a screen reader and keyboard-only navigation.

**Migration Plan**

- Step 1: Implement `MenuItem` and the generic dropdown widget with `onNavigate` hooks.
- Step 2: Replace `NavDropdown()` usage in `NavBar()` with the new dropdown anchored to `Icons.menu` and map existing items to `MenuItem`.
- Step 3: Update other pages (if any) that rely on the old dropdown API to use the new data model; provide a compatibility adapter if needed.

**Open Questions**

1. Should the hamburger be used on all screen sizes or only on narrow screens (mobile)?
2. Should nested menus be limited to a single level or support arbitrary depth? (Implementation can support arbitrary depth, but UI/UX should be validated.)

**Deliverables**

- Updated `requirement.md` (this file).
- A reusable dropdown component under `lib/widgets/` or `lib/components/` (e.g., `lib/widgets/nav_menu.dart`).
- Migration patches for `NavBar()` in `lib/main.dart` and any pages that used `NavDropdown()`.

If you want I can now implement the dropdown component and replace `NavBar()` usage in `lib/main.dart` as a next step. Please confirm whether the hamburger should appear on desktop as well or be limited to small screens.
