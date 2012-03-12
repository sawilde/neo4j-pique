Twitter @Anywhere Key

This application uses Twitter @Anywhere and since it is not possible to share keys then it will be necessary for you to generate and use your own.

Register/Login to https://dev.twitter.com/ and follow the instruction to create an application

NOTE: Remember to fill in the callback URL, though it is not mandatory it is better to use a default URL entry here.

Look for the Consumer Key.

First it needs to be added to the development environment 

e.g. to the ~/.bashrc file add the following entry

    export TWITTER_API_KEY=<consumer-key>

If you are using Heroku then you can use the following to add it your production environment

    heroku config:add TWITTER_API_KEY=<consumer-key> 
