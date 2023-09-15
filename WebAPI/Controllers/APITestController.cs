using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class APITestController : ControllerBase
    {
        private readonly ILogger<APITestController> _logger;

        public APITestController(ILogger<APITestController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetUser")]
        public User Get()
        {
            _logger.LogWarning("GetUser called");
            var user = new User();

            user.Name = Environment.GetEnvironmentVariable("FIRST_NAME");
            user.LastName = Environment.GetEnvironmentVariable("LAST_NAME");
            user.Email = Environment.GetEnvironmentVariable("EMAIL");;

            return user;
        }
    }
}