
# Worker service Dockerfile
#
# .NET container builds can have platform-specific limitations.
# Use BuildKit's BUILDPLATFORM for the SDK stage and TARGETARCH
# to publish for the target architecture.
#
# For cross-platform builds, specify the target platform with:
# docker buildx build --platform linux/amd64 .
#
# See:
# https://github.com/dotnet/dotnet-docker/issues/1537
# https://hub.docker.com/_/microsoft-dotnet

# Build stage
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0@sha256:d32bd65cf5843f413e81f5d917057c82da99737cb1637e905a1a4bc2e7ec6c8d AS build

ARG TARGETARCH

WORKDIR /source

# Restore project dependencies
COPY *.csproj .
RUN dotnet restore -a $TARGETARCH

# Publish the Worker application
COPY . .
RUN dotnet publish -c Release -o /app -a $TARGETARCH --self-contained false --no-restore

# Runtime stage: use the smaller .NET runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0@sha256:8cd26108e7a329458e5b84342816ae39b2b38bd041cfdc0b79b8cf1c0e0d376f

WORKDIR /app

COPY --from=build /app .

# Create and use a dedicated non-root user
RUN useradd --system --uid 10001 --create-home appuser
USER appuser

ENTRYPOINT ["dotnet", "Worker.dll"]
