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
RUN dotnet ef migrations script \
    -c AppIdentityDbContext \
    -p AuthServer.Infrastructure \
    -s AuthServer \
    -o ../init-app-db.sql -i
RUN dotnet ef migrations script \
    -c PersistedGrantDbContext \
    -p AuthServer.Infrastructure \
    -s AuthServer \
    -o ../init-grant-db.sql -i

FROM postgres:13.2-alpine AS runtime

WORKDIR /docker-entrypoint-initdb.d

ENV POSTGRES_PASSWORD Pass@word

COPY --from=build /app/*.sql ./