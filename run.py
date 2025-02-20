import subprocess
import os
import sys
import signal
from threading import Thread

# Get the absolute path to the project root
PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))

def run_backend():
    backend_dir = os.path.join(PROJECT_ROOT, "backend")
    print(f"\n🚀 Starting backend in {backend_dir}")
    subprocess.run(
        ["uvicorn", "app.main:app", "--reload", "--port", "8000"],
        cwd=backend_dir,
        shell=True,
        stdout=sys.stdout,
        stderr=sys.stderr
    )

def run_frontend():
    frontend_dir = os.path.join(PROJECT_ROOT, "frontend")
    print(f"\n🚀 Starting frontend in {frontend_dir}")
    subprocess.run(
        ["flutter", "run", "-d", "chrome"],
        cwd=frontend_dir,
        shell=True,
        stdout=sys.stdout,
        stderr=sys.stderr
    )

if __name__ == "__main__":
    # Create and start threads
    backend_thread = Thread(target=run_backend)
    frontend_thread = Thread(target=run_frontend)

    backend_thread.daemon = True
    frontend_thread.daemon = True

    backend_thread.start()
    frontend_thread.start()

    # Keep main thread alive and handle interrupt
    try:
        backend_thread.join()
        frontend_thread.join()
    except KeyboardInterrupt:
        print("\n🛑 Shutting down both services...")
        sys.exit(0)