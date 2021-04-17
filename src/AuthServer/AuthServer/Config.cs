using System.Collections.Generic;
using IdentityServer4.Models;

namespace AuthServer
{
    public static class Config
    {
        public static IEnumerable<IdentityResource> IdentityResources
        {
            get {
                return new List<IdentityResource>
                {
                    new IdentityResources.OpenId(),
                    new IdentityResources.Email(),
                    new IdentityResources.Profile(),
                };
            }
        }

        public static IEnumerable<ApiResource> ApiResources
        {
            get
            {
                return new List<ApiResource>
                {
                    new ApiResource("fakebookApi", "Fakebook API")
                    {
                        Scopes = { "api.read" }
                    }
                };
            } 
        }

        public static IEnumerable<ApiScope> ApiScopes
        {
            get 
            {
                return new List<ApiScope>
                {
                    new ApiScope("api.read")
                };
            }
           
        }

        public static IEnumerable<Client> Clients
        {
            get
            {
                return new[]
                {
                    new Client
                    {
                        RequireConsent = false,
                        ClientId = "angular_spa",
                        ClientName = "Angular SPA",
                        AllowedGrantTypes = GrantTypes.Implicit,
                        AllowedScopes = { "openid", "profile", "email", "api.read" },
                        RedirectUris = {"http://localhost:4200/auth-callback"},
                        PostLogoutRedirectUris = {"http://localhost:4200/"},
                        AllowedCorsOrigins = {"http://localhost:4200"},
                        AllowAccessTokensViaBrowser = true,
                        AccessTokenLifetime = 3600
                    }
                };
            } 
        }
    }
}
