# docker-compose Icinga stack

docker-compose configuration to start-up an Icinga stack containing
Icinga 2, Icinga Web 2 and Icinga DB.

Ensure you have the latest Docker and docker-compose versions and
then just run `docker-compose -p icinga up` in order to start the Icinga stack.

Icinga Web is provided on port **8080** and you can access the Icinga 2 API on port **5665**.

Passwords are set by creating a .env file in the root of the repository with these keys:

        ICINGADB_MYSQL_PASSWORD=passwords_here
        ICINGAWEB_MYSQL_PASSWORD=passwords_here
        ICINGAWEB_ICINGA2_API_USER_PASSWORD=passwords_here
        ICINGAWEB_ADMIN_PASSWORD=passwords_here
        ICINGA_API_ROOT_PASWORD=passwords_here

Look at the Makefile to trigger many usefull operations and also switch to podman by prefixing make commands like this:

        make start # start with docker-compose
        make podman start # start with podman-compose
