# Óêàçûâàåì áàçîâûé îáðàç ñ ASP.NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Óêàçûâàåì îáðàç äëÿ ñáîðêè ñ .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Êîïèðóåì ôàéë ïðîåêòà è âûïîëíÿåì dotnet restore
COPY ["WebApplication2/WebApplication2.csproj", "WebApplication2/"]
RUN dotnet restore "./WebApplication2/WebApplication2.csproj"

# Êîïèðóåì îñòàëüíûå ôàéëû è âûïîëíÿåì ñáîðêó ïðîåêòà
COPY . .
WORKDIR "/src/WebApplication2"
RUN dotnet build "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Ïóáëèêàöèÿ ïðèëîæåíèÿ
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Ôèíàëüíûé îáðàç, íà êîòîðîì áóäåò çàïóùåíî ïðèëîæåíèå
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Óêàçûâàåì òî÷êó âõîäà äëÿ çàïóñêà ïðèëîæåíèÿ
ENTRYPOINT ["dotnet", "WebApplication2.dll"]
