# Reproducible CAD environment — OpenSCAD + FreeCAD + IfcOpenShell.
# Used by the CI that rebuilds every example in this portfolio.
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        openscad \
        freecad \
        python3 \
        python3-pip \
        python3-ifcopenshell \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

CMD ["bash"]
