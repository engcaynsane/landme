FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["Landingpage/Landingpage.csproj", "Landingpage/"]
RUN dotnet restore "Landingpage/Landingpage.csproj"

COPY Landingpage/ Landingpage/
WORKDIR /src/Landingpage
RUN dotnet publish "Landingpage.csproj" --configuration Release --no-restore --output /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_ENVIRONMENT=Production
USER $APP_UID
EXPOSE 10000

ENTRYPOINT ["sh", "-c", "dotnet Landingpage.dll --urls http://0.0.0.0:${PORT:-10000}"]
