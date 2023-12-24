[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${project_name}-${environment}-backend",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "cpu": ${ecs_task_backend_cpu},
    "memory": ${ecs_task_backend_memory},
    "name": "${project_name}-${environment}-backend",
    "image": "micic/vortexwest:backend",
    "essential": true,
    "dockerLabels": {
      "Name": "${project_name}-${environment}-backend"
    },
    "entryPoint": [
      "sh",
      "-c"
    ],
    "command": [
      "/bin/sh -c 'python manage.py migrate && python manage.py runserver 0.0.0.0:8000'"
    ],
    "environment" : [
      {
        "name" : "POSTGRES_NAME",
        "value" : "${env_var_postgres_name}"
      },
      {
        "name" : "POSTGRES_USER",
        "value" : "${env_var_postgres_user}"
      },
      {
        "name" : "POSTGRES_PASSWORD",
        "value" : "${env_var_postgres_password}"
      },
      {
        "name" : "POSTGRES_HOST",
        "value" : "${env_var_postgres_host}"
      },
      {
        "name" : "POSTGRES_PORT",
        "value" : "${env_var_postgres_port}"
      }
    ]
  }
]