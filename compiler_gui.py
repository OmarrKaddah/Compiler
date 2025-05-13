
import tkinter as tk
from tkinter import filedialog, scrolledtext, messagebox
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

        output_text.delete("1.0", tk.END)
        output_text.insert(tk.END, "=== Output ===\n" + stdout)
        if stderr:
            output_text.insert(tk.END, "\n=== Errors ===\n" + stderr)
        
        if os.path.exists("quadruples.txt"):
            with open("quadruples.txt", "r") as f:
                quads = f.read()
            quad_text.delete("1.0", tk.END)
            quad_text.insert(tk.END, quads)
        
        if os.path.exists("symbols.txt"):
            with open("symbols.txt", "r") as f:
                symtab = f.read()
            symtab_text.delete("1.0", tk.END)
            symtab_text.insert(tk.END, symtab)
    except FileNotFoundError:
        messagebox.showerror("Error", "Compiler executable not found. Make sure './compiler' exists.")

def load_file():
    path = filedialog.askopenfilename(filetypes=[("FRA Files", "*.fra"), ("All Files", "*.*")])
    if path:
        with open(path, "r") as f:
            code = f.read()
        code_input.delete("1.0", tk.END)
        code_input.insert(tk.END, code)

root = tk.Tk()
root.title("CMPN403 Mini Compiler GUI")

tk.Button(root, text="Load File", command=load_file).pack(pady=5)
code_input = scrolledtext.ScrolledText(root, width=100, height=20)
code_input.pack(padx=10, pady=5)

tk.Button(root, text="Compile", command=compile_code).pack(pady=5)

output_text = scrolledtext.ScrolledText(root, width=100, height=10, bg="black", fg="lime")
output_text.pack(padx=10, pady=5)
output_text.insert(tk.END, "Compiler output will appear here.\n")

tk.Label(root, text="Quadruples").pack()
quad_text = scrolledtext.ScrolledText(root, width=100, height=10)
quad_text.pack(padx=10, pady=5)

tk.Label(root, text="Symbol Table").pack()
symtab_text = scrolledtext.ScrolledText(root, width=100, height=10)
symtab_text.pack(padx=10, pady=5)

root.mainloop()
