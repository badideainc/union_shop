CartWidget — Requirements
1. Feature overview
Add two interactive controls to each cart item row in the CartWidget (lib/views/cart_screen.dart):

A "remove" TextButton that removes the product from the cart and the UI row.
A quantity editor row: a "Quantity" label, a numeric TextField (hint = current quantity) and an "Update" button (use ImportButtonStyle()) that updates ProductModel.quantity. If updated quantity <= 0 the item is removed.
2. Purpose
Allow shoppers to remove items and edit quantities directly in the cart UI with minimal, local changes to the existing codebase.

3. User stories
Shopper — Remove item: As a shopper I can remove an item from the cart so it no longer appears and is not included in totals.
Shopper — Edit quantity: As a shopper I can set a new quantity for an item in the cart and see the cart update.
Developer — Minimal change: As a developer I want these features implemented only in the cart item widget file, using existing CartModel/ProductModel APIs and no new helper files.
4. Acceptance criteria
UI: Each cart item row displays the new controls underneath existing info.
Remove behavior: Pressing "remove" removes the ProductModel from the cart and the row disappears (CartModel.notifyListeners() called).
Update behavior:
TextField accepts numbers (keyboardType: TextInputType.number).
Hint text shows current quantity (fallback "1" if unavailable).
Pressing "Update" sets product.quantity (or calls CartModel update API) and notifies listeners.
If entered quantity <= 0 the item is removed from the cart and the row disappears.
The Update button uses ImportButtonStyle().
Implementation constraints:
Change only cart_screen.dart (or the specific cart-item widget file used there).
Do not add helper files or change unrelated code.
Use existing CartModel/ProductModel APIs (Provider/context usage if project already uses it).
Create and dispose any TextEditingController in the item widget lifecycle.
Robustness:
Use null-safe checks; do not dereference nullable fields.
If parsing fails, do nothing (optional minimal inline error OK).
No persistence or backend changes — in-memory only.
5. Subtasks (small, commit-sized)
UI scaffolding (one commit)

Add the controls row beneath each item’s info: TextButton("remove"), SizedBox, and an inline group with Text("Quantity"), a TextField, and an Update button (ImportButtonStyle()).
File: cart_screen.dart only.
Hook remove (one commit)

Implement onPressed for remove to call CartModel removal API or set product.quantity = 0 and call notifyListeners().
Ensure the UI updates (row removed).
Wire Update (one commit)

Create TextEditingController per item; set hintText to product.quantity.
Parse input on Update; if integer parsed:
If value <= 0 → remove item (same as remove).
Else set product.quantity (or call CartModel update) and notifyListeners().
Dispose controller in widget dispose.
Input robustness & layout (one commit)

Ensure keyboardType: TextInputType.number and accept digits.
Make TextField flexible for small screens; allow wrapping.
Add fallback hint "1" if quantity missing.
Manual verification (one commit)

Document short manual test steps in a comment or README note: add item, update quantity >0, update to 0, remove via button.
6. Manual test steps
Add an item to cart (via ProductPage).
Open Cart screen.
Verify controls appear under the item.
Press "remove" → item row disappears.
Enter a valid number in Quantity field and press "Update" → quantity and totals update.
Enter 0 or negative and press "Update" → item removed.