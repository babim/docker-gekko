# docker-gekko
```
docker run -p 3000:3000 babim/gekko

-e ADAPTER=mongodb

volumes:
      - ./volumes/gekko/history:/usr/src/app/history
      - ./config.js:/usr/src/app/config.js
    links:
      - redis
      - postgresql
    environment:
     - HOST
- PORT
```
