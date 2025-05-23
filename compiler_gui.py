import tkinter as tk
from tkinter import filedialog, scrolledtext, messagebox, ttk
import subprocess
import os

def compile_code():
    code = code_input.get("1.0", tk.END)
    with open("input.fra", "w") as f:
        f.write(code)
    
    try:
        result = subprocess.run(["./compiler"], input=code.encode(), capture_output=True)
        stdout = result.stdout.decode()
        stderr = result.stderr.decode()

        output_text.config(state="normal")  # Enable editing
        output_text.delete("1.0", tk.END)
        output_text.insert(tk.END, "=== Output ===\n" + stdout)
        if stderr:
            output_text.insert(tk.END, "\n=== Errors ===\n" + stderr)
        output_text.config(state="disabled")  # Disable editing
        
    
        
        if os.path.exists("symbols.txt"):
            with open("symbols.txt", "r") as f:
                symtab = f.read()
            symtab_text.config(state="normal")  # Enable editing
            symtab_text.delete("1.0", tk.END)
            symtab_text.insert(tk.END, symtab)
            symtab_text.config(state="disabled")  # Disable editing
    except FileNotFoundError:
        messagebox.showerror("Error", "Compiler executable not found. Make sure './compiler' exists.")

def load_file():
    path = filedialog.askopenfilename(filetypes=[("FRA Files", "*.fra"), ("All Files", "*.*")])
    if path:
        with open(path, "r") as f:
            code = f.read()
        code_input.delete("1.0", tk.END)
        code_input.insert(tk.END, code)

def create_gui():
    root = tk.Tk()
    root.title("CMPN403 Mini Compiler GUI")

    # Create a canvas and a scrollbar
    canvas = tk.Canvas(root)
    scrollbar = ttk.Scrollbar(root, orient="vertical", command=canvas.yview)
    scrollable_frame = ttk.Frame(canvas)

    # Configure the scrollable frame
    scrollable_frame.bind(
        "<Configure>",
        lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
    )
    canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
    canvas.configure(yscrollcommand=scrollbar.set)

    # Pack the canvas and scrollbar
    canvas.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")

    # Add content to the scrollable frame
    tk.Button(scrollable_frame, text="Load File", command=load_file).pack(pady=5)
    global code_input
    code_input = scrolledtext.ScrolledText(scrollable_frame, width=100, height=20)
    code_input.pack(padx=10, pady=5)

    tk.Button(scrollable_frame, text="Compile", command=compile_code).pack(pady=5)

    # Output Section
    output_frame = ttk.Frame(scrollable_frame)
    output_frame.pack(fill="both", expand=True, padx=10, pady=5)
    tk.Label(output_frame, text="Output").pack(anchor="w")
    global output_text
    output_text = scrolledtext.ScrolledText(output_frame, width=100, height=10, bg="black", fg="lime")
    output_text.pack(fill="both", expand=True)
    output_text.insert(tk.END, "Compiler output will appear here.\n")
    output_text.config(state="disabled")  # Disable editing

    # Symbol Table Section
    symtab_frame = ttk.Frame(scrollable_frame)
    symtab_frame.pack(fill="both", expand=True, padx=10, pady=5)
    tk.Label(symtab_frame, text="Symbol Table").pack(anchor="w")
    global symtab_text
    symtab_text = scrolledtext.ScrolledText(symtab_frame, width=100, height=10)
    symtab_text.pack(fill="both", expand=True)
    symtab_text.config(state="disabled")  # Disable editing

    root.mainloop()

if __name__ == "__main__":
    create_gui()
