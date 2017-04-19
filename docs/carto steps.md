Steps to reproduce and test solution for ["force" user deletion for EUMAPI #11654](https://github.com/CartoDB/cartodb/issues/11654)

1.  Init environment (using <https://github.com/teanocrata/carto.git> project with dockerized environment)
    ```
    $ docker-compose -f docker-compose.development.yml up -d
    $ docker exec -ti carto_docker-cartodb_1 bash
    ```
1.  Create a development user from cartodb machine:
    ```
    # sh script/create_dev_user'
    ```
    With options when prompt: user/pass development/development email development@test.com
1.  Start assets server
    ```
    # export RAILS_ENV=development
    # bundle exec grunt --environment development dev
    ```
1.  Open a new console and start rails server
    ```
    $ docker exec -ti carto_docker-cartodb_1 bash
    # export RAILS_ENV=development
    # bundle exec rails server
    ```
1.  At host add entries to /etc/hosts needed in development
    ```
    $ echo "127.0.0.1 development.localhost.lan" | sudo tee -a /etc/hosts
    ```
1.  Login with development user and get API key
    Open a web browser and go to <http://development.localhost.lan:3000/me>
    Login with development/development
    Go to <http://development.localhost.lan:3000/your_apps> and get the API key
    API key: 6c3e8336532a5889177a156706f76595634880bc

## User admin (Test from spec/requests/admin/users_controller_spec.rb)

### Delete development user with web app (spec/requests/admin/users_controller_spec.rb:'deletes if password match')

1.  Go to <http://development.localhost.lan:3000/account> and click on "Delete my account and all my data" at the bottom of the page withouth force delete

**Should return to home and show 404 page because user has be deleted**

### Delete development user with web app (spec/requests/admin/users_controller_spec.rb:'should not delete if password match but has unregistered tables')

1.  Open a new console
    ```
    $ docker exec -ti carto_docker-cartodb_1 bash
    # export RAILS_ENV=development
    ```
1.  Create a development user
    From cartodb machine:
    ```
    # sh script/create_dev_user'
    ```
1.  Login with development and get API key
    Open a web browser and go to <http://development.localhost.lan:3000/me>
    Login with development/development
    Go to <http://development.localhost.lan:3000/your_apps> and get the API key
    API key: 651bb9271a1bc0fb565151fd7511511267048fdd
1.  Create a table with the SQL with development user  <https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API)>
    <http://development.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=651bb9271a1bc0fb565151fd7511511267048fdd>
1.  Delete development user with web app
    Go to <http://development.localhost.lan:3000/account> and click on "Delete my account and all my data" at the bottom of the page withouth force delete

**Should find the error message: "Error deleting user: Cannot delete user, Has unregistered tables, force deletion available. "**

### (spec/requests/admin/users_controller_spec.rb:'deletes if password match, has unregistered tables and force_param')

Now, check "Force deletion" Toggle and click on "Delete my account and all my data"

**Should return to home and show 404 page because user has be deleted**

### Delete development user with web app (spec/requests/admin/users_controller_spec.rb: 'should delete if password match and has ghost tables')
1.  Create a development user
    From cartodb machine:
    ```
    # sh script/create_dev_user
    ```
1.  Login with development and get API key
    Open a web browser and go to <http://development.localhost.lan:3000/me>
    Login with development/development
    Go to <http://development.localhost.lan:3000/your_apps> and get the API key
    API key: c608976107f7d9bc156ce86a6f3d7616f10acd93
1.  Create a table with the SQL with development user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://development.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=c608976107f7d9bc156ce86a6f3d7616f10acd93>
1.  Cartodbfy table
    <http://development.localhost.lan:8080/api/v2/sql?q=SELECT%20cdb_cartodbfytable(%27bla%27);&api_key=c608976107f7d9bc156ce86a6f3d7616f10acd93>
1.  Delete development user with web app
    Go to <http://development.localhost.lan:3000/account> and click on "Delete my account and all my data" at the bottom of the page withouth force delete

**Should return to home and show 404 page because user has be deleted**

### Delete development user with web app (spec/requests/admin/users_controller_spec.rb: 'should not delete if password match but has unregistered tables')

1.  Create a development user
    From cartodb machine:
    ```
    # sh script/create_dev_user
    ```
1.  Login with development and get API key
    Open a web browser and go to <http://development.localhost.lan:3000/me>
    Login with development/development
    Go to <http://development.localhost.lan:3000/your_apps> and get the API key
    API key: c608976107f7d9bc156ce86a6f3d7616f10acd93
1.  Create a table with the SQL with development user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://development.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=c608976107f7d9bc156ce86a6f3d7616f10acd93>
1.  Delete development user with web app
    Go to <http://development.localhost.lan:3000/account> and click on "Delete my account and all my data" at the bottom of the page withouth force delete

**Should find the error message: "Error deleting user: Cannot delete user, Has unregistered tables, force deletion available. "**

### Delete development user with web app, with unregistered tables and force param (spec/requests/admin/users_controller_spec.rb: 'deletes if password match, has unregistered tables and force_param')

Now, check "Force deletion" Toggle and click on "Delete my account and all my data"

**Should return to home and show 404 page because user has be deleted**

## EUMAPI (spec/requests/carto/api/organization_users_controller_spec.rb)

1.  Create a development user
    From cartodb machine:
    ```
    # sh script/create_dev_user'
    ```
1.  Login with development and get API key
    Open a web browser and go to <http://development.localhost.lan:3000/me>
    Login with development/development
    Go to <http://development.localhost.lan:3000/your_apps> and get the API key
    API key: 21b4933b346d01c3f20c4e858c0a8ac168193dad
1.  Create an organization with 2 GB of space
    From cartodb machine:
    ```
    # bundle exec rake cartodb:db:create_new_organization_with_owner ORGANIZATION_NAME="testorg" ORGANIZATION_DISPLAY_NAME="Test Organization Inc." ORGANIZATION_SEATS="5" ORGANIZATION_QUOTA="2147483628" USERNAME="development"
    ```
1.  At host add entries to /etc/hosts needed in development
    ```
    $ echo "127.0.0.1 testorg.localhost.lan" | sudo tee -a /etc/hosts
    ```

### Delete org-user with EUMAPI (spec/requests/carto/api/organization_users_controller_spec.rb: 'should delete users')

1.  Create a user in the organization with write permission (builder) with EUMAPI
    ```
    $ curl -H 'Content-Type: application/json' http://testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users -X POST --data '{"username":"org-user", "email":"org-user@test.com", "password":"secret!", "api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
    ```
1.  At host add entries to /etc/hosts needed in development
    ```
    $ echo "127.0.0.1 org-user.localhost.lan" | sudo tee -a /etc/hosts
    ```
1.  Login with org-user and get API key
    At <http://testorg.localhost.lan:3000> with org-user/secret!
    Go to <http://testorg.localhost.lan:3000/u/org-user/your_apps>
    API key 89b4e4a3bf440ef3521e10b4e605113879aa0060
1.  Delete org-user with EUMAPI
    ```
    curl -H 'Content-Type: application/json' testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users/org-user -X DELETE --data '{"api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
    ```

**Should: "User deleted"**

### Delete org-user with EUMAPI (spec/requests/carto/api/organization_users_controller_spec.rb: 'should delete users with ghost tables')

1.  Create a user in the organization with write permission (builder) with EUMAPI
    ```
    curl -H 'Content-Type: application/json' http://testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users -X POST --data '{"username":"org-user", "email":"org-user@test.com", "password":"secret!", "api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
    ```
1.  Login with org-user and get API key
    At <http://testorg.localhost.lan:3000>   org-user/secret!
    At <http://testorg.localhost.lan:3000/u/org-user/your_apps>
    API key 0f442c7bb1abec58a22811602896bc1283e438c7
1.  Create a table with the SQL with org-user user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://org-user.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=0f442c7bb1abec58a22811602896bc1283e438c7>
1.  Cartodbfy table
    <http://org-user.localhost.lan:8080/api/v2/sql?q=SELECT%20cdb_cartodbfytable(%27org-user%27,%27bla%27);&api_key=0f442c7bb1abec58a22811602896bc1283e438c7>
1.  View tables for user
    <http://org-user.localhost.lan:8080/api/v2/sql?q=SELECT%20CDB_UserTables(%27all%27);&api_key=0f442c7bb1abec58a22811602896bc1283e438c7>
1.  Delete org-user with EUMAPI
    ```
    curl -H 'Content-Type: application/json' testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users/org-user -X DELETE --data '{"api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
    ```

**Should: "User deleted"**

### Delete org-user with EUMAPI (spec/requests/carto/api/organization_users_controller_spec.rb: 'should not delete users with unregistered tables')

1.  Create a user in the organization with write permission (builder) with EUMAPI
    ```
    curl -H 'Content-Type: application/json' http://testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users -X POST --data '{"username":"org-user", "email":"org-user@test.com", "password":"secret!", "api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
1.  Login with org-user and get API key
    At <http://testorg.localhost.lan:3000>   org-user/secret!
    At <http://testorg.localhost.lan:3000/u/org-user/your_apps>
    API key 6282050949b7ca5471563216c8acb38e817a2605
1.  Create a table with the SQL with org-user user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://org-user.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=6282050949b7ca5471563216c8acb38e817a2605>
1.  Delete org-user with EUMAPI
    ```
    curl -H 'Content-Type: application/json' testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users/org-user -X DELETE --data '{"api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad"}'
    ```

**Should: "User couldn't be deleted:  Cannot delete user, Has unregistered tables, force deletion available."**

### Delete org-user with EUMAPI and force param (spec/requests/carto/api/organization_users_controller_spec.rb: 'should delete users with unregistered tables when force')

1.  ```
    curl -H 'Content-Type: application/json' testorg.localhost.lan:3000/u/development/api/v1/organization/testorg/users/org-user -X DELETE --data '{"api_key":"21b4933b346d01c3f20c4e858c0a8ac168193dad", "force_delete": "true"}'
    ```

**Should: "User deleted"**

## Organization admin (spec/requests/admin/organization_users_controller_spec.rb)

### Delete org-user with organization admin (spec/requests/admin/organization_users_controller_spec.rb: 'deletes users')
1.  Create a user in the organization
    Login into <http://testorg.localhost.lan:3000> with development/development
    At <http://testorg.localhost.lan:3000/u/development/organization>
    Add user > Create user >
    Username: org-user
    email: org-user@test.com
    password: secret!
    Click on Create User
1.  Delete org-user with organization admin (spec/requests/admin/organization_users_controller_spec.rb: 'deletes users')
    At <http://testorg.localhost.lan:3000/u/development/organization/users/org-user/edit>
    At the bottom of the page click on DELETE USER

**Should: "User was successfully deleted."**

### Delete org-user with organization admin (spec/requests/admin/organization_users_controller_spec.rb: 'should not delete users with unregistered tables')

1.  Create a user in the organization
    Login into <http://testorg.localhost.lan:3000> with development/development
    At <http://testorg.localhost.lan:3000/u/development/organization>
    Add user > Create user >
    Username: org-user
    email: org-user@test.com
    password: secret!
    Click on Create User
1.  Get org-user API Key
    Click on org-user
    At the bottom of the page, User API Key: 75d3590ceb0264b5e553e5dfa436b7b5ab2a348d
1.  Create a table with the SQL with org-user user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://org-user.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=75d3590ceb0264b5e553e5dfa436b7b5ab2a348d>
1.  Delete org-user with organization admin (spec/requests/admin/organization_users_controller_spec.rb: 'should not delete users with unregistered tables')
    At <http://testorg.localhost.lan:3000/u/development/organization/users/org-user/edit>
    At the bottom of the page click on DELETE USER

**Should: "User was not deleted. Cannot delete user, Has unregistered tables, force deletion available. "**
### Delete org-user with organization admin and force delete (spec/requests/admin/organization_users_controller_spec.rb: 'should delete users with unregistered tables when force')

1.  At <http://testorg.localhost.lan:3000/u/development/organization/users/org-user/edit>
    At the bottom of the page click on toggle button "Ferce delete" and click on DELETE USER

**Should: "User was successfully deleted. "**

### Delete org-user with organization admin (spec/requests/admin/organization_users_controller_spec.rb: 'should delete users with ghost tables')

1.  Create a user in the organization
    Login at <http://testorg.localhost.lan:3000> with development/development
    At <http://testorg.localhost.lan:3000/u/development/organization>
    Add user > Create user >
    Username: org-user
    email: org-user@test.com
    password: secret!
    Click on Create User
1.  Get org-user API Key
    Click on org-user
    At the bottom of the page, User API Key: 59b5ce7f0b0616481693e7f213e3e985011aeb98
1.  Create a table with the SQL with org-user user (<https://github.com/CartoDB/cartodb/wiki/creating-tables-though-the-SQL-API>)
    <http://org-user.localhost.lan:8080/api/v2/sql?q=create%20table%20bla%20(whatever%20int);&api_key=59b5ce7f0b0616481693e7f213e3e985011aeb98>
1.  Cartodbfy table
    <http://org-user.localhost.lan:8080/api/v2/sql?q=SELECT%20cdb_cartodbfytable(%27org-user%27,%27bla%27);&api_key=59b5ce7f0b0616481693e7f213e3e985011aeb98>
1.  Delete org-user with organization admin
    At <http://testorg.localhost.lan:3000/u/development/organization/users/org-user/edit>
    At the bottom of the page click on DELETE USER

**Should: "User was successfully deleted. "**
