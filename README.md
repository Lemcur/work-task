### Start the project

You need ruby stated in `.ruby-version`
Then run `bundle install`
`rails db:setup` for the DB - make sure you've got postgresql 14 installed

### Tests

Only tests I've devised are request tests, that should test whole application top to bottom.
Model validations with `shoulda_matchers`, and service should also be tested in normal, production settings.

### Data model

I've decided to split the customizable questions into two categories, values (strings/number) and choices(single/multiple) - as these are fundamentally different in validation/inclusion, but then Single Table Inheritance allows us to extend the functionality if we wanted to add a different choice question, like UpToTwoChoices

There may be a reason to decouple Question from the User, and introduce Answer (`belongs_to :user, belongs_to: :question`) that, when present, allows user to answer question, so that Questions (like age - quite universal) do not exist for each separate user

### Refactoring 

`EditValueService` currently has a long condition, should be refactored into a Strategy pattern

Controller does quite a lot, but that's needed so we do not apply changes into some question and still return error.
We validate before opening transaction to the database, as in case with many answers provided, and the last one is invalid, would rollback many records, posing a bottleneck on the DB.

### API error handling

When an error occurs on our end, it's good practice to not guide FE's message to the user by our BE error, this can be done by introducing error codes (whether strings or integers). This way, when we have not handled something correctly, and there is no code, the app will know not to render the message that says `MYSQLError: No table my_table`.
I've introduced simple implementation of such feature.
