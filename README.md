# backend-code-test
Code test for the backend position

## Requirements for the task:
- If everything is setup correctly, you should be able to run `bin/setup` and get a green RSpec run.
  - If you are running an older version of PostgreSQL, and aren't able to get the structure to the database, check db/structure.sql:12-15
- Remember that you are building an API for the frontend to consume.
- Use Rails 6
- Use jsonapi-serializer for json serialization (https://github.com/jsonapi-serializer/jsonapi-serializer)
  - Response should be JSON:API-compliant (https://jsonapi.org)
  - No need to create includes or sparse fieldsets to be configurable from the client-side, if you don't want to.
  - Meaning you have to have includes in the response, but you can configure them directly in the controller via static string when you call a serializer.
  - No need to have links, if you don't want to.
- Use RSpec request specs for testing.
- Use the authentication found in this repo, it's there to give you a quick start on this test.
  - See welcome_spec.rb & base_controller.rb for examples.
- A couple of lines of sql is included so that you don't have to create the database structure completely by yourself. See db/structure.sql.



## Task 1:
Create 1 endpoint which returns data in a way that a frontend can show the follow data with only making one request:
- Client needs to show all the time slots in an event.
- Client needs to show all the time slots in an event, with the current user's active meetings.
  - If status is cancelled or rejected meetings shouldn't be shown, check Meeting-model for enum.
- Client needs to show all the time slots in an event, with the related users who have bookmarked timeslots.

##### Use-case:
To show a schedule for an event, to see if there are any meetings booked for me,
    and to see users who participate in timeslots, so I could book meetings with them.

##### Context:
In Brella's context, there can be:
- Thousands of events,
- Hundreds of timeslots in an event,
- Tens of thousands meetings in an event.

## Task 2:
- With the endpoint you created, list out what kind of problems you ran into and foresee in the future.
- List out solutions that you would do for the endpoint that would make it better.
    (For example from the view of scalability, readability, architecture)
- If you would have one week to implement some of those solutions, which would you pick and why?
  - Remember: This task is quite abstract, and there's no right answer.


------------------------------------------------------------------------------------------------------------

- With the endpoint you created, list out what kind of problems you ran into and foresee in the future.

    1. N+1 Problem
         (This API return nested resources information, if we are not careful while fetching the data we will endup having db spikes.
          This will increases the API response time exponentially when the data starts growing)

    2. Conditional Preload
         (There isn't an easy way to filter preloaded data in Active Record, I had to use "Preloader API" to filter the meetings 
          which are active and belongs to user, which increased the speed of the API exponentially.
          We can use the same to filter on other entities also if required)

  Foresee:

    3. Lack of pagination will increase the intial load time of the page.
    4. Loading nested resources in the single API call might leads to performance related issues when the data in the system increases.
    5. Database Indexes (Composite indexing is must)


- List out solutions that you would do for the endpoint that would make it better.

    1. API Pagination
    2. Lazy Loading of nested resources. (Like fetching Associated meetings or Associated users on demand)
    3. Service Objects (Abstracting and Isolating the business logic into services)
    4. Profilig (Integrating tools to detecting slow SQL Queries)
    5. API Caching
    6. Microservices (Application Level)
    7. Master Slave or Sharding at Database level

- If you would have one week to implement some of those solutions, which would you pick and why?

    I would prefer to implement these 4 solution ( API Pagination, Lazy Loading, Service Objects, Profiling),
    since these are must for any type of system independent of scale.
    
    
    Other items like (API Caching, Microservices, DB Master Slave or Sharding) are definitely the next level of activities any Scalable system should follow.
    But lot of parameters have to be considered before getting into these activities.

    1. API Pagination

        API Pagination should be the first options when we know the system is going to have more data.
        Benefits with pagination:

        - DB Queries and serialization will be faster. (Since we fetch fixed set of data with filters)
        - Reduces burden on client. (Client doesn't need to download more data)

   2. Lazy Loading of nested resources. (Like fetching Associated meetings or Associated users on demand)

        When the data is huge, the client applications might take lot of time to load the page.(Initial load time of the page)
        It's always a good practice to load the content when required, which makes the client page light weight.

        Example: (This is a general usecase, but the actual one might change depends upon the requirement)
        In the above API, we are fetching all the meetings associated to a timeslots. (In case if the meetings count is more it will impact the page load time)
        Instead if we fetch the meetings when user clicks on specific timeslots, we could avoid the page load delay.

   3. Service Objects (Abstracting and Isolating the business logic into services)

        This is very important when the code base is growing faster, we have to organize the code better.
        Abstracting into services helps to narrow down the complexity. It helps to do better testing and code refactoring.
        In future it would be easy to migrate into micro services if required.

   4. Profiling ( Integrating tools to detecting slow SQL Queries)

        We should integrate different tools to do profiling, which helps us to write better code in efficient way.
