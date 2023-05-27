# quiz_website
[![codecov](https://codecov.io/gh/InnovaTech-21/Quiz_Attempt2/branch/main/graph/badge.svg?token=FMR08S5JD1)](https://codecov.io/gh/InnovaTech-21/Quiz_Attempt2)
**[![CircleCI](https://dl.circleci.com/status-badge/img/gh/InnovaTech-21/Quiz_Attempt2/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/InnovaTech-21/Quiz_Attempt2/tree/main)**

Welcome to our Software Design Project ! 

We will be creating an online quiz platform.
Our Team:

- Amit
- Jacqueline
- Kimentha
- Nusaiba
- Shakeel
- Shreya


To get the environment key for openai do the following
1.Create an OpenAI account: If you haven't already, create an account on the OpenAI platform at https://openai.com and sign in.

2.Generate an API key: Once you're signed in to your OpenAI account, navigate to your account settings or API settings to generate an API key. The exact location may vary, so refer to the OpenAI documentation or user interface for guidance on generating the key.

3.Store the API key securely: As mentioned earlier, avoid hardcoding the API key directly in your code. Instead, use environment variables or a configuration file to store the key securely.

Option 1: Environment variables - Set an environment variable in your development environment with the API key. You can access it in your code using the appropriate method provided by your programming language or framework.
Option 2: Configuration file - Create a configuration file (e.g., .env file) in your project's root directory and add an entry to store the API key. For example, in a .env file, you can add: OPENAI_API_KEY=your_api_key_here. Ensure that this file is not committed to your version control system by adding it to your .gitignore file.
4.Access the API key in your code: To access the API key in your Flutter code, you can use the flutter_dotenv package to read environment variables from a .env file
5.Use the API key to authenticate API requests: Once you have the API key available in your code, you can use it to authenticate API requests to the OpenAI services. Refer to the OpenAI API documentation or relevant SDKs for details on how to use the API key for authentication and make API calls.




