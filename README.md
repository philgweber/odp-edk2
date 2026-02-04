# odp-edk2

This repository contains the ODP edk2-based platform sources and build scripts.

**Dev Container**

- Open in VS Code and run **Remote-Containers: Reopen in Container** to use the provided devcontainer.
- To build the container image manually and open a shell:

**Run a platform build (example):**

```bash
cd ../edk2-odp/Platform/Qemu/SbsaQemu
./build.sh
```

**Troubleshooting**

- If tools are missing, confirm you're in the devcontainer shell or that required toolchains are installed.
- For interactive edk2 setup steps, run `./edk2/edksetup.sh` manually and follow prompts.
