//
//  PIRedditListingTests.m
//  RedditClient
//
//  Created by Alex G on 03.11.15.
//  Copyright © 2015 Alexey Gordiyenko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIRedditListing.h"
#import "PIRedditLink.h"
#import "XCTest+PIReddit.h"

@interface PIRedditListingTests : XCTestCase

@end

@implementation PIRedditListingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation {
    NSDictionary *dictionary = [self loadJSONFromFile:@"listing_test_001" ofType:@"json"];
    XCTAssertNotNil(dictionary);
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:dictionary];
    XCTAssertNotNil(listing);
    XCTAssertNil(listing.fullNameBefore);
    XCTAssertNotNil(listing.fullNameAfter);
    XCTAssertEqual(listing.children.count, 2);
    XCTAssertTrue([listing.children[0] isKindOfClass:[PIRedditLink class]]);
    XCTAssertTrue([listing.children[1] isKindOfClass:[PIRedditLink class]]);
}

- (void)testInvalid {
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:nil];

    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:(NSDictionary *)@[]];
    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:@{}];
    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": [NSNull null]}];
    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": @{@"children": @"string"}}];
    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": @{@"children": [NSDate date]}}];
    XCTAssertNil(listing);
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": @{@"children": @{}}}];
    XCTAssertNil(listing);
}

- (void)testEmptyChildren {
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                                             @"data": @{@"children": [NSNull null]}}];
    XCTAssertNotNil(listing);
    XCTAssertNotNil(listing.children);
    XCTAssertEqual(listing.children.count, 0);
    
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": @{@"children": [NSArray new]}}];
    XCTAssertNotNil(listing);
    XCTAssertNotNil(listing.children);
    XCTAssertEqual(listing.children.count, 0);
    
    listing = [[PIRedditListing alloc] initWithDictionary:@{@"kind": @"Listing",
                                                            @"data": @{}}];
    XCTAssertNotNil(listing);
    XCTAssertNotNil(listing.children);
    XCTAssertEqual(listing.children.count, 0);
}

- (void)testInvariant {
    PIRedditListing *listing = [[PIRedditListing alloc] initWithDictionary:[self loadJSONFromFile:@"listing_test_001" ofType:@"json"]];
    for (int i = 0; i < 2; i++) {
        PIRedditLink *link = listing.children[i];
        NSLog(@"%@", link);
        switch (i) {
            case 0:
            {
                XCTAssertEqualObjects(link.subreddit, @"Games");
                XCTAssertEqualObjects(link.text, @"There was a recent post about finishing a game in your library that you hadn't finished/played yet.  I used it to motivate myself to finish Knights of the old republic, it was great.  I thought \"Hey, that felt good.  I'm going to finish another game.  On to Mirror's Edge!\"  That was a mistake.\n\nI don't get Mirror's Edge.  I found it to be an exercise in frustration.  The controls were horribly unresponsive.  The parkour was OK sometimes, but I found my self wanting the parkour from Brink (the horror!).  I didn't get pulled into the story at all, and just found the whole thing annoying.  The in game graphics were pretty cool, but other than that I found my self getting really angry playing it.\n\nI ended up uninstalling it, and I don't think I'll ever go back to it.\n\nSo what games failed to grab you despite their acclaim from the rest of the community?  What games do you not get?  Why?");
                XCTAssertEqualObjects(link.ID, @"2j3c5p");
                XCTAssertEqualObjects(link.author, @"snoman75");
                XCTAssertEqualObjects(link.subredditID, @"t5_2qhwp");
                XCTAssertEqualObjects(link.permalink, @"/r/Games/comments/2j3c5p/what_games_do_you_not_get/?ref=search_posts");
                XCTAssertEqualObjects(link.url, @"https://www.reddit.com/r/Games/comments/2j3c5p/what_games_do_you_not_get/");
                XCTAssertEqualObjects(link.title, @"What games do you not \"get\"?");
                XCTAssertEqualObjects(link.createdUTC, [NSDate dateWithTimeIntervalSince1970:1413178436.0]);
                XCTAssertEqualObjects(link.allFields[@"approved_by"], [NSNull null]);
            }
                break;
            case 1:
            {
                XCTAssertEqualObjects(link.subreddit, @"Games");
                XCTAssertEqualObjects(link.text, @"E3 conferences - Sony.\n\n---\n\n**What is it?** \n\nThe E3 press conferences are the biggest news event of the year for video games. Games will be revealed, demos will be shown, news will be broke. Really though, if you're not familiar with E3 you're probably not reading this. \n\n---\n\n**When is it?** \n\nMonday, June 10, 2013 at 6PM Pacific Time ([convert to local time](http://www.timeanddate.com/worldclock/fixedtime.html?iso=2013-06-10T16:30:00))\n\n[Countdown](http://www.e3countdown.com/) to all E3 conferences\n\n---1g3347\n\n**Where can I watch, read, and discuss it?** There are a few places you can stream it listed below, as well as numerous liveblogs across the internet\n\nStreams:\n\n* [Official Stream](http://e3.eu.playstation.com/)\n\n* [YouTube stream](https://www.youtube.com/watch?v=DmoZAPDV3ew)\n\n* [Twitch](http://www.twitch.tv/twitch)\n\n* [uStream](http://www.ustream.tv/PlayStation)\n\n**Note:** It's also possible to stream Twitch streams through VLC. Download and install livestreamer: http://livestreamer.tanuki.se/en/latest/\n\nThen write in command line (write \"cmd\" in the **Run** bar if you're using Windows): \"livestreamer http://www.twitch.tv/twitch best\"\n\n* [#games IRC on irc.snoonet.org](https://kiwiirc.com/client/irc.snoonet.org/games)\n\n* [Reddit-Stream](http://reddit-stream.com/comments/1g3347/) of this thread. Watch and comment on a live Reddit comment stream!\n\n* [IGN stream](http://ign.com/)\n\n* [Gamespot stream](http://www.twitch.tv/gamespot)\n\n* [Gametrailers stream](http://www.gametrailers.com/netstorage/e3/live.html)\n\n* [Polygon liveblog](http://www.polygon.com/)\n\n* [GameSpot liveblog](http://www.gamespot.com/e3/ea-press-conference/)\n\n\n\n---\n\n**FAQ**\n\n---\n\n\n&gt;Can I submit any information about this event in a different thread\n\nNo. We want to avoid this event dominating the entire frontpage and /r/games/new. After the event is over, you can. \n\n&gt; Will you have bad jokes again in the commentary?\n\nNo. No fun allowed!\n\n&gt;Will Pharnaces_II being giving commentary again\n\nSadly, yes.\n\n&gt;Can I start a console war in the comments?\n\nHopefully you are all mature enough to keep away from meaningless and stupid console or/and flame wars. Also please try keep all the low effort comments off this subreddit (we have /r/gaming for that).\n\n----\n\n**Updates**: (I'll try to squeeze in as much information as possible).\n\n5:45PM: The conference starts in about 15 minutes.\n\n6:00PM: It's started with a montage/short indtroduction.\n\n6:10PM: Looks like the conference has been a bit delayed. Still waiting for it to start.\n\n6:15PM: The conference starts in 1 minute according to the announcer.\n\n6:17PM: It has started. Opens up with a montage. Drop the bass!\n\n6:20PM: Jack Tretton comes out on stage. Talks about the PS3, VITA and PS4.\n\n6:22PM: Talking about the Vita and how it has become a lot more popular lately.\n\n6:23PM: 85 new Vita games are scheduled to launch in 2013.\n\n6:24PM: God of War, Final Fantasy 10 and 10-2HD and The Walking Dead are all coming to the Vita.\n\n6:25PM: Showing short clips from games which are all coming to the PS3: The Last of Us, Puppeteer, Rain, Beyond Two Souls, Gran Turismo 6.\n\n6:33PM: Jack Tretton is back on stage praising the 7 year old PS3.\n\n6:33PM: Batman: Arkham Origins trailer.\n\n6:35PM: Sony will get exclusive DLC for Batman: Arkham Origins.\n\n6:36PM: Exclusive PS3 GTA5 Bundle for $299 coming later this year.\n\n6:38PM: Andrew House comes on stage. \n\n6:39PM: PS4 console is being unveiled.\n\n6:40PM: Andrew House talks about the new capabilities with the PS4. Will focus on (new) content.\n\n6:41PM: Michael Lynton comes on stage. The PS4 is a groundbreaking platform for new content. Will not only focus on games, but also music, movies, tv-shows etc.\n\n6:42PM: The Sony Entertainment content will be exclusive to the PS4.\n\n6:44PM: Andrew House is back on stage, talking about exclusive content (Music Unlimited and Video Unlimited). It can be streamed to smart phones and pads. Netflix is also available. Redbox will be available on the PS3, Vita and PS4. Flixter will arrive on the PS4.\n\n6:48PM: Shu Yoshida comes on stage. \n\n6:50PM: 40 PS4 games currently in development. 12 of them new IP's.\n\n6:51PM: New IP, \"The Order 1886\" being shown. All in-game graphics and exclusive to PS4.\n\n6:54PM: Showing PS4 highlights for upcoming games. Killzone: Shadow Fall, Driveclub, InFamous: Second Son and Knack. \n\n6:59PM: Shu Yoshida. All games shown in the highlight (except InFamous) will launch together with the PS4.\n\n7:00PM: New real time tech-demo being shown. The Dark Sorcerer.\n\n7:02PM: Shu Yoshida is back on stage. The rest of The Dark Sorcerer will be streamed live and on YouTube.\n\n7:03PM: Adam Boyes comes on stage.\n\n7:04PM: Supergiant Games comes on stage (creators of Bastion). Shows Transistor which will come to the PS4 early next year.\n\n7:06PM: Indie developers will be able to self publish their own games on the PS4 and Vita.\n\n7:07PM: Indie games like: Don't Starve, Mercenary Kings, Octodad: Dadliest Catch, Secret Ponchos, Ray's Dead, Outlast, Oddworld: New &amp; Tasty (remkake of the first Oddworld game), Galaks and more are all coming exclusively to the PS4.\n\n7:11PM: There will be exclusive items for Diablo 3 on the PS3 and PS4. There will also be more exclusive content from Blizzard in the future.\n\n7:12PM: Final Fantasy Versus XIII has been renamed to Final Fantasy XV.\n\n7:16PM: Kingdom Hearts 3 announced.\n\n7:18PM: Both Final Fantasy XV and Kingdom Hearts 3 are coming to the PS4 (but he didn't say that they were exclusive). Final Fantasy XIV is however exclusive on the PS3 and PS4.\n\n7:19PM: Assassins Creed: Black Flag gameplay being shown.\n\n7:25PM: Jonathan Morin comes on stage. Talks about Watch Dogs.\n\n7:26PM: Watch Dogs gameplay being shown.\n\n7:33PM: There will be exclusive 1 hour extra gameplay and costume for Watchdogs on the Playstation.\n\n7:34PM: NBA2K14 shown.\n\n7:35PM: Announced partnership with Bethesda Softworks. Elder Scrolls Online trailer being shown. Coming to PS4 spring 2014.\n\n7:37PM: The Elder Scrolls Online beta will be exclusive on the PS4 first.\n\n7:38PM: Mad Max game announced. Exclusive survival gear/content for the Playstation.\n\n7:40PM: Jack Tretton is back on stage. Talking about exclusive content on the Playstation.\n\n7:41PM: **THE PS4 WILL SUPPORT USED GAMES!** The crowd goes wild! People in the audience are chanting \"Sony! Sony! Sony!\"\n\n7:42PM: **THE PS4 DOES NOT NEED TO BE CONNECTED ONLINE OR BE AUTHENTICATED. WILL NOT CHECK FOR INTERNET CONNECTION WHEN YOU PLAY. WILL NOT CHECK FOR INTERNET CONNECTION IN ANY WAY LIKE THE XBOX ONE!**\n\n7:44PM: Playstation+ service will be expanded and built upon. It will automatically carry over to the PS4. If you're PS+ member today (or in the future) you'll be set for the upcoming console.\n\n7:45PM: PS+ members will receive Driveclub PS+ Edition for free when the PS4 launches. You also get Don't Starve, Outlast and Secret Ponchos for free.\n\n7:47PM: Destiny gameplay being shown for the first time. Looks like the game is class based. Warlock, Hunter and Titan classes revealed. Magic abilities combined with technology (or extremely advanced weaponry which looks like magic)? Heavily loot driven game, similar to Borderlands? You're able to drive speeder bikes and fight together (or against each other) in large teams. Coming 2014.\n\n7:59PM: Sony has announced a partnership with Activision and Bungie.\n\n8:00PM: Gaikai Online Gaming Library announced. The cloud gaming service will be available for the PS3, PS4 and VITA in 2014. First available in the US.\n\n8:02PM: **The PS4 will cost $399, \u20ac399, \u00a3349.** Coming this Holliday season.\n\n8:03PM: The conference is over. Ending with a montage.\n____________________\n\nThanks for tuning in everybody, this has been a very hectic and stressful day. I need to take a long break now.");
                XCTAssertEqualObjects(link.ID, @"1g3347");
                XCTAssertTrue(link.fullName, @"t3_1g3347");
                XCTAssertEqualObjects(link.author, @"foamed");
                XCTAssertEqualObjects(link.subredditID, @"t5_2qhwp");
                XCTAssertEqualObjects(link.permalink, @"/r/Games/comments/1g3347/official_rgames_sony_e3_conference_thread/?ref=search_posts");
                XCTAssertEqualObjects(link.url, @"https://www.reddit.com/r/Games/comments/1g3347/official_rgames_sony_e3_conference_thread/");
                XCTAssertEqualObjects(link.title, @"Official /r/Games Sony E3 conference thread.");
                XCTAssertEqualObjects(link.createdUTC, [NSDate dateWithTimeIntervalSince1970:1370911583.0]);
            }
                break;
                
            default:
                break;
        }
    }
}

@end
