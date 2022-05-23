# Образ клиента 1С:Предприятие

[![CI](https://github.com/TheDemonCat/onec-client/actions/workflows/ci.yaml/badge.svg)](https://github.com/TheDemonCat/onec-client/actions/workflows/ci.yaml)

## Сборка 

1. Создать файл `.env` в корне проекта. В качестве примера использовать `.env.example`. В файле должны быть определены переменные:
```
    ONEC_USERNAME=<ПОЛЬЗОВАТЕЛЬ_USERS.1C.V8.RU>
    ONEC_PASSWORD=<ПАРОЛЬ_ОТ_USERS.1C.V8.RU>
    ONEC_VERSION=8.3.16.1659
    HASP_SERVER=<АдресСервераЛицензирования>
```
2. Запустить сборку образа с помощью скрипта

```
    ./make.sh
```

## Запуск клиента

1. Для запуска клиента, после сборки образов, можно воспользоваться двумя вариантами:

### Запуск контейнера для выполнения команды `1cv8`


Cоздание информационной базы:

```
docker run -u usr1cv8 -v $(pwd)/data:/home/usr1cv8/onec_data ghcr.io/thedemoncat/onec-client:8.3.18.1483 1cv8 CREATEINFOBASE file=/home/usr1cv8/onec_data /WA- /DisableStartupDialogs /DisableStartupMessages
```

### Запуск контейнера в режиме ожидания

```
docker run -u usr1cv8 --env CLIENT_WAITING=true -p 6080:6080 -v $(pwd)/data:/home/usr1cv8/onec_data ghcr.io/thedemoncat/onec-client:8.3.18.1483
```

В этом случае в контейнере запустится рабочий стол xfce4 и можно получить доступ к рабочему стол через NoVNC по URL http://localhost:6080/vnc.html.

### Дополнительно:

- команды `1cestart` и `1cv8` прописаны в PATH и доступна для быстрого доступа 