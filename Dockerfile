FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS base
WORKDIR /src
COPY *.sln .
#COPY DemoHerokuTest/*.csproj DemoHerokuTest/
#RUN dotnet restore DemoHerokuTest/*.csproj
COPY DokerizedApp/*.csproj DokerizedApp/
RUN dotnet restore DokerizedApp/*.csproj
COPY . .

#Testing
#FROM base AS testing
#WORKDIR /src/DemoHeroku
#RUN dotnet build
#WORKDIR /src/DemoHerokuTest
#RUN dotnet test

#Publishing
FROM base AS publish
WORKDIR /src/DokerizedApp
RUN dotnet publish -c Release -o /src/publish

#Get the runtime into a folder called app
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /src
#COPY --from=build /app/Groundforce.Services.API/gforce.db .
COPY --from=publish /src/publish .
#ENTRYPOINT ["ConsoleApp1.exe"]
ENTRYPOINT ["dotnet", "DokerizedApp.dll"]
#CMD ASPNETCORE_URLS=http://*:$PORT dotnet DemoHeroku.dll