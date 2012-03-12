#Welcome to Neo4j-Pique

An investigation into using [Twitter @Anywhere](https://dev.twitter.com/docs/anywhere/welcome) and [Neo4j](http://neo4j.org/) (with [neoid](https://github.com/elado/neoid) and [neography](https://github.com/maxdemarzi/neography) gems) running on Ruby-on-Rails (with rspec tests), deployed to Heroku.  

##What does it do

Users and friends (follows) are added as you connect with twitter - connections are only made if you follow someone who has previously also used the application. If someone you follow uses the application after you, your relationship is only updated the next time you reconnect or refresh the page.

You can see the total likes of a 'thing' and who of the people you follow also like the same 'thing'. It is updated every 10 seconds which might be a bit much for the single heroku instance - bit I ain't paying 'nowt for a toy application :).

##Example

An example of this application is running on heroku at [Neo4j-Pique](http://neo4j-pique.herokuapp.com/)

##Preparation

To prepare Neo4j for dev and test follow the instruction in the [neo4j folder](neo4j-pique/blob/master/neo4j/neo4j-preparation.md).

To prepare Twitter @anywhere follow the [instructions.](neo4j-pique/blob/master/twitter_anywhere_config.md)
