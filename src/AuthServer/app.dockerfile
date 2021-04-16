#################- Build and Publish -#####################

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build

WORKDIR /app/src

# --------------------------------
COPY AuthServer.Infrastructure/*.csproj AuthServer.Infrastructure/
COPY AuthServer/*.csproj AuthServer/
COPY *.sln ./
RUN dotnet restore
# ---------------------------------

COPY . ./

RUN dotnet publish AuthServer -c Release -o ../publish

#################- Package Assemblies -###################

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS runtime

WORKDIR /app

COPY --from=build /app/publish ./

CMD dotnet AuthServer.dll