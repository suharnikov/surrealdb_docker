FROM surrealdb/surrealdb:latest AS surreal_source
# We have no any default utils in this image, even bash or any other shell

FROM debian:stable-slim AS mediator
# because we need to use the mediator-image to make changes

COPY --from=surreal_source /etc/group /
COPY --from=surreal_source /etc/passwd /
COPY --from=surreal_source /etc/shadow /

# Just append the new user to the group
RUN echo "surrealdb:x:1000:1000:Surrealdb User:/home/nonroot:/bin/bash" >> /passwd
RUN echo "surrealdb:x:1000:" >> /group
RUN echo "surrealdb:!::0:::::" >> /shadow

# Prepare a dir to store the database (we can't create a dir in the surrealdb image...)
RUN mkdir /var/surreal_data/


# --- Result image ---
FROM surrealdb/surrealdb:latest

# We need to copy the new files from the mediator-image
COPY --from=mediator /passwd /etc/passwd
COPY --from=mediator /group /etc/group
COPY --from=mediator /shadow /etc/shadow

COPY --from=mediator --chown=surrealdb:surrealdb /var/surreal_data/ /var/surreal_data/

USER surrealdb

CMD ["start", "file:/var/surreal_data/surreal.db"]
