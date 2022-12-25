   # 1. Rewarding Most Loyal Users: Find the 5 oldest users of the Instagram from the database provided

            with oldest_users as
               (
               select username, created_at
               from ig_clone.users
               order by created_at
               limit 5
               )
               select * from oldest_users;

   # 2. Remind Inactive Users to Start Posting: Find the users who have never posted a single photo on Instagram

            select u.username
            from ig_clone.users u
            left join ig_clone.photos p
            on u.id = p.user_id
            where p.user_id is null 
            order by u.username;

   #3. Declaring Contest Winner: Identify the winner of the contest and provide their details to the team
 
            with most_likes as
            (
            select likes.Photo_id , users.username , count(likes.User_id) as like_user
            from ig_clone.likes likes
            inner join ig_clone.photos photos
            on likes.photo_id = photos.id
            inner join ig_clone.users users
            on photos.user_id = users.id
            group by likes.Photo_id , users.username
            order by like_user desc
            limit 1
            )
            select username, photo_id, like_user from most_likes;
  
   #4. Hashtag Researching: Identify and suggest the top 5 most commonly used hashtags on the platform

            select t.tag_name, count(p.photo_id) as num_tags
            from ig_clone.photo_tags p
            inner join ig_clone.tags t
            on p.tag_id = t.id
            group by tag_name
            order by num_tags desc
            limit 5;

   #5. Launch AD Campaign: What day of the week do most users register on? Provide insights on when to schedule an ad campaign

            select 
            dayname(date(created_at)) as Day_Name,
            count(dayname(date(created_at))) as user_registered
            from ig_clone.users
            group by Day_Name
            order by user_registered desc;

   #6. User Engagement: Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users

       Average user posts:
            with CTE as 
            (
            select u.id as userid, count(p.id) as photoid
            from ig_clone.users u
            left join ig_clone.photos p
            on u.id = p.user_id
            group by u.id
            )
            select sum(photoid)/count(userid) as avg_user_post 
            from CTE
            where photoid > 0;

       Photos per user:
            with CTE as 
            (
            select u.id as userid, count(p.id) as photoid
            from ig_clone.users u
            left join ig_clone.photos p
            on u.id = p.user_id
            group by u.id
            )
            select 
               sum(photoid) as total_photos,
               count(userid) as total_users,
               sum(photoid)/count(userid) as photos_per_user
            from CTE;

   #7. Bots & Fake Accounts: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).

            select user_id, count(photo_id) as num_likes
            from ig_clone.likes
            group by user_id
            having count(photo_id) = (select count(*) from ig_clone.photos);


