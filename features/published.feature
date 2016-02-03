Feature: Unpublished site section
  Scenario: Unpublished site sections show up in the preview server
    Given the Server is running at "published-app"
    When I go to "/"
    Then I should see "Environment: development"
    When I go to "/published/"
    Then I should see "Published Site Part Content"
    When I go to "/unpublished/"
    Then I should see "This is a draft"
    When I go to "/unpublished/example.txt"
    Then I should see "Example Text"
    When I go to "/future/"
    Then I should see "Future Site Part"

  Scenario: Unpublished site sections are hidden in :production environment by default
    And a fixture app "published-app"
    And a file named "config.rb" with:
      """
      set :environment, :production
      activate :weby
      activate :directory_indexes
      """
    Given the Server is running at "published-app"
    When I go to "/published/"
    Then I should see "Published Site Part Content"
    When I go to "/unpublished/"
    Then I should see "Not Found"
    When I go to "/unpublished/example.txt"
    Then I should see "Not Found"
    When I go to "/future/"
    Then I should see "Not Found"

  Scenario: Unpublished site sections are hidden in :production environment except ones hidden because published in future if `publish_future_dated` set
    And a fixture app "published-app"
    And a file named "config.rb" with:
      """
      set :environment, :production
      activate(:weby) { |web| web.publish_future_dated = true }
      activate :directory_indexes
      """
    Given the Server is running at "published-app"
    When I go to "/published/"
    Then I should see "Published Site Part Content"
    When I go to "/unpublished/"
    Then I should see "Not Found"
    When I go to "/unpublished/example.txt"
    Then I should see "Not Found"
    When I go to "/future/"
    Then I should see "Future Site"

  Scenario: Unpublished site sections don't get built in production environment
    And a fixture app "published-app"
    And a file named "config.rb" with:
      """
      set :environment, :production
      activate :weby
      activate :directory_indexes
      """
    Given a successfully built app at "published-app"
    When I cd to "build"
    Then the following files should not exist:
      | future/index.html       |
      | unpublished/index.html  |
      | unpublished/example.txt |
    Then the following files should exist:
      | published/index.html    |

  Scenario: Unpublished site sections get built in development environment
    Given a successfully built app at "published-app"
    When I cd to "build"
    Then the following files should exist:
      | published/index.html    |
      | future/index.html       |
      | unpublished/index.html  |
      | unpublished/example.txt |
