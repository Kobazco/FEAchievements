# FEAchievements
These are basic instructions on how to contribute to the ongoing Fire Emblem Achievements mod. A basic guide for adding achievements to the Additional Achievments mod can be found here:

https://forums.civfanatics.com/threads/additional-achievements.624217/

Achievement Ideas can be found in the Discord Channel's achievement-ideas chat room and on this google doc: https://docs.google.com/document/d/1_vMpmGaUnfpMFeWiFDMU6TQqywghDj7wsNnPxgpE5iQ/edit?usp=sharing

## Folder Structure

In terms of the current folder structure, you can go ahead and ignore the folder called Fire Emblem - Additional Achievements mod. Inside there is everything I put at the base as well, so its a dupe. I'd much rather for organization sake that everyone modifies the files inside the root folders for organization purposes until I become more adept at using Github.

## Basic Achievments

Now then, lets say you want to make your own super cool achievement for winning as Seliph for example, what do you do? Well to start out we need to take a look at the file "FEIdentifier.xml". Here is where we define all of our mods for use in achievements. If you click on "FEIdentifier.xml", you'll see I've pointed out an example with my first mod. Follow the example when adding a new mod, and make sure above all else that the Mod ID is correct.

Next, take a look at the folder titled "Jugdral" Seliph is from Jugdral after all, and we want to keep things organized. We'll start with the file titled "FEJugdralAchievements.xml" However, unless someone has already done some work in there when you are reading this, it will be completely empty! What you want to do instead, is take a peak in Awakening's Folder and look at "FEAwakeningAchievements.xml". In this file, you will see an example achievement, with every line having a comment telling you what it does. Go ahead and copy and paste that into your own Achievement file or edit of the Jugdral one, and follow the instructions to modify the achievement. Through XML alone, you can make achievements for a Civ winning, being defeated by you, or losing as that civ. For more information on whats possible in XML, look into AA References.sql

## Achievement Tabs
Next, you're going to want to add your Achievement to the Jugdral Achievements tab. If the tab itself is not already made, you can follow the example in "FEAwakeningAchievementsTab.xml" just like before. As usual, just follow the example I have there and it shouldn't be too hard.

## Required Mods for Achievement
Lastly, we'll want to let the game know that our new Achievement requires Seliphs mod to be active. To do this, we'll once again look at the example in Awakening's folder, in the file called "FEAwakeningRequiredMods.xml". Here you should see a rather straightforward example of the Achievement and ModType, which can be copied over to your own version of the Jugdral File. This part should be rather quick, as we already defined Seliph's mod at the start of this whole process in "FEIdentifier.xml"

And that should be everything for a basic XML achievement! The same process is taken for lua ones as well, accept the requirements and rewarding of those achievements are done in lua. If you want to look into how to do lua based achievments, the link to the Additional Achievements tutorial has a section on that.

## I want to do Custom Art!
That's great! Civ V art has to be in certain sizes, and I'm not 100% on what sizes the icons for Achievments use yet. The general rule though is to just make the Icons at 256x256 first and you can resize them no problem from there. If you want an example of how icons are done, look at an existing mod's art folder.

## Submitting Changes/Change Requests
I'm not 100% sure on how Git hub does change requests, but you'll either have to do one of two things when you want to add a new achievement/modify a file. 
1. Make your own xml file that matches the name of the one you are modifying, and copy all of the existing contents of it to yours so you do not miss/accidently delete preexisting work. Then you can likely upload the file/submit a change request.
2. If it lets you, directly edit the file within Github and then submit a change request.

Like I said, I'm really not sure on how this works, if you can't figure it out go ahead and DM me on discord and send the files that way and I'll make the changes myself.

Good luck and thanks for your help everyone!
