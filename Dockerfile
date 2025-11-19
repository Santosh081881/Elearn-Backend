FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /elearnbackend

COPY . .
RUN <<EOF
dotnet restore
dotnet build --configuration Release  
dotnet publish -c Release -o ./publish
EOF

# Final stage/image
# Use the runtime image from the .NET SDK image
# to reduce the size of the final image
# and improve security by not including build tools
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /dotnet_artifacts
COPY --from=build /elearnbackend/publish .
ENTRYPOINT ["dotnet", "ElearnBackend.dll"]

