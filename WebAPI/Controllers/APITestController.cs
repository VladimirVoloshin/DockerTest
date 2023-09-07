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
            var user = new User();

            user.Name = "John";
            user.LastName = "Smith";
            user.Email = "john.smith@email.com";

            return user;
        }
    }
}