# Используем официальный образ Node.js в качестве базового
FROM node:16 AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install -f

# Копируем все файлы приложения в контейнер
COPY . .

# Собираем приложение
RUN npm run build

# Используем более легкий образ для запуска приложения
FROM node:16 AS runner

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированные файлы из предыдущего этапа
COPY --from=builder /app/ .

# Устанавливаем переменную среды для Next.js
ENV NODE_ENV=production

# Запускаем приложение
CMD ["npm", "start"]
