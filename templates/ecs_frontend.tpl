[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${project_name}-${environment}-frontend",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": ${ecs_task_frontend_cpu},
    "memory": ${ecs_task_frontend_memory},
    "name": "${project_name}-${environment}-frontend",
    "image": "micic/vortexwest:frontend",
    "essential": true,
    "dockerLabels": {
      "Name": "${project_name}-${environment}-backend"
    }
  }
]