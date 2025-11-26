Goal
Add two small interactive controls to each cart item row in CartWidget on the Cart screen:
1) a "remove" TextButton that removes the product from the cart and the UI row, and
2) a quantity editor: a "Quantity" label, a TextField (hint = current quantity) and an "Update" button using ImportButtonStyle() that updates the ProductModel.quantity.

Constraints / non‑goals
- Change only the CartWidget code in lib/views/cart_screen.dart (or the widget file that renders each cart item) and any direct calls required to update ProductModel or CartModel already in the project.
- Do NOT change unrelated files or add helper files/functions.
- Respect existing state management (use the existing CartModel / ProductModel API). If the project uses Provider, use context.read / context.watch only; do not introduce a new state system.
- Keep commits small: one focused change implementing these controls (UI + handlers) in this file.

Files to modify
- lib/views/cart_screen.dart (the CartWidget / cart item row rendering)

UI requirements (exact)
- For each cart item row, below the existing product info, add a single horizontal Row with three elements:
  - TextButton("remove")
    - onPressed: remove the product from the cart (call CartModel API or update ProductModel.quantity to zero and notify listeners) and remove the row from the UI.
    - Use descriptive semantics for accessibility (tooltip/semantics label optional).
  - SizedBox(width: 12)
  - Row (inline) containing:
    - Text("Quantity")
    - SizedBox(width: 8)
    - TextField
      - keyboardType: TextInputType.number
      - controller: a short-lived TextEditingController prefilled with empty but with hintText set to current quantity (e.g. hintText: product.quantity.toString()).
      - input formatting: allow only digits (you may use a simple onChanged parsing). Do not add complex validators.
    - SizedBox(width: 8)
    - ElevatedButton (or Widget that uses ImportButtonStyle())
      - child: Text("Update")
      - style: use ImportButtonStyle() exactly as available (do not invent a new style).
      - onPressed: parse the value entered (int), if valid call the ProductModel quantity setter or CartModel API to update quantity and then call notifyListeners() (or the existing update method).
- Keep layout responsive: the controls row can wrap on small screens. Use Flexible/Expanded for the TextField as needed.

Behaviour requirements (exact)
- Remove action:
  - When remove is tapped, remove that product from the CartModel (or set its quantity to zero and call CartModel.notifyListeners()).
  - The UI should update so the removed item row no longer displays.
- Update action:
  - Parse the number from the TextField; if parse fails, do nothing or optionally show a minimal inline error (not required).
  - On successful parse, set product.quantity = parsedValue (or call CartModel.updateQuantity(productId, parsedValue) if such API exists), then notify listeners so UI updates.
  - If the parsed quantity is less than or equal to 0, remove the product from the cart (i.e., call the same removal behavior as the "remove" button) and ensure the UI row disappears.
  - Do not create new helper functions; call existing model methods or mutate existing ProductModel as your project already does.
- Do not implement persistence or backend calls—this is in-memory cart only.

Edge cases & robustness
- If product.quantity is null or unavailable, default hint to "1".
- Do not clamp values unless a clamp exists in the current ProductModel; if clamp is not present, accept any integer (follow your project’s existing rules).
- Protect against null controllers: create/destroy local TextEditingController in the item widget lifecycle (dispose when appropriate).
- Keep operations synchronous and quick; call notifyListeners() after updates.

Acceptance criteria (tests/manual)
- For a sample cart item, the cart row now shows the new controls under the existing info.
- Pressing "remove" immediately removes the item from CartModel and the row disappears.
- Entering a numeric value in the TextField and pressing "Update" changes the product quantity in ProductModel / CartModel and UI updates to reflect the new quantity and recalculated totals.
- Entering a value <= 0 and pressing "Update" removes the item from the cart and the row disappears.
- No unrelated files were modified.
- The Update button uses ImportButtonStyle() exactly as present in the project.

Deliverable requested from LLM
- A single small commit patch (one file: lib/views/cart_screen.dart) that:
  1. Adds the controls to each cart item row as described.
  2. Hooks "remove" to the existing CartModel/ProductModel remove/decrease behavior.
  3. Hooks "Update" to set the ProductModel quantity and call notifyListeners() (or call CartModel API), and removes the item when the entered quantity is <= 0.
- Include a one-sentence explanation of the change and the exact diff/patch to apply.

Notes for implementer
- If the cart item is rendered by a separate subwidget (e.g., CartItemWidget), modify that widget. If rows are built inline, add the controls inside the map/list builder.
- Use context.read<CartModel>() or direct ProductModel mutation depending on existing code pattern; keep consistent with the codebase.
- Follow project style: padding, spacing and font style should reuse existing widgets where possible.

End.