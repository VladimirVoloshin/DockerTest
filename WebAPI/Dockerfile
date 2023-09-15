FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

ARG fNameArg
ARG lNameArg
ARG emailArg 

ENV FIRST_NAME=$fNameArg
ENV LAST_NAME="Doe"
ENV EMAIL="john.doe@email.com"

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["WebAPI.csproj", "src/"]
RUN dotnet restore "src/WebAPI.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "WebAPI.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "WebAPI.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebAPI.dll"]
