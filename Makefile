# Here if the command is dump, app or test, the script will capture ARG parameter
ifneq ($(filter $(MAKECMDGOALS), dump app test),) 
	ARG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  	$(eval $(ARG):;@:)
endif

build: destroy build_containers start remove_migrations migrate superuser populate
	@echo "Setup complete, your Containers are already running. Use 'make stop' to stop it."

build_containers:
	docker-compose --env-file ./.env up --no-start --force-recreate

destroy: stop
	docker-compose down --rmi local

migrations:
	@docker-compose exec web python manage.py makemigrations

migrate: migrations
	@docker-compose exec web python manage.py migrate

superuser:
	docker-compose exec web python manage.py createsuperuser --no-input

start:
	docker-compose start
	
stop:
	docker-compose stop 

restart: stop start
	@echo "Restarted containers!"

logs: start
	docker-compose logs -f web

populate:
	@docker-compose exec -T web python manage.py shell < ./scripts/populate_db.py

app: 
	@docker-compose exec web python manage.py startapp $(ARG) \
	&& sudo mv $(ARG) ./project/apps \
	&& sudo mkdir ./project/apps/$(ARG)/templates \
	&& sudo mkdir ./project/apps/$(ARG)/templates/$(ARG) \
	&& sudo chown -R $(USER): ./project/apps/$(ARG)

remove_migrations:
	@docker-compose exec -T web python manage.py shell < ./scripts/remove_migrations.py

dump:
	docker-compose exec web python manage.py dumpdata $(ARG) > fixtures/$(num)$(ARG).json

shell: 
	docker-compose exec web python manage.py shell

test:
	docker-compose exec web python manage.py test $(ARG) 
