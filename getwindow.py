import json
import subprocess

try:
    result = subprocess.run(
        [
            "gdbus", "call", "--session", "--dest", "org.gnome.Shell",
            "--object-path", "/org/gnome/shell/extensions/FocusedWindow",
            "--method", "org.gnome.shell.extensions.FocusedWindow.Get"
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True
    )

    raw_output = result.stdout.strip()
    json_data = raw_output.lstrip("('").rstrip("',)")

    data = json.loads(json_data)
    print(data.get('wm_class', 'Unknown'))
except subprocess.CalledProcessError as e:
    print(f"Command failed: {e}")
except (IndexError, json.JSONDecodeError) as e:
    print(f"Error parsing JSON output: {e}")

