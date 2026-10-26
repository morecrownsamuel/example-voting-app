# Worker service Dockerfile

FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:10.0@sha256:de4fe90a98845d75910b9769662465c84de1a934665c431279d1382b2bddc02b AS build

ARG TARGETARCH

WORKDIR /source

COPY *.csproj .
RUN dotnet restore -a $TARGETARCH

COPY . .
RUN dotnet publish -c Release -o /app -a $TARGETARCH --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/runtime:10.0@sha256:a3f9f81954b9c810af2ed18849716c8dc74a4707bd0907fdbd69be81554c0f30

WORKDIR /app

COPY --from=build /app .

RUN useradd --system --uid 10001 --create-home appuser
USER appuser

ENTRYPOINT ["dotnet", "Worker.dll"]
