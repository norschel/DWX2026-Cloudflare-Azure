FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["src/EdgeBeforeAzure.Api/EdgeBeforeAzure.Api.csproj", "src/EdgeBeforeAzure.Api/"]
RUN dotnet restore "src/EdgeBeforeAzure.Api/EdgeBeforeAzure.Api.csproj"
COPY . .
RUN dotnet publish "src/EdgeBeforeAzure.Api/EdgeBeforeAzure.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "EdgeBeforeAzure.Api.dll"]
