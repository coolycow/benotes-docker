#!/bin/sh
exec pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"