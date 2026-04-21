import json
import os
import random

# ── File where decks are saved ─────────────────────────────────────────────
SAVE_FILE = "flashcard_decks.json"


# ── Load / Save helpers ────────────────────────────────────────────────────
def load_decks():
    """Load decks from the save file. Returns an empty list if none exist."""
    if os.path.exists(SAVE_FILE):
        with open(SAVE_FILE, "r") as f:
            return json.load(f)
    return []


def save_decks(decks):
    """Save all decks to the save file."""
    with open(SAVE_FILE, "w") as f:
        json.dump(decks, f, indent=2)


# ── Display helpers ────────────────────────────────────────────────────────
def clear():
    """Clear the terminal screen."""
    os.system("cls" if os.name == "nt" else "clear")


def print_header(title):
    """Print a simple section header."""
    print("\n" + "=" * 40)
    print(f"  {title}")
    print("=" * 40)


# ── Create a new deck ──────────────────────────────────────────────────────
def create_deck(decks):
    print_header("Create New Deck")
    name = input("Deck name: ").strip()
    if not name:
        print("Name cannot be empty.")
        return

    cards = []
    print("\nAdd cards (press Enter with no question to stop):\n")
    while True:
        question = input(f"  Card {len(cards) + 1} Question: ").strip()
        if not question:
            break
        answer = input(f"  Card {len(cards) + 1} Answer:   ").strip()
        if answer:
            cards.append({"question": question, "answer": answer})

    if not cards:
        print("No cards added — deck not saved.")
        return

    decks.append({"name": name, "cards": cards})
    save_decks(decks)
    print(f"\n✓ Deck '{name}' saved with {len(cards)} card(s)!")
    input("\nPress Enter to continue...")


# ── List all decks ─────────────────────────────────────────────────────────
def list_decks(decks):
    if not decks:
        print("\nNo decks yet. Create one first!")
        return False
    print()
    for i, deck in enumerate(decks, 1):
        print(f"  {i}. {deck['name']}  ({len(deck['cards'])} cards)")
    return True


# ── Run a quiz ─────────────────────────────────────────────────────────────
def run_quiz(decks):
    print_header("Start a Quiz")
    if not list_decks(decks):
        input("\nPress Enter to continue...")
        return

    choice = input("\nChoose a deck number: ").strip()
    if not choice.isdigit() or not (1 <= int(choice) <= len(decks)):
        print("Invalid choice.")
        input("\nPress Enter to continue...")
        return

    deck = decks[int(choice) - 1]
    cards = deck["cards"][:]
    random.shuffle(cards)

    correct = 0
    total = len(cards)

    print(f"\nStarting quiz: '{deck['name']}' — {total} cards\n")
    input("Press Enter to begin...")

    for i, card in enumerate(cards, 1):
        clear()
        print(f"\n  Card {i} of {total}")
        print("-" * 40)
        print(f"\n  Question: {card['question']}\n")
        input("  Press Enter to see the answer...")
        print(f"\n  Answer: {card['answer']}\n")

        while True:
            result = input("  Did you get it right? (y/n): ").strip().lower()
            if result in ("y", "n"):
                break
            print("  Please type y or n.")

        if result == "y":
            correct += 1
            print("  ✓ Nice!")
        else:
            print("  ✗ Keep practicing!")

        input("\n  Press Enter for next card...")

    # Results
    clear()
    print_header("Quiz Complete!")
    percentage = round((correct / total) * 100)
    print(f"\n  Score:   {correct} / {total}  ({percentage}%)")

    if percentage == 100:
        print("  Result:  Perfect! Outstanding work! 🎉")
    elif percentage >= 80:
        print("  Result:  Great job! Almost mastered it!")
    elif percentage >= 50:
        print("  Result:  Good effort — keep reviewing!")
    else:
        print("  Result:  Keep going — practice makes perfect!")

    input("\nPress Enter to continue...")


# ── Delete a deck ──────────────────────────────────────────────────────────
def delete_deck(decks):
    print_header("Delete a Deck")
    if not list_decks(decks):
        input("\nPress Enter to continue...")
        return

    choice = input("\nChoose a deck number to delete: ").strip()
    if not choice.isdigit() or not (1 <= int(choice) <= len(decks)):
        print("Invalid choice.")
        input("\nPress Enter to continue...")
        return

    deck = decks[int(choice) - 1]
    confirm = input(f"Delete '{deck['name']}'? (y/n): ").strip().lower()
    if confirm == "y":
        decks.pop(int(choice) - 1)
        save_decks(decks)
        print("✓ Deck deleted.")
    else:
        print("Cancelled.")
    input("\nPress Enter to continue...")


# ── Main menu ──────────────────────────────────────────────────────────────
def main():
    decks = load_decks()

    while True:
        clear()
        print_header("FlashCard Quiz App")
        print("\n  1. Create a new deck")
        print("  2. Start a quiz")
        print("  3. View my decks")
        print("  4. Delete a deck")
        print("  5. Quit")

        choice = input("\nChoose an option (1-5): ").strip()

        if choice == "1":
            create_deck(decks)
        elif choice == "2":
            run_quiz(decks)
        elif choice == "3":
            print_header("My Decks")
            list_decks(decks)
            input("\nPress Enter to continue...")
        elif choice == "4":
            delete_deck(decks)
        elif choice == "5":
            print("\nGoodbye! Keep studying! 👋\n")
            break
        else:
            print("Please enter a number between 1 and 5.")
            input("\nPress Enter to continue...")


# ── Run the app ────────────────────────────────────────────────────────────
if __name__ == "__main__":
    main()
