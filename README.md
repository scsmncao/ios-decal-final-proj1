# Miracle

## Authors
* Simon Cao

## Purpose
The purpose of this application is to bring awareness to events and strifes 
around the world. The application hopes to bring people together and build 
communities to help causes. Donating is difficult because of all the 
research that has to be done and every donation flow is different. I hope to 
increase charity donations and awareness by helping to be transparent about 
the charities users are donating to and also how much of a difference just a 
dollar can make.

## Features
* Look through current issues facing people today and donate
* Ability to see total donations and the impact they are making
* Learn more about the current issues and learn more about the organization 
they might be donating to
* Filter the issues to those that interest the user
* See what the user's friends have donated to and are interested in
* Reach goal: Have company or people sponsors that will match the user's donations

## Control Flow
* Users are intially presented with a login page where they can login with 
Facebook
* Users are then brought to the home page where there's one featured cause and
some other causes and issues going on around the world
* There's also an option on the bottom bar tab to see a feed of all the
causes/issues that the user's friends have donated to or favorited
* When the user taps on a cause/issue they will be presented with more
information about it. The user can scroll down to see how many people have
donated and what that means. The user will also learn more about the charity
(spending breakdown, what they do, history, etc), and they will also be
presented with an option to donate. Users will also be able to see friends
who have donated or favorited on this page.
* Users can also view their own profile which contains causes they've
donated to and also favorited.

## Implementation
### Model
* User.swift
* Cause.swift
* Charity.swift
* I will most likely be using Firebase to store my information

### View
* CausesStackView
* CauseDetailView
* ProfileView
* FeedStackView

### Controller
* CausesStackViewController
* CauseDetailViewController
* ProfileViewController
* FeedStackViewController
