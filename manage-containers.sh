#!/bin/bash

# Docker Container Management Script
# Usage: ./manage-containers.sh [start|stop|restart|status|logs]

case "$1" in
    start)
        echo "Starting PostgreSQL and Redis containers..."
        docker-compose up -d
        echo "Containers started. Use './manage-containers.sh status' to check."
        ;;

    stop)
        echo "Stopping PostgreSQL and Redis containers..."
        docker-compose down
        echo "Containers stopped."
        ;;

    restart)
        echo "Restarting PostgreSQL and Redis containers..."
        docker-compose restart
        echo "Containers restarted."
        ;;

    status)
        echo "=== Container Status ==="
        docker-compose ps
        echo ""
        echo "=== Detailed Status ==="
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(NAMES|mercur-)"
        ;;

    logs)
        if [ -z "$2" ]; then
            echo "Showing logs for all containers..."
            docker-compose logs -f
        else
            echo "Showing logs for $2..."
            docker-compose logs -f "$2"
        fi
        ;;

    test)
        echo "Running connectivity tests..."
        ./test-db-redis-connectivity.sh
        ;;

    *)
        echo "Docker Container Management Script"
        echo "Usage: $0 {start|stop|restart|status|logs|test}"
        echo ""
        echo "Commands:"
        echo "  start   - Start PostgreSQL and Redis containers"
        echo "  stop    - Stop PostgreSQL and Redis containers"
        echo "  restart - Restart PostgreSQL and Redis containers"
        echo "  status  - Show container status"
        echo "  logs    - Show container logs (optional: specify container name)"
        echo "  test    - Run connectivity tests"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 logs postgres"
        echo "  $0 logs redis"
        exit 1
        ;;
esac