[![Build Status](https://travis-ci.com/otus-devops-2019-02/Tennki_microservices.svg?branch=master)](https://travis-ci.org/otus-devops-2019-02/Tennki_microservices)

# Tennki_microservices
Tennki microservices repository

# Docker-1
- Ознакомление с базовыми командами docker 
- Создан образ из контейнера
- Найдены отличия образа и контейнера по выводу команды docker inspect

В папке docker-monolith находится список докер-образов присутствующих на машине.


# Docker-2
- Создан новый проект в GCP. Протестировано использование docker machine совместно с GCP.
- Создан образ с приложением, mongo db и ruby. 
    Билд образа: docker build -t reddit:latest .
- Создан репозиторий на docker hub. Загружен полученный образ с приложением.
https://cloud.docker.com/u/tenki/repository/docker/tenki/otus-reddit
    Загрузка образа в репозиторий: docker push tenki/otus-reddit:1.0
- Запущен контейнер из созданного образа на docker-host в GCP.
    Запуск контейнера: docker run --name reddit -d -p 9292:9292 tenki/otus-reddit:1.0
- Создан прототип инфраструктуры в папке docker-monolith/infra
    - ansible
        Созданы прлейбуки для установки докер (base.yml) и запуска контейнера с приложением (deploy.yml). Плейбуки помечены тэгами.
        Запуск контейнера с приложением: ansible-playbook -i gcp.yml -t deploy playbooks/site.yml
        Установка докер: ansible-playbook -i gcp.yml -t base playbooks/site.yml
        Установка докер + запуск: ansible-playbook -i gcp.yml playbooks/site.yml
            Для установки докера использована роль nickjj.docker (https://github.com/nickjj/ansible-docker)
            Для запуска контейнера использован модуль docker_container
            В качестве динамического инвентари использован плагин gcp_compute
    - packer
        Создан шаблон для создания образа с установленным докером. В качестве провиженера для установки докера использован ansible (плейбук base.yml)
        Имя образа: docker-host-<timestamp>. Этот образ может быть использован terraform для поднятия инфраструктуры.
        Билд образа: packer build -var-file=packer/variables.json packer/docker-host.json
    - terraform
        Создан шаблон для развертывани compute инстансов для запуска контейнеров с приложением. Количество инстансов задается переменной (пример файла с переменными terraform.tfvars.example). Можно использовать базовый образ (в нашем случае ubuntu) или собранный пакером (docker-host), тогда не будет необходимости дополнительно устанавливать docker. Созданные инстансы включаются в группу для балансировки.
        Создается балансировщик нагрузки для доступа к приложению, аутпут переменная указывает на внешний ip балансировщика. При обращени на порт tcp/80 балансировщика мы попадаем на порт tcp/9292 одного из инстансов. 


# Docker-3
- Ознакомление с основами построения образов, использованием volume и network в docker.
- Созданы образы для микросервисов, post, comment, ui. Образы описаны dockerfile-ми, которые на ходятся в каталогах сервисов (./src/comment/; ./src/post-py/; ./src/ui/). В файлах Dockerfile.# содержатся описания разных версии образов.
- Выполнен запуск контейнеров из созданных образов на docker-host в GCP.
- Выполнен запуск контейнеров с другими сетевыми алиасами. 
Команды для запуска контейнеров с другими сетевыми алиасами:
docker run --rm -d --network=reddit --network-alias=post_db1 --network-alias=comment_db1 mongo:latest
docker run --rm -d --network=reddit --network-alias=post1 -e POST_DATABASE_HOST=post_db1 tenki/post:1.0
docker run --rm -d --network=reddit --network-alias=comment1 -e COMMENT_DATABASE_HOST=comment_db1 tenki/comment:1.0
docker run --rm -d --network=reddit -e POST_SERVICE_HOST=post1 -e COMMENT_SERVICE_HOST=comment1 -p 9292:9292 tenki/ui:1.0
- Выполнена оптимизация образов. Полученные образы загружены на docker hub.
tenki/post:3.0
tenki/comment:3.3
tenki/ui:4.6

