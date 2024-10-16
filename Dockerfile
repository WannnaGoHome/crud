# ��������� ������� ����� � ASP.NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# ��������� ����� ��� ������ � .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# �������� ���� ������� � ��������� dotnet restore
COPY ["WebApplication2/WebApplication2.csproj", "WebApplication2/"]
RUN dotnet restore "./WebApplication2/WebApplication2.csproj"

# �������� ��������� ����� � ��������� ������ �������
COPY . .
WORKDIR "/src/WebApplication2"
RUN dotnet build "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/build

# ���������� ����������
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./WebApplication2.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# ��������� �����, �� ������� ����� �������� ����������
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# ��������� ����� ����� ��� ������� ����������
ENTRYPOINT ["dotnet", "WebApplication2.dll"]
