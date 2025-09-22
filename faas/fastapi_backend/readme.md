# run the application

uvicorn api:app --reload

cd faas/fastapi-backend
vercel --prod

## vercel json

poetry export -f requirements.txt --output requirements.txt
