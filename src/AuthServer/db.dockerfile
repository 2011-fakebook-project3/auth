FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build

WORKDIR /app/src

# --------------------------------
COPY AuthServer.Infrastructure/*.csproj AuthServer.Infrastructure/
COPY AuthServer/*.csproj AuthServer/
COPY *.sln ./
RUN dotnet restore
# ---------------------------------
COPY .config ./
RUN dotnet tool restore
# ---------------------------------

COPY . ./

# generate SQL script from migrations
RUN dotnet ef migrations script -p AuthServer.Infrastructure -s AuthServer -o ../init-db.sql -i

FROM postgres:13.2-alpine AS runtime

WORKDIR /docker-entrypoint-initdb.d

ENV POSTGRES_PASSWORD Pass@word

COPY --from=build /app/init-db.sql .