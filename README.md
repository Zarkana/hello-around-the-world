# What is it?

Hello Around the World is an online web application for developers to practice their developer skills by implementing common algorithms in many of the popular programming languages. 

After learning to say Hello World in all the major languages, then attempt to implement more complex algorithms in different languages
of your choosing. Great for preparing for interviews or just expanding your mind. 

There are no charges currently associated with creating an account and the privilidges that it conveys, there are currently no plans to monetize the application.

# How is it being developed?

Development for Hello Around the World will continue and the program will become more feature rich in time, but it will always sticking to it's original intent of providing a unique interface strictly for learning and practicing common algorithms and snippets of code. 

The application was developed with Ruby on Rails and makes use of several open source gems.
- Account management with devise
https://github.com/plataformatec/devise
- Account Permissions with cancan
https://github.com/ryanb/cancan
- Image uploading with paperclip
https://github.com/thoughtbot/paperclip

## Updates


## Future Features
Visit the trello page to see what features are being worked on or finished
https://trello.com/b/m2xyJMUs/hello-around-the-world


# How do I use it?

## Quizzes
Making a new quiz is the primary function of the web app. On the root page users as well as non-users can both create a quiz by performing the following steps
 1. Selecting a language you would like the snippets to be tested on
 2. Toggle which snippets and categories you would like to be tested on
 3. Click begin

Once the quiz has begun you can try to implement each algorithm in the corresponding language. Once complete you will be presented with the answer beside your attempt. Simple. 

## How do I customize it?
After making an account (No charges), users can modify code snippets as well as add additional snippets.
- Create/Read/Update/Delete Snippets
- Create/Delete Categories
- Create/Update/Delete Languages

### Snippets
A Snippet is the object that describes the collection of different language implementations for an algorithm

### Categories
A Category is an object that holds a collection of related code snippets

### Languages
A Language is the object that the program refers to when deciding which snippet implementations to quiz on

## Contributions
Helping out is greatly appreciated, if any bugs are found or experienced please report them here,
https://github.com/Zarkana/hello-around-the-world/issues



